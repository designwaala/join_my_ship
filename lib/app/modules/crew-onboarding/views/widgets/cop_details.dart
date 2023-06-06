import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:join_mp_ship/utils/extensions/date_time.dart';

class COPDetails extends GetView<CrewOnboardingController> {
  const COPDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Are you holding valid COP? *", style: _headingStyle),
          8.verticalSpace,
          Row(
            children: [
              Radio<bool>(
                  value: controller.isHoldingValidCOP.value ?? false,
                  groupValue: false,
                  onChanged: (_) {
                    controller.copIssuingAuthorities.clear();
                    controller.isHoldingValidCOP.value = false;
                  }),
              14.horizontalSpace,
              const Text("No")
            ],
          ),
          Row(
            children: [
              Radio<bool>(
                  value: controller.isHoldingValidCOP.value ?? false,
                  groupValue: true,
                  onChanged: (_) {
                    controller.isHoldingValidCOP.value = true;
                  }),
              14.horizontalSpace,
              const Text("Yes")
            ],
          ),
          if (controller.isHoldingValidCOP.value == true) ...[
            Row(
              children: [
                const Text("Issuing Authority"),
                const Spacer(),
                DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: null,
                    isExpanded: true,
                    items: ["Indian", "Panama", "Others"]
                        .map((e) => DropdownMenuItem(
                            value: e,
                            onTap: () {
                              if (controller.copIssuingAuthorities.any(
                                  (issuingAuthority) =>
                                      issuingAuthority.issuingAuthority == e)) {
                                controller.copIssuingAuthorities.removeWhere(
                                    (element) => element.issuingAuthority == e);
                              } else if (controller
                                      .copIssuingAuthorities.length <
                                  2) {
                                controller.copIssuingAuthorities
                                    .add(IssuingAuthority(issuingAuthority: e));
                              } else {
                                controller.fToast.showToast(
                                    child: errorToast(
                                        "You can select only 2 issuing authorities."));
                              }
                            },
                            child: Obx(() {
                              return Row(
                                children: [
                                  Checkbox(
                                      value: controller.copIssuingAuthorities
                                          .any((element) =>
                                              element.issuingAuthority == e),
                                      onChanged: (value) {
                                        if (controller.copIssuingAuthorities
                                            .any((issuingAuthority) =>
                                                issuingAuthority
                                                    .issuingAuthority ==
                                                e)) {
                                          controller.copIssuingAuthorities
                                              .removeWhere((element) =>
                                                  element.issuingAuthority ==
                                                  e);
                                        } else if (controller
                                                .copIssuingAuthorities.length <
                                            2) {
                                          controller.copIssuingAuthorities.add(
                                              IssuingAuthority(
                                                  issuingAuthority: e));
                                        } else {
                                          controller.fToast.showToast(
                                              child: errorToast(
                                                  "You can select only 2 issuing authorities."));
                                        }
                                      }),
                                  Text(e),
                                ],
                              );
                            })))
                        .toList(),
                    onChanged: (value) {},
                    hint: const Text("Select"),
                    buttonStyleData: ButtonStyleData(
                        height: 40,
                        width: 200,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(64),
                          border: Border.all(color: Get.theme.primaryColor),
                        )),
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
                    if (controller.step2FormMisses
                        .contains(Step2FormMiss.cocIssuingAuthority)) ...[
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
            ...controller.copIssuingAuthorities.map((issuingAuthority) =>
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(issuingAuthority.issuingAuthority ?? "")),
                      Expanded(
                        child: Builder(builder: (context) {
                          TextEditingController textEditingController =
                              TextEditingController();
                          textEditingController.text =
                              issuingAuthority.validTill ?? "";
                          return TextFormField(
                              controller: textEditingController,
                              validator: (value) {
                                if (value == null || value.isEmpty == true) {
                                  return "Please enter this field";
                                }
                                return null;
                              },
                              onTap: () async {
                                DateTime? selectedDateTime =
                                    await showDatePicker(
                                        context: Get.context!,
                                        initialDate:
                                            DateTime.parse("1990-01-01"),
                                        firstDate: DateTime.parse("1990-01-01"),
                                        lastDate: DateTime.now());
                                controller.copIssuingAuthorities
                                        .firstWhere((e) =>
                                            e.issuingAuthority ==
                                            issuingAuthority.issuingAuthority)
                                        .validTill =
                                    selectedDateTime?.getServerDate() ?? "";
                                textEditingController.text =
                                    selectedDateTime?.getServerDate() ?? "";
                              },
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Valid Till",
                                  isDense: true,
                                  suffixIcon: const Padding(
                                    padding: EdgeInsets.only(right: 16),
                                    child: Icon(
                                      Icons.calendar_month,
                                    ),
                                  ),
                                  suffixIconConstraints: const BoxConstraints(
                                      maxHeight: 32, maxWidth: 32),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Get.theme.primaryColor),
                                      borderRadius:
                                          BorderRadius.circular(64))));
                        }),
                      ),
                    ],
                  ),
                )),
          ]
        ],
      );
    });
  }

  TextStyle? get _headingStyle =>
      Get.textTheme.bodyMedium?.copyWith(color: Get.theme.primaryColor);
}
