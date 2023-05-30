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
            Text("Sea Service Record *", style: _headingStyle),
            16.verticalSpace,
            Text("Please enter last two vessel records"),
            8.verticalSpace,
            OutlinedButton(
                onPressed: () {
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
            Text("Reference from Your Previous Employer", style: _headingStyle),
            16.verticalSpace,
            Text("Please enter your reference details"),
            8.verticalSpace,
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
            16.verticalSpace,
            Text("Upload Resume *", style: _headingStyle),
            16.verticalSpace,
            Center(
              child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(
                          color: Get.theme.primaryColor,
                          style: BorderStyle.solid),
                      foregroundColor: Get.theme.primaryColor,
                      shape: RoundedRectangleBorder(
                          side: BorderSide(
                              color: Get.theme.primaryColor,
                              style: BorderStyle.solid),
                          borderRadius: BorderRadius.circular(64))),
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles();

                    if (result?.files.single.path != null) {
                      File file = File(result!.files.single.path!);
                    } else {
                      // User canceled the picker
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.upload),
                      4.horizontalSpace,
                      Text("UPLOAD",
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Get.theme.primaryColor))
                    ],
                  )),
            ),
            8.verticalSpace,
            Center(
              child: Text(
                  "Supported file formats Doc, Docx, pdf | Maximum file size 2 MB",
                  style: Get.textTheme.bodyMedium
                      ?.copyWith(fontSize: 8.sp, color: Colors.grey)),
            ),
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
                      "I hereby declare that all the details provided are true to the best of my knowledge."),
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
                      "I authorize Join My Ship to save and share my profile to employers when required."),
                )
              ],
            ),
            16.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.toNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
                  },
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

  TextStyle? get _headingStyle =>
      Get.textTheme.bodyMedium?.copyWith(color: Get.theme.primaryColor);
}
