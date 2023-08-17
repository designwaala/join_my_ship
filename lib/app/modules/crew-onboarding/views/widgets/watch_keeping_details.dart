import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:join_mp_ship/utils/extensions/date_time.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';

class WatchKeepingDetails extends GetView<CrewOnboardingController> {
  const WatchKeepingDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Are you holding Watch keeping? *", style: headingStyle),
          8.verticalSpace,
          Row(
            children: [
              Radio<bool>(
                  value: controller.isHoldingWatchKeeping.value ?? false,
                  groupValue: false,
                  onChanged: (_) {
                    controller.watchKeepingIssuingAuthorities.clear();
                    controller.isHoldingWatchKeeping.value = false;
                  }),
              14.horizontalSpace,
              const Text("No")
            ],
          ),
          Row(
            children: [
              Radio<bool>(
                  value: controller.isHoldingWatchKeeping.value ?? false,
                  groupValue: true,
                  onChanged: (_) {
                    controller.isHoldingWatchKeeping.value = true;
                  }),
              14.horizontalSpace,
              const Text("Yes")
            ],
          ),
          if (controller.isHoldingWatchKeeping.value == true) ...[
            Row(
              children: [
                const Expanded(child: Text("Issuing Authority")),
                20.horizontalSpace,
                Expanded(
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: null,
                      isExpanded: true,
                      style: Get.textTheme.bodySmall,
                      items: controller.watchKeepings
                          .map((e) => e.name)
                          .map((e) => DropdownMenuItem(
                              value: e,
                              onTap: () {
                                if (controller.watchKeepingIssuingAuthorities
                                    .any((issuingAuthority) =>
                                        issuingAuthority.issuingAuthority ==
                                        e)) {
                                  controller.watchKeepingIssuingAuthorities
                                      .removeWhere((element) =>
                                          element.issuingAuthority == e);
                                } else if (controller
                                        .watchKeepingIssuingAuthorities.length <
                                    2) {
                                  controller.watchKeepingIssuingAuthorities.add(
                                      IssuingAuthority(issuingAuthority: e));
                                } else {
                                  controller.fToast.safeShowToast(
                                      child: errorToast(
                                          "You can select only 2 issuing authorities."));
                                }
                              },
                              child: Obx(() {
                                return Row(
                                  children: [
                                    Checkbox(
                                        value: controller
                                            .watchKeepingIssuingAuthorities
                                            .any((element) =>
                                                element.issuingAuthority == e),
                                        onChanged: (value) {
                                          if (controller
                                              .watchKeepingIssuingAuthorities
                                              .any((issuingAuthority) =>
                                                  issuingAuthority
                                                      .issuingAuthority ==
                                                  e)) {
                                            controller
                                                .watchKeepingIssuingAuthorities
                                                .removeWhere((element) =>
                                                    element.issuingAuthority ==
                                                    e);
                                          } else if (controller
                                                  .watchKeepingIssuingAuthorities
                                                  .length <
                                              2) {
                                            controller
                                                .watchKeepingIssuingAuthorities
                                                .add(IssuingAuthority(
                                                    issuingAuthority: e));
                                          } else {
                                            controller.fToast.safeShowToast(
                                                child: errorToast(
                                                    "You can select only 2 issuing authorities."));
                                          }
                                        }),
                                    Text(e ?? ""),
                                  ],
                                );
                              })))
                          .toList(),
                      onChanged: (value) {},
                      hint: const Text("Select"),
                      buttonStyleData: ButtonStyleData(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(64),
                            border: Border.all(color: Get.theme.primaryColor),
                          )),
                    ),
                  ),
                ),
              ],
            ),
            16.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (controller.step2FormMisses.contains(
                        Step2FormMiss.watchKeepingIssuingAuthority)) ...[
                      4.verticalSpace,
                      Text("Please select this field",
                          style: Get.textTheme.bodySmall
                              ?.copyWith(color: Colors.red))
                    ]
                  ],
                ),
                20.horizontalSpace,
              ],
            ),
            ...controller.watchKeepingIssuingAuthorities.map(
                (issuingAuthority) => issuingAuthority.issuingAuthority ==
                        "Others"
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(issuingAuthority.issuingAuthority ?? ""),
                          4.verticalSpace,
                          Row(children: [
                            Expanded(
                              child: Builder(builder: (context) {
                                TextEditingController textEditingController =
                                    TextEditingController();
                                textEditingController.text =
                                    issuingAuthority.customName ?? "";
                                return CustomTextFormField(
                                    controller: textEditingController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty == true) {
                                        return "Please enter this field";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      controller.watchKeepingIssuingAuthorities
                                          .firstWhereOrNull((authority) =>
                                              authority.issuingAuthority ==
                                              "Others")
                                          ?.customName = value;
                                    },
                                    hintText: "Issuing Authority");
                              }),
                            ),
                            20.horizontalSpace,
                            Expanded(
                              child: Builder(builder: (context) {
                                TextEditingController textEditingController =
                                    TextEditingController();
                                textEditingController.text =
                                    issuingAuthority.validTill ?? "";
                                return CustomTextFormField(
                                    controller: textEditingController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty == true) {
                                        return "Please enter this field";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      controller.watchKeepingIssuingAuthorities
                                          .firstWhereOrNull((authority) =>
                                              authority.issuingAuthority ==
                                              "Others")
                                          ?.validTill = value;
                                    },
                                    onTap: () async {
                                      DateTime? selectedDateTime =
                                          await showDatePicker(
                                              context: Get.context!,
                                              initialDate:
                                                  DateTime.parse("1990-01-01"),
                                              firstDate:
                                                  DateTime.parse("1950-01-01"),
                                              lastDate:
                                                  DateTime.parse("2050-01-01"));
                                      controller.watchKeepingIssuingAuthorities
                                          .firstWhere((e) =>
                                              e.issuingAuthority ==
                                              issuingAuthority.issuingAuthority)
                                          .validTill = selectedDateTime
                                              ?.getServerDate() ??
                                          "";
                                      textEditingController.text =
                                          selectedDateTime?.getServerDate() ??
                                              "";
                                    },
                                    isDate: true,
                                    hintText: "Valid Till",
                                    icon: const Icon(
                                      Icons.calendar_month,
                                    ));
                              }),
                            ),
                          ])
                        ],
                      )
                    : Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text(
                                    issuingAuthority.issuingAuthority ?? "")),
                            20.horizontalSpace,
                            Expanded(
                              child: Builder(builder: (context) {
                                TextEditingController textEditingController =
                                    TextEditingController();
                                textEditingController.text =
                                    issuingAuthority.validTill ?? "";
                                return CustomTextFormField(
                                    controller: textEditingController,
                                    validator: (value) {
                                      if (value == null ||
                                          value.isEmpty == true) {
                                        return "Please enter this field";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      controller.watchKeepingIssuingAuthorities
                                          .firstWhereOrNull((authority) =>
                                              authority.issuingAuthority ==
                                              issuingAuthority.issuingAuthority)
                                          ?.validTill = value;
                                    },
                                    onTap: () async {
                                      DateTime? selectedDateTime =
                                          await showDatePicker(
                                              context: Get.context!,
                                              initialDate:
                                                  DateTime.parse("1990-01-01"),
                                              firstDate:
                                                  DateTime.parse("1990-01-01"),
                                              lastDate:
                                                  DateTime.parse("2050-01-01"));
                                      controller.watchKeepingIssuingAuthorities
                                          .firstWhere((e) =>
                                              e.issuingAuthority ==
                                              issuingAuthority.issuingAuthority)
                                          .validTill = selectedDateTime
                                              ?.getServerDate() ??
                                          "";
                                      textEditingController.text =
                                          selectedDateTime?.getServerDate() ??
                                              "";
                                    },
                                    isDate: true,
                                    hintText: "Valid Till",
                                    icon: const Icon(
                                      Icons.calendar_month,
                                    ));
                              }),
                            ),
                          ],
                        ),
                      )),
          ],
        ],
      );
    });
  }
}
