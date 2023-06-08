import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/state_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/utils/extensions/date_time.dart';

class CrewonboardingStep1 extends GetView<CrewOnboardingController> {
  const CrewonboardingStep1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Form(
        key: controller.formKeyStep1,
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
                  const Icon(Icons.check_circle, color: Colors.grey),
                  Container(
                    width: 18.w,
                    height: 2.h,
                    color: Colors.grey,
                  ),
                  const Icon(Icons.check_circle, color: Colors.grey),
                ],
              ),
              22.verticalSpace,
              Text("Create Profile", style: Get.theme.textTheme.headlineSmall),
              8.verticalSpace,
              Text("Please complete your profile",
                  style:
                      Get.textTheme.bodyMedium?.copyWith(color: Colors.grey)),
              24.verticalSpace,
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
                                      controller.uploadedImagePath.value ?? "",
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
                                size: 85.sp, color: Colors.grey.shade400),
                            Positioned(
                                bottom: 4,
                                right: 4,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white,
                                  ),
                                  child: Icon(Icons.add_circle,
                                      color: Get.theme.primaryColor, size: 32),
                                ))
                          ],
                        ),
                      ),
              ),
              12.verticalSpace,
              Center(
                child: Text("Upload Profile Pic",
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(color: Get.theme.primaryColor)),
              ),
              if (controller.step1FormMisses
                  .contains(Step1FormMiss.didNotSelectProfilePic))
                Center(
                  child: Text("Please select an image",
                      style:
                          Get.textTheme.bodySmall?.copyWith(color: Colors.red)),
                ),
              33.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Current Rank", style: _headingStyle),
                        if (controller.step1FormMisses.contains(
                            Step1FormMiss.didNotChooseCurrentRank)) ...[
                          2.verticalSpace,
                          Text("Please select your Current Rank.",
                              maxLines: 2,
                              style: Get.textTheme.bodySmall
                                  ?.copyWith(color: Colors.red)),
                        ],
                      ],
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<Rank>(
                      value: controller.selectedRank.value,
                      isExpanded: true,
                      style: Get.textTheme.bodyMedium,
                      items: controller.ranks
                              ?.map((e) => DropdownMenuItem<Rank>(
                                  value: e,
                                  child: Text(e.name ?? "",
                                      style: Get.textTheme.bodySmall
                                          ?.copyWith(color: Colors.black))))
                              .toList() ??
                          [],
                      onChanged: (value) {
                        controller.selectedRank.value = value;
                      },
                      hint: const Text("Select Rank"),
                      buttonStyleData: ButtonStyleData(
                          height: 40,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(64),
                            border: Border.all(color: Get.theme.primaryColor),
                          )),
                    ),
                  )
                ],
              ),
              16.verticalSpace,
              if (![
                "Master/Captain",
                "Cheif Officer",
                "ETO / Electrician",
                "Chief Cook",
                "Deck Cadet",
                "Trainee Electrical Cadet",
                "Engine Cadet",
                "Trainee Ordinary Seaman",
                "Trainee Wiper",
              ].contains(controller.selectedRank.value?.name)) ...[
                Text("Are you looking for Promotion?", style: _headingStyle),
                16.verticalSpace,
                Row(
                  children: [
                    Radio(
                        value: controller.isLookingForPromotion.value,
                        groupValue: false,
                        onChanged: (_) {
                          controller.isLookingForPromotion.value = false;
                        }),
                    const Text("No"),
                    16.horizontalSpace,
                    Radio(
                        value: controller.isLookingForPromotion.value,
                        groupValue: true,
                        onChanged: (_) {
                          controller.isLookingForPromotion.value = true;
                        }),
                    const Text("Yes"),
                    const Spacer(),
                    if (controller.isLookingForPromotion.value)
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<String>(
                          value: controller.promotionRank.value,
                          isExpanded: true,
                          items: controller.ranks
                              ?.map((e) => DropdownMenuItem(
                                  value: e.name,
                                  child: Text(e.name ?? "",
                                      style: Get.textTheme.bodySmall)))
                              .toList(),
                          onChanged: (value) {
                            controller.promotionRank.value = value;
                          },
                          hint: const Text("Select Rank"),
                          buttonStyleData: ButtonStyleData(
                              height: 40,
                              width: 160,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(64),
                                border:
                                    Border.all(color: Get.theme.primaryColor),
                              )),
                        ),
                      )
                  ],
                ),
                18.verticalSpace,
              ],
              Row(
                children: [
                  Text("Gender", style: _headingStyle),
                  24.horizontalSpace,
                  Radio<Gender?>(
                      value: controller.gender.value,
                      groupValue: Gender.male,
                      onChanged: (_) {
                        controller.gender.value = Gender.male;
                      }),
                  const Text("Male"),
                  16.horizontalSpace,
                  Radio<Gender?>(
                      value: controller.gender.value,
                      groupValue: Gender.female,
                      onChanged: (_) {
                        controller.gender.value = Gender.female;
                      }),
                  const Text("Female"),
                ],
              ),
              20.verticalSpace,
              Text("Communication address", style: _headingStyle),
              16.verticalSpace,
              TextFormField(
                  controller: controller.addressLine1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your address";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      hintText: "Address Line 1",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Get.theme.primaryColor),
                          borderRadius: BorderRadius.circular(64)))),
              16.verticalSpace,
              TextFormField(
                  controller: controller.addressLine2,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your address";
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Address Line 2",
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Get.theme.primaryColor),
                          borderRadius: BorderRadius.circular(64)))),
              16.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                        controller: controller.city,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your city";
                          }
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "City",
                            isDense: true,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Get.theme.primaryColor),
                                borderRadius: BorderRadius.circular(64)))),
                  ),
                  16.horizontalSpace,
                  Column(
                    children: [
                      DropdownButtonHideUnderline(
                        child: DropdownButton2<Country>(
                          value: controller.country.value,
                          isExpanded: true,
                          items: controller.countries
                              .map((e) => DropdownMenuItem(
                                  value: e, child: Text(e.countryName ?? "")))
                              .toList(),
                          onChanged: (value) {
                            controller
                              ..country.value = value
                              ..states.clear()
                              ..getStates();
                          },
                          hint: const Text("Country"),
                          buttonStyleData: ButtonStyleData(
                              height: 40,
                              width: 160,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(64),
                                border:
                                    Border.all(color: Get.theme.primaryColor),
                              )),
                        ),
                      ),
                      if (controller.step1FormMisses
                          .contains(Step1FormMiss.didNotSelectCountry)) ...[
                        4.verticalSpace,
                        Text("Please select your Country",
                            style: Get.textTheme.bodySmall
                                ?.copyWith(color: Colors.red)),
                      ]
                    ],
                  ),
                ],
              ),
              16.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
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
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )))
                                .toList(),
                            onChanged: (value) {
                              controller.state.value = controller.states
                                  .firstWhereOrNull(
                                      (state) => state.id == value);
                            },
                            hint: const Text("State"),
                            buttonStyleData: ButtonStyleData(
                                height: 40,
                                width: 160,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(64),
                                  border:
                                      Border.all(color: Get.theme.primaryColor),
                                )),
                          ),
                        ),
                        if (controller.step1FormMisses
                            .contains(Step1FormMiss.didNotSelectState)) ...[
                          4.verticalSpace,
                          Text("Please select your State",
                              style: Get.textTheme.bodySmall
                                  ?.copyWith(color: Colors.red)),
                        ]
                      ],
                    ),
                  ),
                  16.horizontalSpace,
                  Expanded(
                    child: TextFormField(
                        controller: controller.zipCode,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please enter your zip code";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Zip Code",
                            isDense: true,
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
              Row(
                children: [
                  Expanded(child: Text("Date of birth", style: _headingStyle)),
                  Expanded(
                      child: TextFormField(
                          controller: controller.dateOfBirth,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select your date of birth";
                            }
                            return null;
                          },
                          readOnly: true,
                          onTap: () async {
                            DateTime? selectedDateTime = await showDatePicker(
                                context: Get.context!,
                                initialDate: DateTime.parse("1990-01-01"),
                                firstDate: DateTime.parse("1990-01-01"),
                                lastDate: DateTime.now());
                            controller.dateOfBirth.text =
                                selectedDateTime?.getServerDate() ?? "";
                          },
                          decoration: InputDecoration(
                              fillColor: Colors.white,
                              filled: true,
                              hintText: "dd/mm/yyyy",
                              isDense: true,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 16),
                                child: Icon(
                                  Icons.calendar_month,
                                  color: Get.theme.primaryColor,
                                ),
                              ),
                              suffixIconConstraints: const BoxConstraints(
                                  maxHeight: 32, maxWidth: 32),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              border: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Get.theme.primaryColor),
                                  borderRadius: BorderRadius.circular(64)))))
                ],
              ),
              16.verticalSpace,
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Marital Status", style: _headingStyle),
                      if (controller.step1FormMisses
                          .contains(Step1FormMiss.didNotSelectMaritalStatus))
                        Text("Please select your Marital Status",
                            style: Get.textTheme.bodySmall
                                ?.copyWith(color: Colors.red)),
                    ],
                  )),
                  8.horizontalSpace,
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<String>(
                      value: maritalStatuses[controller.maritalStatus.value],
                      isExpanded: true,
                      items: maritalStatuses.keys
                          .map((e) => DropdownMenuItem<String>(
                              value: maritalStatuses[e],
                              child: Text(maritalStatuses[e] ?? "")))
                          .toList(),
                      onChanged: (value) {
                        controller.maritalStatus.value =
                            reverseMaritalStatuses[value];
                      },
                      hint: const Text("Select"),
                      buttonStyleData: ButtonStyleData(
                          height: 40,
                          width: 176,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(64),
                            border: Border.all(color: Get.theme.primaryColor),
                          )),
                    ),
                  )
                ],
              ),
              24.verticalSpace,
              Text("Upload Resume *", style: _headingStyle),
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
                        controller.pickedResume.value =
                            File(result!.files.single.path!);
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
                                ?.copyWith(color: Get.theme.primaryColor)),
                      ],
                    )),
              ),
              if (controller.step1FormMisses
                  .contains(Step1FormMiss.didNotSelectResume))
                Center(
                  child: Text("Please select your Resume",
                      style:
                          Get.textTheme.bodySmall?.copyWith(color: Colors.red)),
                ),
              8.verticalSpace,
              Center(
                child: Text(
                    "Supported file formats Doc, Docx, pdf | Maximum file size 2 MB",
                    style: Get.textTheme.bodyMedium
                        ?.copyWith(fontSize: 8.sp, color: Colors.grey)),
              ),
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  controller.crewUser?.id == null
                      ? controller.isUpdating.value
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                bool shouldContinue =
                                    await controller.postStep1();
                                if (shouldContinue == true) {
                                  controller.step.value = 2;
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(64))),
                              child: const Text("SAVE & CONTINUE"),
                            )
                      : ElevatedButton(
                          onPressed: () async {
                            controller.step.value = 2;
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64))),
                          child: const Text("NEXT"),
                        ),
                ],
              ),
              24.verticalSpace
            ],
          ),
        ),
      );
    });
  }

  TextStyle? get _headingStyle =>
      Get.textTheme.bodyMedium?.copyWith(color: Get.theme.primaryColor);
}
