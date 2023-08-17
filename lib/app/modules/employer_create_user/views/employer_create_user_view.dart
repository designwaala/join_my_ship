import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:country_picker/country_picker.dart' as CountryPicker;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/modules/crew_sign_in_mobile/controllers/crew_sign_in_mobile_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/widgets/dropdown_decoration.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/custom_text_form_field.dart';
import '../controllers/employer_create_user_controller.dart';

class EmployerCreateUserView extends GetView<EmployerCreateUserController> {
  const EmployerCreateUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: const Text('EMPLOYER'),
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 27),
                    child: Form(
                      key: controller.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Text('Create User Profile',
                              style: Get.theme.textTheme.headlineSmall
                                  ?.copyWith(fontSize: 20)),
                          9.verticalSpace,
                          Text('Please complete your profile',
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey)),
                          25.verticalSpace,
                          InkWell(
                              onTap: controller.pickSource,
                              child: controller.pickedImage.value == null &&
                                      controller.uploadedImagePath.value == null
                                  ? Center(
                                      child: Stack(
                                        children: [
                                          Icon(Icons.account_circle,
                                              size: 85,
                                              color: Colors.grey.shade400),
                                          Positioned(
                                              bottom: 4,
                                              right: 4,
                                              child: Container(
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.white,
                                                ),
                                                child: Icon(Icons.add_circle,
                                                    color:
                                                        Get.theme.primaryColor,
                                                    size: 32),
                                              ))
                                        ],
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        controller.pickedImage.value == null
                                            ? CachedNetworkImage(
                                                height: 100,
                                                width: 100,
                                                imageUrl: controller
                                                        .uploadedImagePath
                                                        .value ??
                                                    "",
                                                imageBuilder: (context,
                                                        imageProvider) =>
                                                    Container(
                                                      decoration: BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          image: DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image: NetworkImage(
                                                                  controller
                                                                          .uploadedImagePath
                                                                          .value ??
                                                                      ""))),
                                                      height: 100,
                                                      width: 100,
                                                    ))
                                            : Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: Image.file(File(
                                                                controller
                                                                    .pickedImage
                                                                    .value!
                                                                    .path))
                                                            .image,
                                                        fit: BoxFit.cover)),
                                              )
                                      ],
                                    )),
                          12.verticalSpace,
                          Center(
                            child: Text('Upload Profile Pic',
                                textAlign: TextAlign.center,
                                style: Get.textTheme.bodyMedium
                                    ?.copyWith(color: Get.theme.primaryColor)),
                          ),
                          if (controller.step1FormMisses.contains(
                              Step1FormMiss.didNotSelectProfilePic)) ...[
                            Center(
                              child: Text("Please select a Profile Pic",
                                  style: Get.textTheme.bodySmall
                                      ?.copyWith(color: Colors.red)),
                            )
                          ],
                          30.verticalSpace,
                          CustomRow(
                            textEditingController:
                                controller.firstNameController,
                            FieldName: 'First Name',
                            hintText: 'First Name',
                            readOnly: false,
                          ),
                          15.verticalSpace,
                          CustomRow(
                            textEditingController:
                                controller.lastNameController,
                            FieldName: 'Last Name',
                            hintText: 'Last Name',
                            readOnly: false,
                          ),
                          15.verticalSpace,
                          CustomRow(
                            textEditingController:
                                controller.designationController,
                            FieldName: 'Designation',
                            hintText: 'Designation',
                            readOnly: false,
                          ),
                          20.verticalSpace,
                          CustomRow(
                            FieldName: "Company Name",
                            hintText: "Company Name",
                            textEditingController:
                                controller.companyNameController,
                            enabled:
                                controller.companyNameController.text.isEmpty,
                            readOnly: controller
                                .companyNameController.text.isNotEmpty,
                          ),
                          15.verticalSpace,
                          CustomRow(
                              FieldName: "Website",
                              hintText: "Website",
                              textEditingController:
                                  controller.websiteController,
                              enabled:
                                  controller.websiteController.text.isEmpty,
                              readOnly:
                                  controller.websiteController.text.isNotEmpty),
                          24.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Gender",
                                  style: Get.textTheme.titleSmall?.copyWith(
                                      color: Get.theme.primaryColor)),
                              SizedBox(
                                width: 170.w,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: Radio<int?>(
                                          value: controller.gender.value,
                                          groupValue: 1,
                                          onChanged: (_) {
                                            controller.gender.value = 1;
                                          }),
                                    ),
                                    8.horizontalSpace,
                                    const Text("Male"),
                                    16.horizontalSpace,
                                    SizedBox(
                                      height: 16,
                                      width: 16,
                                      child: Radio<int?>(
                                          value: controller.gender.value,
                                          groupValue: 2,
                                          onChanged: (_) {
                                            controller.gender.value = 2;
                                          }),
                                    ),
                                    8.horizontalSpace,
                                    const Text("Female"),
                                  ],
                                ),
                              )
                            ],
                          ),
                          if (controller.step1FormMisses
                              .contains(Step1FormMiss.didNotSelectGender))
                            Text("Please select gender",
                                style: Get.textTheme.bodySmall?.copyWith(
                                    color: Get.theme.colorScheme.error)),
                          15.verticalSpace,
                          if (controller.editMode) ...[
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 16),
                                  child: Text("Mobile Number",
                                      textAlign: TextAlign.center,
                                      style: Get.textTheme.titleSmall?.copyWith(
                                          color: Get.theme.primaryColor)),
                                ),
                                SizedBox(
                                  width: 170.w,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      CustomTextFormField(
                                        controller:
                                            controller.phoneNumberController,
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                            fillColor: Colors.white,
                                            filled: true,
                                            hintStyle: Get.textTheme.bodySmall,
                                            isDense: true,
                                            prefixIconConstraints:
                                                const BoxConstraints(
                                                    maxHeight: 48),
                                            /* prefixIcon: Container(
                                              width: 48,
                                              margin: const EdgeInsets.only(
                                                  right: 0, left: 4),
                                              decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  64),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  64))),
                                              child: InkWell(
                                                onTap: () {
                                                  CountryPicker
                                                      .showCountryPicker(
                                                    context: context,
                                                    showPhoneCode: true,
                                                    onSelect:
                                                        (CountryPicker.Country
                                                            country) {
                                                      print(
                                                          'Select country: ${country.displayName}');
                                                      controller
                                                              .selectedCountryCode
                                                              .value =
                                                          "+${country.phoneCode}";
                                                    },
                                                  );
                                                },
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                        controller
                                                            .selectedCountryCode
                                                            .value,
                                                        style: Get
                                                            .theme
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    const Icon(Icons
                                                        .keyboard_arrow_down)
                                                  ],
                                                ),
                                              ),
                                            ), */
                                            suffixIcon: Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8),
                                              child: FirebaseAuth
                                                          .instance
                                                          .currentUser
                                                          ?.phoneNumber ==
                                                      null
                                                  ? const Icon(Icons.info,
                                                      color: Colors.red)
                                                  : Icon(Icons.check_circle,
                                                      color: Get
                                                          .theme.primaryColor),
                                            ),
                                            suffixIconConstraints:
                                                const BoxConstraints(
                                                    maxHeight: 32,
                                                    maxWidth: 32),
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 16,
                                                    vertical: 8),
                                            border: OutlineInputBorder(
                                                borderSide: BorderSide(
                                                    color:
                                                        Get.theme.primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(64)),
                                            labelStyle: Theme.of(Get.context!)
                                                .textTheme
                                                .bodyLarge),
                                      ),
                                      4.verticalSpace,
                                      InkWell(
                                        onTap: () async {
                                          Map<String, dynamic> result =
                                              await Get.toNamed(
                                                  Routes.CREW_SIGN_IN_MOBILE,
                                                  arguments:
                                                      CrewSignInMobileArguments(
                                                          /* phoneNumber: controller
                                                              .phoneNumberController
                                                              .text,
                                                          countryCode: controller
                                                              .selectedCountryCode
                                                              .value, */
                                                          redirection:
                                                              (phoneNumber,
                                                                  dialCode) {
                                            Get.back(result: {
                                              "phone_number": phoneNumber,
                                              "dial_code": dialCode
                                            });
                                          }));

                                          controller
                                                  .phoneNumberController.text =
                                              result['phone_number'] ?? "";
                                          controller.selectedCountryCode.value =
                                              result['dial_code'] ?? "";
                                          await FirebaseAuth
                                              .instance.currentUser
                                              ?.reload();
                                          if (FirebaseAuth.instance.currentUser
                                                  ?.phoneNumber !=
                                              controller.crewUser?.number
                                                  ?.replaceAll("-", "")) {
                                            controller.isUpdating.value = true;
                                            await getIt<CrewUserProvider>()
                                                .updateCrewUser(
                                                    crewId: controller
                                                        .crewUser!.id!,
                                                    crewUser: CrewUser(
                                                        number:
                                                            "${controller.selectedCountryCode}-${controller.phoneNumberController.text}"));
                                            controller.isUpdating.value = false;
                                          }
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text("Add",
                                                style: Get.textTheme.bodySmall
                                                    ?.copyWith(
                                                        color: Get.theme
                                                            .primaryColor)),
                                            Icon(Icons.keyboard_arrow_right,
                                                color: Get.theme.primaryColor)
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            /* CustomRow(
                                FieldName: "Mobile",
                                hintText: "+911234567890",
                                textEditingController:
                                    controller.phoneNumberController,
                                readOnly: false), */
                            15.verticalSpace,
                            Text('Email Address',
                                style: Get.textTheme.titleSmall
                                    ?.copyWith(color: Get.theme.primaryColor)),
                            15.verticalSpace,
                            CustomTextFormField(
                              controller: controller.emailController,
                              enabled: false,
                              readOnly: true,
                              hintText: 'Email',
                            ),
                            15.verticalSpace,
                          ],
                          Text('Company Address',
                              style: Get.textTheme.titleSmall
                                  ?.copyWith(color: Get.theme.primaryColor)),
                          20.verticalSpace,
                          Row(
                            children: [
                              Expanded(
                                child: Builder(builder: (context) {
                                  TextEditingController countryController =
                                      TextEditingController();
                                  countryController.text =
                                      controller.country.value?.countryName ??
                                          "";
                                  return TypeAheadFormField<Country>(
                                    textFieldConfiguration:
                                        TextFieldConfiguration(
                                      controller: countryController,
                                      decoration: InputDecoration(
                                        fillColor: Colors.white,
                                        filled: true,
                                        hintText: "Country",
                                        hintStyle: Get.textTheme.bodySmall,
                                        isDense: true,
                                        suffixIconConstraints:
                                            const BoxConstraints(
                                                maxHeight: 32, maxWidth: 32),
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 8),
                                        border: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Get.theme.primaryColor),
                                            borderRadius:
                                                BorderRadius.circular(64)),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please choose your country";
                                      }
                                      return null;
                                    },
                                    itemBuilder: (BuildContext context,
                                        Country itemData) {
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(itemData.countryName ?? ""),
                                      );
                                    },
                                    onSuggestionSelected: (Country suggestion) {
                                      controller.country.value = suggestion;
                                      controller
                                        ..states.clear()
                                        ..getStates();
                                      countryController.text =
                                          suggestion.countryName ?? "";
                                    },
                                    suggestionsCallback: (String pattern) {
                                      return Future.value(controller.countries
                                          .where((rank) =>
                                              rank.countryName
                                                  ?.toLowerCase()
                                                  .startsWith(
                                                      pattern.toLowerCase()) ==
                                              true));
                                    },
                                  );
                                }),
                              ),
                              20.horizontalSpace,
                              Expanded(
                                child: controller.isLoadingStates.value
                                    ? Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: const [
                                          SizedBox(
                                              height: 16,
                                              width: 16,
                                              child:
                                                  CircularProgressIndicator())
                                        ],
                                      )
                                    : Column(
                                        children: [
                                          DropdownButtonHideUnderline(
                                            child: DropdownButton2<int?>(
                                              value: controller.state.value?.id,
                                              isExpanded: true,
                                              items: controller.states
                                                  .map((e) => DropdownMenuItem(
                                                      value: e.id,
                                                      child: Text(
                                                        e.stateName ?? "",
                                                        style: Get.textTheme
                                                            .titleMedium,
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      )))
                                                  .toList(),
                                              style: Get.textTheme.bodySmall,
                                              onChanged: (value) {
                                                controller.state.value =
                                                    controller
                                                        .states
                                                        .firstWhereOrNull(
                                                            (state) =>
                                                                state.id ==
                                                                value);
                                              },
                                              hint: const Text("State"),
                                              buttonStyleData: ButtonStyleData(
                                                  height: 40,
                                                  width: 160,
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 8),
                                                  decoration:
                                                      DropdownDecoration()),
                                            ),
                                          ),
                                          if (controller.step1FormMisses
                                              .contains(Step1FormMiss
                                                  .didNotSelectState)) ...[
                                            4.verticalSpace,
                                            Text("Please select your State",
                                                style: Get.textTheme.bodySmall
                                                    ?.copyWith(
                                                        color: Colors.red)),
                                          ]
                                        ],
                                      ),
                              ),
                            ],
                          ),
                          20.verticalSpace,
                          CustomTextFormField(
                            controller: controller.cityController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your City";
                              }
                            },
                            hintText: 'City',
                          ),
                          15.verticalSpace,
                          CustomTextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Address Line 1";
                              }
                            },
                            controller: controller.addressLine1Controller,
                            hintText: 'Address Line 1',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^[a-zA-Z0-9,.-/- ]+"))
                            ],
                          ),
                          15.verticalSpace,
                          CustomTextFormField(
                            controller: controller.addressLine2Controller,
                            hintText: 'Address Line 2',
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp(r"^[a-zA-Z0-9,.-/- ]+"))
                            ],
                          ),
                          15.verticalSpace,
                          CustomTextFormField(
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "Please enter your Zip Code";
                              }
                            },
                            keyboardType: TextInputType.number,
                            controller: controller.zipCodeController,
                            hintText: 'Zip Code',
                          ),
                          20.verticalSpace,
                          controller.isUpdating.value
                              ? Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [CircularProgressIndicator()],
                                )
                              : Center(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h, horizontal: 45.w),
                                        backgroundColor:
                                            const Color(0xFF407BFF),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(36.21),
                                        ),
                                      ),
                                      onPressed: () {
                                        controller.postEmployerUser();
                                        // Get.toNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
                                      },
                                      child: Text(
                                        'SAVE & CONTINUE',
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 15.54,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      )),
                                ),
                          20.verticalSpace,
                          MediaQuery.of(context).viewInsets.bottom.verticalSpace
                        ],
                      ),
                    ),
                  ),
                );
        }));
  }
}

class CustomRow extends StatelessWidget {
  const CustomRow(
      {required this.FieldName,
      required this.hintText,
      required this.textEditingController,
      required this.readOnly,
      this.enabled});
  final TextEditingController textEditingController;
  final String FieldName;
  final String hintText;
  final bool readOnly;
  final bool? enabled;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(FieldName,
            textAlign: TextAlign.center,
            style: Get.textTheme.titleSmall
                ?.copyWith(color: Get.theme.primaryColor)),
        SizedBox(
            // height: 40.h,
            width: 170.w,
            child: CustomTextFormField(
                enabled: enabled,
                readOnly: readOnly,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter your $hintText";
                  }
                },
                controller: textEditingController,
                hintText: hintText))
      ],
    );
  }
}
