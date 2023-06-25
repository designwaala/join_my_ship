import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';

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
            CustomTextFormField(
                controller: controller.referenceCompanyName,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]+'))
                ],
                hintText: "Company Name"),
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
            CustomTextFormField(
                controller: controller.referenceReferenceName,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z ]+'))
                ],
                hintText: "Reference Name"),
            16.verticalSpace,
            Row(
              children: [
                Icon(Icons.phone, color: Get.theme.primaryColor),
                8.horizontalSpace,
                Text("Contact Number", style: headingStyle)
              ],
            ),
            16.verticalSpace,
            Row(
              children: [
                SizedBox(
                  width: 100,
                  child: CustomTextFormField(
                      controller: controller.referenceDialCode,
                      onTap: () {
                        showCountryPicker(
                            context: context,
                            exclude: <String>[
                              'KN',
                              'MF'
                            ], //It takes a list of country code(iso2).
                            onSelect: (Country country) {
                              controller.referenceDialCode.text =
                                  "+${country.phoneCode}";
                            });
                      },
                      keyboardType: TextInputType.phone,
                      hintText: "Dial Code"),
                ),
                16.horizontalSpace,
                Expanded(
                  child: CustomTextFormField(
                      controller: controller.referenceContactNumber,
                      keyboardType: TextInputType.phone,
                      hintText: "Contact Number"),
                ),
              ],
            ),
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
