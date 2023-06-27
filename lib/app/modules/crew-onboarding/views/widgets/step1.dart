import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/state_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/utils/extensions/date_time.dart';
import 'package:join_mp_ship/widgets/astrix_text.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
import 'package:join_mp_ship/widgets/dropdown_decoration.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:flutter/services.dart';
import 'package:join_mp_ship/widgets/top_modal_sheet.dart';
import 'package:permission_handler/permission_handler.dart';

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
              Text("Create Profile",
                  style: Get.theme.textTheme.headlineSmall
                      ?.copyWith(fontSize: 20)),
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
                        const AsterixText("Current Rank"),
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
                      style: Get.textTheme.bodySmall,
                      items: controller.ranks
                              ?.map((e) => DropdownMenuItem<Rank>(
                                  value: e,
                                  child: Text(e.name ?? "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Get.textTheme.titleMedium)))
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
                          decoration: DropdownDecoration()),
                    ),
                  )
                ],
              ),
              16.verticalSpace,
              if (controller.selectedRank.value?.isPromotable == true) ...[
                const AsterixText("Are you looking for Promotion?"),
                16.verticalSpace,
                Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Radio(
                          value: controller.isLookingForPromotion.value,
                          groupValue: false,
                          onChanged: (_) {
                            controller.isLookingForPromotion.value = false;
                          }),
                    ),
                    8.horizontalSpace,
                    const Text("No"),
                    16.horizontalSpace,
                    SizedBox(
                      height: 16,
                      width: 16,
                      child: Radio(
                          value: controller.isLookingForPromotion.value,
                          groupValue: true,
                          onChanged: (_) {
                            controller.isLookingForPromotion.value = true;
                          }),
                    ),
                    8.horizontalSpace,
                    const Text("Yes"),
                    const Spacer(),
                  ],
                ),
                8.verticalSpace,
                if (controller.isLookingForPromotion.value)
                  Text(
                      "You would be promoted to ${controller.ranks?.firstWhereOrNull((rank) => rank.id == controller.selectedRank.value?.promotedTo)?.name}")
              ],
              16.verticalSpace,
              Row(
                children: [
                  const AsterixText("Gender"),
                  24.horizontalSpace,
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
              20.verticalSpace,
              const AsterixText("Communication address"),
              16.verticalSpace,
              Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Builder(builder: (context) {
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
                                    borderSide: BorderSide(
                                        color: Get.theme.primaryColor),
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
                              controller.country.value = suggestion;
                              controller
                                ..states.clear()
                                ..getStates();
                              countryController.text =
                                  suggestion.countryName ?? "";
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
                        /* DropdownButtonHideUnderline(
                          child: DropdownButton2<Country>(
                            value: controller.country.value,
                            isExpanded: true,
                            style: Get.textTheme.bodySmall,
                            items: controller.countries
                                .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e.countryName ?? "",
                                        style: Get.textTheme.titleMedium)))
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
                                decoration: DropdownDecoration()),
                          ),
                        ), */
                        if (controller.step1FormMisses
                            .contains(Step1FormMiss.didNotSelectCountry)) ...[
                          4.verticalSpace,
                          Text("Please select your Country",
                              style: Get.textTheme.bodySmall
                                  ?.copyWith(color: Colors.red)),
                        ]
                      ],
                    ),
                  ),
                  20.horizontalSpace,
                  Expanded(
                    child: controller.isLoadingStates.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              SizedBox(
                                  height: 16,
                                  width: 16,
                                  child: CircularProgressIndicator())
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
                                            style: Get.textTheme.titleMedium,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          )))
                                      .toList(),
                                  style: Get.textTheme.bodySmall,
                                  onChanged: (value) {
                                    controller.state.value = controller.states
                                        .firstWhereOrNull(
                                            (state) => state.id == value);
                                  },
                                  hint: const Text("State"),
                                  buttonStyleData: ButtonStyleData(
                                      height: 40,
                                      width: 160,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                      decoration: DropdownDecoration()),
                                ),
                              ),
                              if (controller.step1FormMisses.contains(
                                  Step1FormMiss.didNotSelectState)) ...[
                                4.verticalSpace,
                                Text("Please select your State",
                                    style: Get.textTheme.bodySmall
                                        ?.copyWith(color: Colors.red)),
                              ]
                            ],
                          ),
                  ),
                ],
              ),
              16.verticalSpace,
              CustomTextFormField(
                  controller: controller.city,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your city";
                    }
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z]+'))
                  ],
                  hintText: "City"),
              16.verticalSpace,
              CustomTextFormField(
                  controller: controller.addressLine1,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your address";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r"^[a-zA-Z0-9&,.-/-' ]+"))
                  ],
                  hintText: "Address Line 1"),
              16.verticalSpace,
              CustomTextFormField(
                  controller: controller.addressLine2,
                  validator: (value) {
                    return null;
                    if (value == null || value.isEmpty) {
                      return "Please enter your address";
                    }
                    return null;
                  },
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r"^[a-zA-Z0-9&,.-/-' ]+"))
                  ],
                  hintText: "Address Line 2"),
              16.verticalSpace,
              CustomTextFormField(
                  controller: controller.zipCode,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter your zip code";
                    }
                    return null;
                  },
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  hintText: "Zip Code"),
              16.verticalSpace,
              Row(
                children: [
                  const Expanded(child: AsterixText("Date of birth")),
                  20.horizontalSpace,
                  Expanded(
                      child: CustomTextFormField(
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
                                firstDate: DateTime.parse("1950-01-01"),
                                lastDate: DateTime.now());
                            controller.dateOfBirth.text =
                                selectedDateTime?.getServerDate() ?? "";
                          },
                          hintText: "yyyy/mm/dd",
                          icon: Icon(
                            Icons.calendar_month,
                            color: Get.theme.primaryColor,
                          )))
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
                      const AsterixText("Marital Status"),
                      if (controller.step1FormMisses
                          .contains(Step1FormMiss.didNotSelectMaritalStatus))
                        Text("Please select your Marital Status",
                            style: Get.textTheme.bodySmall
                                ?.copyWith(color: Colors.red)),
                    ],
                  )),
                  20.horizontalSpace,
                  Expanded(
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        value: maritalStatuses[controller.maritalStatus.value],
                        isExpanded: true,
                        style: Get.textTheme.bodySmall,
                        items: maritalStatuses.keys
                            .map((e) => DropdownMenuItem<String>(
                                value: maritalStatuses[e],
                                child: Text(maritalStatuses[e] ?? "",
                                    style: Get.textTheme.titleMedium)))
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
                            decoration: DropdownDecoration()),
                      ),
                    ),
                  )
                ],
              ),
              24.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: const AsterixText("Upload Resume")),
                  20.horizontalSpace,
                  Expanded(
                    child: SizedBox(
                      height: 40,
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
                            try {
                              await controller.pickResume();
                            } on PlatformException catch (e) {
                              print(e);
                              if (e.message != null) {
                                showTopModalSheet(
                                    context,
                                    Column(
                                      children: [
                                        16.verticalSpace,
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.red,
                                          size: 48,
                                        ),
                                        16.verticalSpace,
                                        Text(e.message ?? "",
                                            style: Get.textTheme.titleMedium),
                                        if (e.code ==
                                            "read_external_storage_denied") ...[
                                          16.verticalSpace,
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              OutlinedButton(
                                                  onPressed: Get.back,
                                                  child: const Text("Cancel")),
                                              32.horizontalSpace,
                                              OutlinedButton(
                                                  onPressed: () async {
                                                    await openAppSettings();
                                                    Get.back();
                                                    /* PermissionStatus status =
                                                    await Permission
                                                        .storage.status;
                                                if (status ==
                                                    PermissionStatus.granted) {
                                                  controller.fToast.safeShowToast(
                                                      child: successToast(
                                                          "Got Storage Permission, picking resume"));
                                                  await Future.delayed(
                                                      const Duration(
                                                          milliseconds: 500));
                                                  controller.pickResume();
                                                } */
                                                  },
                                                  child: Text("Open Settings")),
                                            ],
                                          )
                                        ]
                                      ],
                                    ));
                              }
                            }
                          },
                          child: controller.uploadedResumePath.value != null
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.check),
                                    4.horizontalSpace,
                                    const Text("Resume Uploaded")
                                  ],
                                )
                              : controller.pickedResume.value != null
                                  ? Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check),
                                        4.horizontalSpace,
                                        Flexible(
                                            child: const Text(
                                          "Resume picked",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ))
                                      ],
                                    )
                                  : Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.upload),
                                        4.horizontalSpace,
                                        Text("UPLOAD",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: Get
                                                        .theme.primaryColor)),
                                      ],
                                    )),
                    ),
                  ),
                ],
              ),
              16.verticalSpace,
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
                        ?.copyWith(fontSize: 11.sp, color: Colors.grey)),
              ),
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  controller.isUpdating.value
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            bool shouldContinue = await controller.postStep1();
                            if (shouldContinue == true) {
                              controller.step.value = 2;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64))),
                          child: controller.crewUser?.id == null
                              ? const Text("SAVE & CONTINUE")
                              : const Text("UPDATE & CONTINUE"),
                        )
                ],
              ),
              24.verticalSpace
            ],
          ),
        ),
      );
    });
  }
}
