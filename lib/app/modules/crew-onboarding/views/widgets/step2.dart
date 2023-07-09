import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/coc_details.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/cop_details.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/stcw_details.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/watch_keeping_details.dart';
import 'package:join_mp_ship/widgets/astrix_text.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
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
                    style: Get.theme.textTheme.headlineSmall
                        ?.copyWith(fontSize: 20)),
                8.verticalSpace,
                Text("Please complete your profile",
                    style:
                        Get.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
                24.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text("INDOS NO.", style: headingStyle),
                    ),
                    48.horizontalSpace,
                    Expanded(
                      child: CustomTextFormField(
                          controller: controller.indosNumber,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z0-9]+'))
                          ],
                          /* validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          }, */
                          hintText: "INDOS Number"),
                    ),
                  ],
                ),
                /* 8.verticalSpace,
                 AsterixText("CDC Number"),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                          controller: controller.cdcNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          hintText: "CDC Number"),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: CustomTextFormField(
                        controller: controller.cdcNumberValidTill,
                        validator: (value) {
                          if (value == null || value.isEmpty == true) {
                            return "Please enter this field";
                          }
                          return null;
                        },
                        readOnly: true,
                        onTap: () async {
                          DateTime? selectedDateTime = await showDatePicker(
                              context: Get.context!,
                              initialDate: DateTime.parse("1990-01-01"),
                              firstDate: DateTime.parse("1950-01-01"),
                              firstDate: DateTime.parse("2050-01-01"));
                          controller.cdcNumberValidTill.text =
                              selectedDateTime?.getServerDate() ?? "";
                        },
                        hintText: "Valid Till",
                        icon: const Icon(Icons.calendar_month),
                      ),
                    ),
                  ],
                ), */
                16.verticalSpace,
                const AsterixText("CDC / Seaman Book Details"),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                          controller: controller.cdcSeamanNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z0-9]+'))
                          ],
                          hintText: "CDC Number"),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: CustomTextFormField(
                          controller: controller.cdcSeamanNumberValidTill,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          isDate: true,
                          onTap: () async {
                            DateTime? selectedDateTime = await showDatePicker(
                                context: Get.context!,
                                initialDate: DateTime.parse("1990-01-01"),
                                firstDate: DateTime.parse("1950-01-01"),
                                lastDate: DateTime.parse("2050-01-01"));
                            controller.cdcSeamanNumberValidTill.text =
                                selectedDateTime?.getServerDate() ?? "";
                          },
                          hintText: "Valid Till",
                          icon: const Icon(
                            Icons.calendar_month,
                          )),
                    ),
                  ],
                ),
                16.verticalSpace,
                const AsterixText("Passport Details"),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                          controller: controller.passportNumber,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                                RegExp(r'^[a-zA-Z0-9,-/]+'))
                          ],
                          hintText: "Passport Number"),
                    ),
                    20.horizontalSpace,
                    Expanded(
                      child: CustomTextFormField(
                          controller: controller.passportValidTill,
                          validator: (value) {
                            if (value == null || value.isEmpty == true) {
                              return "Please enter this field";
                            }
                            return null;
                          },
                          isDate: true,
                          onTap: () async {
                            DateTime? selectedDateTime = await showDatePicker(
                                context: Get.context!,
                                initialDate: DateTime.parse("1990-01-01"),
                                firstDate: DateTime.parse("1950-01-01"),
                                lastDate: DateTime.parse("2050-01-01"));

                            controller.passportValidTill.text =
                                selectedDateTime?.getServerDate() ?? "";
                          },
                          hintText: "Valid Till",
                          icon: const Icon(
                            Icons.calendar_month,
                          )),
                    ),
                  ],
                ),
                16.verticalSpace,
                const STCWDetails(),
                16.verticalSpace,
                if (controller.selectedRank.value?.coc == true)
                  const COCDetails(),
                if (controller.isHoldingValidCOC.value != true) ...[
                  if (controller.selectedRank.value?.cop == true) ...[
                    const COPDetails(),
                    16.verticalSpace,
                  ],
                  if (controller.selectedRank.value?.watchKeeping == true) ...[
                    const WatchKeepingDetails(),
                    16.verticalSpace
                  ]
                ],
                const AsterixText("Are you holding valid US Visa?"),
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
                        const Text("No"),
                        16.horizontalSpace,
                        Radio<bool>(
                            value:
                                controller.isHoldingValidUSVisa.value ?? false,
                            groupValue: true,
                            onChanged: (_) {
                              controller.isHoldingValidUSVisa.value = true;
                            }),
                        8.horizontalSpace,
                        const Text("Yes"),
                      ],
                    ),
                    20.horizontalSpace,
                    if (controller.isHoldingValidUSVisa.value == true)
                      Expanded(
                        child: CustomTextFormField(
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
                                  firstDate: DateTime.parse("1950-01-01"),
                                  lastDate: DateTime.parse("2050-01-01"));
                              controller.usVisaValidTill.text =
                                  selectedDateTime?.getServerDate() ?? "";
                            },
                            isDate: true,
                            hintText: "Valid Till",
                            icon: const Icon(
                              Icons.calendar_month,
                            )),
                      ),
                  ],
                ),
                16.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.isUpdating.value
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              // controller.step.value = 3;
                              if (await controller.postStep2()) {
                                controller.step.value = 3;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64))),
                            child: controller.userDetails?.id == null
                                ? const Text("SAVE & CONTINUE")
                                : const Text("UPDATE & CONTINUE"),
                          ),
                  ],
                ),
                16.verticalSpace
              ],
            ),
          ),
        ));
  }
}
