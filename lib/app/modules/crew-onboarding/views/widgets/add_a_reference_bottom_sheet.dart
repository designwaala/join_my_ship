import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';

class AddAReference extends GetView<CrewOnboardingController> {
  final ScrollController scrollController;
  const AddAReference({Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return SingleChildScrollView(
        controller: scrollController,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            14.verticalSpace,
            Center(
              child: Container(
                width: 32,
                height: 4,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.circular(64)),
              ),
            ),
            16.verticalSpace,
            Text("Add a reference",
                style: Get.textTheme.bodyMedium
                    ?.copyWith(fontSize: 22, fontWeight: FontWeight.bold)),
            16.verticalSpace,
            Row(
              children: [
                Icon(Icons.business_sharp, color: Get.theme.primaryColor),
                8.horizontalSpace,
                Text("Company Name", style: headingStyle)
              ],
            ),
            16.verticalSpace,
            TextFormField(
                controller: controller.referenceCompanyName,
                decoration: InputDecoration(
                    hintText: "Company Name",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    isDense: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor),
                        borderRadius: BorderRadius.circular(64)))),
            16.verticalSpace,
            Row(
              children: [
                Icon(Icons.account_circle_outlined,
                    color: Get.theme.primaryColor),
                8.horizontalSpace,
                Text("Reference name", style: headingStyle)
              ],
            ),
            16.verticalSpace,
            TextFormField(
                controller: controller.referenceReferenceName,
                decoration: InputDecoration(
                    hintText: "Reference Name",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    isDense: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor),
                        borderRadius: BorderRadius.circular(64)))),
            16.verticalSpace,
            Row(
              children: [
                Icon(Icons.phone, color: Get.theme.primaryColor),
                8.horizontalSpace,
                Text("Contact Number", style: headingStyle)
              ],
            ),
            16.verticalSpace,
            TextFormField(
                controller: controller.referenceContactNumber,
                decoration: InputDecoration(
                    hintText: "Contact Number",
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    isDense: true,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Get.theme.primaryColor),
                        borderRadius: BorderRadius.circular(64)))),
            36.verticalSpace,
            Divider(thickness: 2),
            18.verticalSpace,
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Get.back();
                  },
                  style: OutlinedButton.styleFrom(
                      side: BorderSide(color: Get.theme.primaryColor),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(64))),
                  child: const Text("CANCEL"),
                ),
                20.horizontalSpace,
                controller.isAddingBottomSheet.value
                    ? CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (await controller
                              .addReferenceFromPreviousEmployer()) {
                            Get.back();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(64))),
                        child: const Text("SAVE"),
                      ),
              ],
            ),
            28.verticalSpace
          ],
        ),
      );
    });
  }
}
