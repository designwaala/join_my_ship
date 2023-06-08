import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/coc_details.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/cop_details.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/stcw_details.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/watch_keeping_details.dart';
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("INDOS NO.  *", style: headingStyle),
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
                Text("CDC Number *", style: headingStyle),
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
                Text("CDC / Seaman Book Details *", style: headingStyle),
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
                          controller: controller.cdcSeamanNumberValidTill,
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
                            controller.cdcSeamanNumberValidTill.text =
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
                Text("Passport Details *", style: headingStyle),
                16.verticalSpace,
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                          controller: controller.passportNumber,
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
                const STCWDetails(),
                16.verticalSpace,
                // if (![
                //   "Deck Cadet",
                //   "Trainee Electrical Cadet",
                //   "Engine Cadet",
                //   "Trainee Ordinary Seaman",
                //   "Trainee Wiper"
                // ].contains(controller.selectedRank.value?.name))
                if (controller.selectedRank.value?.coc == true)
                  const COCDetails(),
                if (controller.isHoldingValidCOC.value != true
                // &&
                //     ![
                //       "Mess boy / GS / Steward",
                //       "Second Cook / 2nd Cook",
                //       "Chief Cook",
                //       "Trainee Electrical Cadet",
                //       "ETO / Electrician",
                //     ].contains(controller.selectedRank.value?.name)
                ) ...[
                  if (controller.selectedRank.value?.cop == true) ...[
                    const COPDetails(),
                    16.verticalSpace,
                  ],
                  if (controller.selectedRank.value?.watchKeeping == true) ...[
                    const WatchKeepingDetails(),
                    16.verticalSpace
                  ]
                ],
                Text("Are you holding valid US Visa? *", style: headingStyle),
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
                    controller.userDetails?.id == null
                        ? controller.isUpdating.value
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
                                        borderRadius:
                                            BorderRadius.circular(64))),
                                child: const Text("SAVE & CONTINUE"),
                              )
                        : ElevatedButton(
                            onPressed: () async {
                              controller.step.value = 3;
                            },
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(64))),
                            child: const Text("NEXT"),
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
