import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:flutter/material.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/add_a_record_bottom_sheet.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/views/widgets/add_a_reference_bottom_sheet.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';

class CrewOnboardingStep3 extends GetView<CrewOnboardingController> {
  const CrewOnboardingStep3({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
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
                Icon(Icons.check_circle, color: Get.theme.primaryColor),
              ],
            ),
            22.verticalSpace,
            Text("Create Profile",
                style: Get.textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold)),
            8.verticalSpace,
            Text("Please complete your profile",
                style: Get.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
            16.verticalSpace,
            Text("Sea Service Record *", style: headingStyle),
            16.verticalSpace,
            Text("Please enter last two vessel records"),
            8.verticalSpace,
            ...controller.serviceRecords.map((serviceRecord) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(serviceRecord.companyName ?? ""),
                    controller.serviceRecordDeletingId.value == serviceRecord.id
                        ? CircularProgressIndicator()
                        : TextButton(
                            onPressed: () {
                              if (serviceRecord.id == null) {
                                return;
                              }
                              controller.deleteServiceRecord(serviceRecord.id!);
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                4.horizontalSpace,
                                Text("DELETE",
                                    style: Get.textTheme.bodyMedium
                                        ?.copyWith(color: Colors.red))
                              ],
                            ))
                  ],
                )),
            if (controller.step3FormMisses
                .contains(Step3FormMiss.lessThan2SeaServiceRecords)) ...[
              Text("Please provide at least 2 Sea Service Records",
                  style: Get.textTheme.bodyMedium?.copyWith(color: Colors.red)),
              4.verticalSpace
            ],
            OutlinedButton(
                onPressed: () {
                  controller.prepareRecordBottomSheet();
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16))),
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.9,
                          minChildSize: 0.25,
                          maxChildSize: 0.9,
                          expand: false,
                          builder: (context, controller) {
                            return AddARecord(scrollController: controller);
                          }));
                },
                child: Text("Add a record")),
            16.verticalSpace,
            Text("Reference from Your Previous Employer", style: headingStyle),
            16.verticalSpace,
            Text("Please enter your reference details"),
            8.verticalSpace,
            ...controller.previousEmployerReferences
                .map((previousEmployerRef) => Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(previousEmployerRef.companyName ?? ""),
                        controller.previousEmployerReferenceDeletingId.value ==
                                previousEmployerRef.id
                            ? CircularProgressIndicator()
                            : TextButton(
                                onPressed: () {
                                  if (previousEmployerRef.id == null) {
                                    return;
                                  }
                                  controller
                                      .deleteReferenceFromPreviousEmployer(
                                          previousEmployerRef.id!);
                                },
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    4.horizontalSpace,
                                    Text("DELETE",
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.red))
                                  ],
                                ))
                      ],
                    )),
            if (controller.step3FormMisses.contains(
                Step3FormMiss.referenceFromPreviousEmployerNotProvided)) ...[
              Text("Please provide at least 1 Reference from past employer",
                  style: Get.textTheme.bodyMedium?.copyWith(color: Colors.red)),
              4.verticalSpace
            ],
            OutlinedButton(
                onPressed: () {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16))),
                      context: context,
                      isScrollControlled: true,
                      builder: (context) => DraggableScrollableSheet(
                          initialChildSize: 0.6,
                          minChildSize: 0.25,
                          maxChildSize: 0.9,
                          expand: false,
                          builder: (context, controller) {
                            return AddAReference(scrollController: controller);
                          }));
                },
                child: Text("Add a reference")),
            24.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                      value: controller.declaration1.value,
                      onChanged: (_) {
                        controller.declaration1.value =
                            !(controller.declaration1.value);
                      }),
                ),
                8.horizontalSpace,
                Flexible(
                  child: Text(
                    "I hereby declare that all the details provided are true to the best of my knowledge.",
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            16.verticalSpace,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 24,
                  height: 24,
                  child: Checkbox(
                      value: controller.declaration2.value,
                      onChanged: (_) {
                        controller.declaration2.value =
                            !(controller.declaration2.value);
                      }),
                ),
                8.horizontalSpace,
                Flexible(
                  child: Text(
                    "I authorize Join My Ship to save and share my profile to employers when required.",
                    textAlign: TextAlign.justify,
                  ),
                )
              ],
            ),
            16.verticalSpace,
            if (controller.step3FormMisses
                .contains(Step3FormMiss.didNotAgreeToTermsAndCondition)) ...[
              Text("Please agree to the aforementioned terms.",
                  style: Get.textTheme.bodyMedium?.copyWith(color: Colors.red)),
              4.verticalSpace
            ],
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: controller.step3SubmitOnPress,
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(64))),
                  child: const Text("SUBMIT"),
                ),
              ],
            ),
            16.verticalSpace
          ],
        ),
      );
    });
  }
}
