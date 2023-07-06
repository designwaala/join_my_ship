import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/widgets/dropdown_decoration.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../widgets/custom_text_form_field.dart';
import '../controllers/employer_create_user_controller.dart';

class EmployerCreateUserView extends GetView<EmployerCreateUserController> {
  const EmployerCreateUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          title: Text(
            'EMPLOYER',
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20.h,
                ),
                Text(
                  'Create User Profile',
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 22,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                9.verticalSpace,
                Text(
                  'Please complete your profile',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF585858),
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                25.verticalSpace,
                InkWell(
                  onTap: controller.pickSource,
                  child: controller.pickedImage.value != null ||
                          controller.uploadedImagePath.value != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            controller.uploadedImagePath.value != null
                                ? CachedNetworkImage(
                                    height: 100,
                                    width: 100,
                                    imageUrl:
                                        controller.uploadedImagePath.value ??
                                            "",
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  fit: BoxFit.cover,
                                                  image: NetworkImage(controller
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
                                            image: Image.file(File(controller
                                                    .pickedImage.value!.path))
                                                .image,
                                            fit: BoxFit.cover)),
                                  )
                          ],
                        )
                      : Center(
                          child: Stack(
                            children: [
                              Icon(Icons.account_circle,
                                  size: 85, color: Colors.grey.shade400),
                              Positioned(
                                  bottom: 4,
                                  right: 4,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: Icon(Icons.add_circle,
                                        color: Get.theme.primaryColor,
                                        size: 32),
                                  ))
                            ],
                          ),
                        ),
                ),
                12.verticalSpace,
                Center(
                  child: Text(
                    'Upload Profile Pic',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF407BFF),
                      fontSize: 15,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                30.verticalSpace,
                CustomRow(
                  textEditingController: controller.firstNameController,
                  FieldName: 'First Name',
                  hintText: 'First Name',
                ),
                15.verticalSpace,
                CustomRow(
                  textEditingController: controller.lastNameController,
                  FieldName: 'Last Name',
                  hintText: 'Last Name',
                ),
                15.verticalSpace,
                CustomRow(
                  textEditingController: controller.designationController,
                  FieldName: 'Designation',
                  hintText: 'Designation',
                ),
                20.verticalSpace,
                Text(
                  'Company Address',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF407BFF),
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                20.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: Builder(builder: (context) {
                        TextEditingController countryController =
                            TextEditingController();
                        countryController.text =
                            controller.country.value?.countryName ?? "";
                        return TypeAheadFormField<Country>(
                          textFieldConfiguration: TextFieldConfiguration(
                            controller: countryController,
                            decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "Country",
                              hintStyle: Get.textTheme.bodySmall,
                              isDense: true,
                              suffixIconConstraints: const BoxConstraints(
                                  maxHeight: 32, maxWidth: 32),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Get.theme.primaryColor),
                                  borderRadius: BorderRadius.circular(64)),
                            ),
                          ),
                          itemBuilder:
                              (BuildContext context, Country itemData) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(itemData.countryName ?? ""),
                            );
                          },
                          onSuggestionSelected: (Country suggestion) {
                            // controller.country.value = suggestion;
                            // controller
                            //   ..states.clear()
                            //   ..getStates();
                            // countryController.text =
                            //     suggestion.countryName ?? "";
                          },
                          suggestionsCallback: (String pattern) {
                            return Future.value(controller.countries.where(
                                (rank) =>
                                    rank.countryName
                                        ?.toLowerCase()
                                        .startsWith(pattern.toLowerCase()) ==
                                    true));
                          },
                        );
                      }),
                    ),
                    20.horizontalSpace,
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<int?>(
                        value: controller.state.value?.id,
                        isExpanded: true,
                        items: controller.states
                            .map((e) => DropdownMenuItem(
                                value: e.id,
                                child: Text(
                                  e.stateName ?? "",
                                  style: Get.textTheme.titleMedium,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )))
                            .toList(),
                        style: Get.textTheme.bodySmall,
                        onChanged: (value) {
                          controller.state.value = controller.states
                              .firstWhereOrNull((state) => state.id == value);
                        },
                        hint: const Text("State"),
                        buttonStyleData: ButtonStyleData(
                            height: 40,
                            width: 160,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: DropdownDecoration()),
                      ),
                    ),
                  ],
                ),
                20.verticalSpace,
                CustomTextFormField(
                  controller: controller.cityController,
                  hintText: 'City',
                ),
                15.verticalSpace,
                CustomTextFormField(
                  controller: controller.addressLine1Controller,
                  hintText: 'Address Line 1',
                ),
                15.verticalSpace,
                CustomTextFormField(
                  controller: controller.addressLine2Controller,
                  hintText: 'Address Line 2',
                ),
                15.verticalSpace,
                CustomTextFormField(
                  controller: controller.zipCodeController,
                  hintText: 'Zip Code',
                ),
                20.verticalSpace,
                Center(
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                            vertical: 10.h, horizontal: 45.w),
                        backgroundColor: const Color(0xFF407BFF),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(36.21),
                        ),
                      ),
                      onPressed: () {
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
              ],
            ),
          ),
        ));
  }
}

class CustomRow extends StatelessWidget {
  CustomRow(
      {required this.FieldName,
      required this.hintText,
      required this.textEditingController});
  TextEditingController textEditingController;
  String FieldName;
  String hintText;
  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          FieldName,
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            color: const Color(0xFF407BFF),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(
            // height: 40.h,
            width: 170.w,
            child: CustomTextFormField(
                controller: textEditingController, hintText: hintText))
      ],
    );
  }
}
