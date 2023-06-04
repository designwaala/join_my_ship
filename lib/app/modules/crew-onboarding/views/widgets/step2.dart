import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:join_mp_ship/utils/extensions/date_time.dart';

class CrewOnboardingStep2 extends GetView<CrewOnboardingController> {
  const CrewOnboardingStep2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Form(
          key: controller.formKeyStep2,
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 18.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                22.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Get.theme.primaryColor),
                    Container(
                      width: 18.w,
                      height: 2.h,
                      color: Get.theme.primaryColor,
                    ),
                    Icon(Icons.check_circle, color: Get.theme.primaryColor),
                    Container(
                      width: 18.w,
                      height: 2.h,
                      color: Colors.grey,
                    ),
                    const Icon(Icons.check_circle, color: Colors.grey),
                  ],
                ),
                22.verticalSpace,
                Text("Create Profile",
                    style: Get.theme.textTheme.headlineSmall),
                8.verticalSpace,
                Text("Please complete your profile",
                    style:
                        Get.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                24.verticalSpace,
                Row(
                  children: [
                    Text("INDOS NO.  *", style: _headingStyle),
                    48.horizontalSpace,
                    Expanded(
                      child: TextFormField(
                          controller: controller.indosNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              hintText: "INDOS Number",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Get.theme.primaryColor),
                                  borderRadius: BorderRadius.circular(64)))),
                    ),
                  ],
                ),
                8.verticalSpace,
                Text("CDC Number *", style: _headingStyle),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: controller.cdcNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              hintText: "CDC Number",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Get.theme.primaryColor),
                                  borderRadius: BorderRadius.circular(64)))),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: TextFormField(
                          controller: controller.cdcNumberValidTill,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? selectedDateTime = await showDatePicker(
                                context: Get.context!,
                                initialDate: DateTime.parse("1990-01-01"),
                                firstDate: DateTime.parse("1990-01-01"),
                                lastDate: DateTime.now());
                            controller.cdcNumberValidTill.text =
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
                                  borderSide:
                                      BorderSide(color: Get.theme.primaryColor),
                                  borderRadius: BorderRadius.circular(64)))),
                    ),
                  ],
                ),
                16.verticalSpace,
                Text("CDC / Seaman Book Details *", style: _headingStyle),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: controller.cdcSeamanNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              hintText: "CDC Number",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Get.theme.primaryColor),
                                  borderRadius: BorderRadius.circular(64)))),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: TextFormField(
                          controller: controller.cdcNumberValidTill,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? selectedDateTime = await showDatePicker(
                                context: Get.context!,
                                initialDate: DateTime.parse("1990-01-01"),
                                firstDate: DateTime.parse("1990-01-01"),
                                lastDate: DateTime.now());
                            controller.cdcNumberValidTill.text =
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
                                  borderSide:
                                      BorderSide(color: Get.theme.primaryColor),
                                  borderRadius: BorderRadius.circular(64)))),
                    ),
                  ],
                ),
                16.verticalSpace,
                Text("Passport Details *", style: _headingStyle),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: controller.cdcNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              isDense: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              hintText: "Passport Number",
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Get.theme.primaryColor),
                                  borderRadius: BorderRadius.circular(64)))),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: TextFormField(
                          controller: controller.passportValidTill,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? selectedDateTime = await showDatePicker(
                                context: Get.context!,
                                initialDate: DateTime.parse("1990-01-01"),
                                firstDate: DateTime.parse("1990-01-01"),
                                lastDate: DateTime.now());

                            controller.passportValidTill.text =
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
                                  borderSide:
                                      BorderSide(color: Get.theme.primaryColor),
                                  borderRadius: BorderRadius.circular(64)))),
                    ),
                  ],
                ),
                16.verticalSpace,
                Text("STCW Details *", style: _headingStyle),
                16.verticalSpace,
                const Text("Issuing Authority"),
                // 8.verticalSpace,
                // ...controller.stcwIssuingAuthority.map((e) => Text(e,
                //     style: Get.textTheme.bodyMedium
                //         ?.copyWith(color: Get.theme.primaryColor))),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            value: null,
                            isExpanded: true,
                            items: ["Indian", "Panama", "Others"]
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    onTap: () {
                                      if (controller.stcwIssuingAuthority
                                          .contains(e)) {
                                        controller.stcwIssuingAuthority
                                            .remove(e);
                                      } else if (controller
                                              .stcwIssuingAuthority.length <
                                          2) {
                                        controller.stcwIssuingAuthority.add(e);
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
                                              value: controller
                                                  .stcwIssuingAuthority
                                                  .contains(e),
                                              onChanged: (value) {
                                                if (controller
                                                    .stcwIssuingAuthority
                                                    .contains(e)) {
                                                  controller
                                                      .stcwIssuingAuthority
                                                      .remove(e);
                                                } else if (controller
                                                        .stcwIssuingAuthority
                                                        .length <
                                                    2) {
                                                  controller
                                                      .stcwIssuingAuthority
                                                      .add(e);
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
                                width: 176,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(64),
                                  border:
                                      Border.all(color: Get.theme.primaryColor),
                                )),
                          ),
                        ),
                        if (controller.step2FormMisses
                            .contains(Step2FormMiss.stcwIssuingAuthority)) ...[
                          4.verticalSpace,
                          Text("Please select this field",
                              style: Get.textTheme.bodySmall
                                  ?.copyWith(color: Colors.red))
                        ]
                      ],
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: TextFormField(
                          controller: controller.stcwDetailValidTill,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          onTap: () async {
                            DateTime? selectedDateTime = await showDatePicker(
                                context: Get.context!,
                                initialDate: DateTime.parse("1990-01-01"),
                                firstDate: DateTime.parse("1990-01-01"),
                                lastDate: DateTime.now());
                            controller.stcwDetailValidTill.text =
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
                                  borderSide:
                                      BorderSide(color: Get.theme.primaryColor),
                                  borderRadius: BorderRadius.circular(64)))),
                    ),
                  ],
                ),
                16.verticalSpace,
                if (![
                  "Deck Cadet",
                  "Trainee Electrical Cadet",
                  "Engine Cadet",
                  "Trainee Ordinary Seaman",
                  "Trainee Wiper"
                ].contains(controller.selectedRank.value?.name)) ...[
                  Text("Are you holding valid COC? *", style: _headingStyle),
                  8.verticalSpace,
                  Row(
                    children: [
                      Radio<bool>(
                          value: controller.isHoldingValidCOC.value ?? false,
                          groupValue: false,
                          onChanged: (_) {
                            controller.isHoldingValidCOC.value = false;
                          }),
                      14.horizontalSpace,
                      Text("No")
                    ],
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                          value: controller.isHoldingValidCOC.value ?? false,
                          groupValue: true,
                          onChanged: (_) {
                            controller.isHoldingValidCOC.value = true;
                          }),
                      14.horizontalSpace,
                      Text("Yes")
                    ],
                  ),
                  if (controller.isHoldingValidCOC.value == true) ...[
                    Text("Issuing Authority"),
                    16.verticalSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                value: null,
                                isExpanded: true,
                                items: [
                                  "Indian",
                                  "UK",
                                  "Singapore",
                                  "New Zealand",
                                  "Panama",
                                  "Honduras",
                                  "Others"
                                ]
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        onTap: () {
                                          if (controller.cocIssuingAuthority
                                              .contains(e)) {
                                            controller.cocIssuingAuthority
                                                .remove(e);
                                          } else if (controller
                                                  .cocIssuingAuthority.length <
                                              2) {
                                            controller.cocIssuingAuthority
                                                .add(e);
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
                                                  value: controller
                                                      .cocIssuingAuthority
                                                      .contains(e),
                                                  onChanged: (value) {
                                                    if (controller
                                                        .cocIssuingAuthority
                                                        .contains(e)) {
                                                      controller
                                                          .cocIssuingAuthority
                                                          .remove(e);
                                                    } else if (controller
                                                            .cocIssuingAuthority
                                                            .length <
                                                        2) {
                                                      controller
                                                          .cocIssuingAuthority
                                                          .add(e);
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(64),
                                      border: Border.all(
                                          color: Get.theme.primaryColor),
                                    )),
                              ),
                            ),
                            if (controller.step2FormMisses.contains(
                                Step2FormMiss.cocIssuingAuthority)) ...[
                              4.verticalSpace,
                              Text("Please select this field",
                                  style: Get.textTheme.bodySmall
                                      ?.copyWith(color: Colors.red))
                            ]
                          ],
                        ),
                        20.horizontalSpace,
                        Expanded(
                          child: TextFormField(
                              controller: controller.cocValidTill,
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
                                controller.cocValidTill.text =
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
                                          BorderRadius.circular(64)))),
                        ),
                      ],
                    ),
                  ],
                  16.verticalSpace
                ],
                if (controller.isHoldingValidCOC.value != true &&
                    ![
                      "Mess boy / GS / Steward",
                      "Second Cook / 2nd Cook",
                      "Chief Cook",
                      "Trainee Electrical Cadet",
                      "ETO / Electrician",
                    ].contains(controller.selectedRank.value?.name)) ...[
                  Text("Are you holding valid COP? *", style: _headingStyle),
                  8.verticalSpace,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Radio<bool>(
                          value: controller.isHoldingValidCOP.value ?? false,
                          groupValue: false,
                          onChanged: (_) {
                            controller.isHoldingValidCOP.value = false;
                          }),
                      14.horizontalSpace,
                      Text("No")
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
                      Text("Yes")
                    ],
                  ),
                  if (controller.isHoldingValidCOP.value == true) ...[
                    Text("Issuing Authority"),
                    16.verticalSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                value: null,
                                isExpanded: true,
                                items: ["Indian", "Panama", "Others"]
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        onTap: () {
                                          if (controller.copIssuingAuthority
                                              .contains(e)) {
                                            controller.copIssuingAuthority
                                                .remove(e);
                                          } else if (controller
                                                  .copIssuingAuthority.length <
                                              2) {
                                            controller.copIssuingAuthority
                                                .add(e);
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
                                                  value: controller
                                                      .copIssuingAuthority
                                                      .contains(e),
                                                  onChanged: (value) {
                                                    if (controller
                                                        .copIssuingAuthority
                                                        .contains(e)) {
                                                      controller
                                                          .copIssuingAuthority
                                                          .remove(e);
                                                    } else if (controller
                                                            .copIssuingAuthority
                                                            .length <
                                                        2) {
                                                      controller
                                                          .copIssuingAuthority
                                                          .add(e);
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(64),
                                      border: Border.all(
                                          color: Get.theme.primaryColor),
                                    )),
                              ),
                            ),
                            if (controller.step2FormMisses.contains(
                                Step2FormMiss.cocIssuingAuthority)) ...[
                              4.verticalSpace,
                              Text("Please select this field",
                                  style: Get.textTheme.bodySmall
                                      ?.copyWith(color: Colors.red))
                            ]
                          ],
                        ),
                        20.horizontalSpace,
                        Expanded(
                          child: TextFormField(
                              controller: controller.copValidTill,
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
                                controller.copValidTill.text =
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
                                          BorderRadius.circular(64)))),
                        ),
                      ],
                    ),
                  ],
                  16.verticalSpace,
                  //
                  Text("Are you holding Watch keeping? *",
                      style: _headingStyle),
                  8.verticalSpace,
                  Row(
                    children: [
                      Radio<bool>(
                          value:
                              controller.isHoldingWatchKeeping.value ?? false,
                          groupValue: false,
                          onChanged: (_) {
                            controller.isHoldingWatchKeeping.value = false;
                          }),
                      14.horizontalSpace,
                      Text("No")
                    ],
                  ),
                  Row(
                    children: [
                      Radio<bool>(
                          value:
                              controller.isHoldingWatchKeeping.value ?? false,
                          groupValue: true,
                          onChanged: (_) {
                            controller.isHoldingWatchKeeping.value = true;
                          }),
                      14.horizontalSpace,
                      Text("Yes")
                    ],
                  ),
                  if (controller.isHoldingWatchKeeping.value == true) ...[
                    Text("Issuing Authority"),
                    16.verticalSpace,
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                value: null,
                                isExpanded: true,
                                items: ["Indian", "Panama", "Others"]
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        onTap: () {
                                          if (controller
                                              .watchKeepingIssuingAuthority
                                              .contains(e)) {
                                            controller
                                                .watchKeepingIssuingAuthority
                                                .remove(e);
                                          } else if (controller
                                                  .watchKeepingIssuingAuthority
                                                  .length <
                                              2) {
                                            controller
                                                .watchKeepingIssuingAuthority
                                                .add(e);
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
                                                  value: controller
                                                      .watchKeepingIssuingAuthority
                                                      .contains(e),
                                                  onChanged: (value) {
                                                    if (controller
                                                        .watchKeepingIssuingAuthority
                                                        .contains(e)) {
                                                      controller
                                                          .watchKeepingIssuingAuthority
                                                          .remove(e);
                                                    } else if (controller
                                                            .watchKeepingIssuingAuthority
                                                            .length <
                                                        2) {
                                                      controller
                                                          .watchKeepingIssuingAuthority
                                                          .add(e);
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(64),
                                      border: Border.all(
                                          color: Get.theme.primaryColor),
                                    )),
                              ),
                            ),
                            if (controller.step2FormMisses.contains(
                                Step2FormMiss
                                    .watchKeepingIssuingAuthority)) ...[
                              4.verticalSpace,
                              Text("Please select this field",
                                  style: Get.textTheme.bodySmall
                                      ?.copyWith(color: Colors.red))
                            ]
                          ],
                        ),
                        20.horizontalSpace,
                        Expanded(
                          child: TextFormField(
                              controller: controller.watchKeepingValidTill,
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
                                controller.watchKeepingValidTill.text =
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
                                          BorderRadius.circular(64)))),
                        ),
                      ],
                    ),
                  ],
                  16.verticalSpace
                ],
                Text("Are you holding valid US Visa? *", style: _headingStyle),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Radio<bool>(
                            value:
                                controller.isHoldingValidUSVisa.value ?? false,
                            groupValue: false,
                            onChanged: (_) {
                              controller.isHoldingValidUSVisa.value = false;
                            }),
                        8.horizontalSpace,
                        Text("No"),
                        16.horizontalSpace,
                        Radio<bool>(
                            value:
                                controller.isHoldingValidUSVisa.value ?? false,
                            groupValue: true,
                            onChanged: (_) {
                              controller.isHoldingValidUSVisa.value = true;
                            }),
                        8.horizontalSpace,
                        Text("Yes"),
                      ],
                    ),
                    20.horizontalSpace,
                    if (controller.isHoldingValidUSVisa.value == true)
                      Expanded(
                        child: TextFormField(
                            controller: controller.usVisaValidTill,
                            validator: (value) {
                              if (value == null || value.isEmpty == true) {
                                return "Please enter this field";
                              }
                              return null;
                            },
                            onTap: () async {
                              DateTime? selectedDateTime = await showDatePicker(
                                  context: Get.context!,
                                  initialDate: DateTime.parse("1990-01-01"),
                                  firstDate: DateTime.parse("1990-01-01"),
                                  lastDate: DateTime.now());
                              controller.usVisaValidTill.text =
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
                                    borderRadius: BorderRadius.circular(64)))),
                      ),
                  ],
                ),
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () async {
                        controller.step.value = 3;
                        // if (await controller.postStep2()) {
                        //   controller.step.value = 3;
                        // }
                      },
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(64))),
                      child: const Text("SAVE & CONTINUE"),
                    ),
                  ],
                ),
                16.verticalSpace
              ],
            ),
          ),
        ));
  }

  TextStyle? get _headingStyle =>
      Get.textTheme.bodyMedium?.copyWith(color: Get.theme.primaryColor);
}
