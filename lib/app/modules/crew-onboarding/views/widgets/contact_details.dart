import 'package:collection/collection.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/app/modules/crew_sign_in_mobile/controllers/crew_sign_in_mobile_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';

class ContactDetails extends GetView<CrewOnboardingController> {
  ContactDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Contact details", style: headingStyle),
          16.verticalSpace,
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: const Text("Mobile Number"),
              ),
              32.horizontalSpace,
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CustomTextFormField(
                    controller: controller.phoneNumber,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintStyle: Get.textTheme.bodySmall,
                        isDense: true,
                        prefixIcon: Container(
                          width: 48,
                          margin: const EdgeInsets.only(right: 8, left: 4),
                          decoration: const BoxDecoration(
                              // color: Colors.blue[50],
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(64),
                                  bottomLeft: Radius.circular(64))),
                          child: InkWell(
                            onTap: () {
                              showCountryPicker(
                                context: context,
                                showPhoneCode: true,
                                onSelect: (Country country) {
                                  print(
                                      'Select country: ${country.displayName}');
                                  controller.selectedCountryCode.value =
                                      "+${country.phoneCode}";
                                },
                              );
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(controller.selectedCountryCode.value,
                                        style: Get.theme.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                    const Icon(Icons.keyboard_arrow_down)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        suffixIcon: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child:
                              FirebaseAuth.instance.currentUser?.phoneNumber ==
                                      null
                                  ? const Icon(Icons.info, color: Colors.red)
                                  : Icon(Icons.check_circle,
                                      color: Get.theme.primaryColor),
                        ),
                        suffixIconConstraints:
                            const BoxConstraints(maxHeight: 32, maxWidth: 32),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Get.theme.primaryColor),
                            borderRadius: BorderRadius.circular(64)),
                        labelStyle: Theme.of(Get.context!).textTheme.bodyLarge),
                  ),
                  4.verticalSpace,
                  InkWell(
                    onTap: () async {
                      Map<String, dynamic> result = await Get.toNamed(
                          Routes.CREW_SIGN_IN_MOBILE,
                          arguments: CrewSignInMobileArguments(
                              phoneNumber: controller.phoneNumber.text,
                              countryCode: controller.selectedCountryCode.value,
                              redirection: (phoneNumber, dialCode) {
                                Get.back(result: {
                                  "phone_number": phoneNumber,
                                  "dial_code": dialCode
                                });
                              }));
                      controller.phoneNumber.text =
                          result['phone_number'] ?? "";
                      controller.selectedCountryCode.value =
                          result['dial_code'] ?? "";
                      await FirebaseAuth.instance.currentUser?.reload();
                      if (FirebaseAuth.instance.currentUser?.phoneNumber !=
                          controller.crewUser?.number?.replaceAll("-", "")) {
                        controller.isUpdating.value = true;
                        await getIt<CrewUserProvider>().updateCrewUser(
                            crewId: controller.crewUser!.id!,
                            crewUser: CrewUser(
                                number:
                                    "${controller.selectedCountryCode}-${controller.phoneNumber.text}"));
                        controller.isUpdating.value = false;
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Verify",
                            style: Get.textTheme.bodySmall
                                ?.copyWith(color: Get.theme.primaryColor)),
                        Icon(Icons.keyboard_arrow_right,
                            color: Get.theme.primaryColor)
                      ],
                    ),
                  )
                ],
              )),
            ],
          ),
          16.verticalSpace,
          const Text("Email Address"),
          8.verticalSpace,
          CustomTextFormField(
            initialValue: FirebaseAuth.instance.currentUser?.email,
            readOnly: true,
          )
        ],
      );
    });
  }
}
