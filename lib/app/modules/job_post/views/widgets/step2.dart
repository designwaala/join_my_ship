import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/modules/job_post/controllers/job_post_controller.dart';
import 'package:join_mp_ship/utils/styles.dart';
import 'package:join_mp_ship/widgets/custom_elevated_button.dart';
import 'package:join_mp_ship/widgets/dropdown_decoration.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class JobPostStep2 extends GetView<JobPostController> {
  const JobPostStep2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              24.verticalSpace,
              Text("Add COC requirements",
                  style: Get.textTheme.formFieldHeading),
              16.verticalSpace,
              Row(
                children: [
                  8.horizontalSpace,
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Radio<bool>(
                        value: controller.needCOCRequirements.value,
                        groupValue: false,
                        onChanged: (_) {
                          controller.needCOCRequirements.value = false;
                          controller.cocRequirementsSelected.clear();
                        }),
                  ),
                  8.horizontalSpace,
                  const Text("No"),
                  16.horizontalSpace,
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: Radio<bool>(
                        value: controller.needCOCRequirements.value,
                        groupValue: true,
                        onChanged: (_) {
                          controller.needCOCRequirements.value = true;
                        }),
                  ),
                  8.horizontalSpace,
                  const Text("Yes"),
                  const Spacer(),
                  if (controller.needCOCRequirements.value)
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<Coc>(
                        value: null,
                        isExpanded: true,
                        style: Get.textTheme.bodySmall,
                        items: controller.cocs
                            .map((e) => DropdownMenuItem(
                                value: e,
                                onTap: () {
                                  if (controller.cocRequirementsSelected.any(
                                          (element) => element.id == e.id) ==
                                      true) {
                                    controller.cocRequirementsSelected
                                        .removeWhere(
                                            (element) => element.id == e.id);
                                  } else {
                                    controller.cocRequirementsSelected.add(e);
                                  }
                                },
                                child: Obx(() {
                                  return Row(
                                    children: [
                                      Checkbox(
                                          value: controller
                                              .cocRequirementsSelected
                                              .any((element) =>
                                                  element.id == e.id),
                                          onChanged: (value) {
                                            if (controller
                                                    .cocRequirementsSelected
                                                    .any((element) =>
                                                        element.id == e.id) ==
                                                true) {
                                              controller.cocRequirementsSelected
                                                  .removeWhere((element) =>
                                                      element.id == e.id);
                                            } else {
                                              controller.cocRequirementsSelected
                                                  .add(e);
                                            }
                                          }),
                                      Text(e.name ?? "",
                                          style: Get.textTheme.titleMedium),
                                    ],
                                  );
                                })))
                            .toList(),
                        onChanged: (value) {},
                        hint: const Text("Select"),
                        buttonStyleData: ButtonStyleData(
                            height: 40,
                            width: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: DropdownDecoration()),
                      ),
                    ),
                ],
              ),
              8.verticalSpace,
              Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: controller.cocRequirementsSelected
                      .map(
                        (e) => Chip(label: Text(e.name ?? "")),
                      )
                      .toList()),
              12.verticalSpace,
              Text("Add COP requirements",
                  style: Get.textTheme.formFieldHeading),
              16.verticalSpace,
              Row(
                children: [
                  8.horizontalSpace,
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Radio<bool>(
                        value: controller.needCOPRequirements.value,
                        groupValue: false,
                        onChanged: (_) {
                          controller.needCOPRequirements.value = false;
                          controller.copRequirementsSelected.clear();
                        }),
                  ),
                  8.horizontalSpace,
                  const Text("No"),
                  16.horizontalSpace,
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: Radio<bool>(
                        value: controller.needCOPRequirements.value,
                        groupValue: true,
                        onChanged: (_) {
                          controller.needCOPRequirements.value = true;
                        }),
                  ),
                  8.horizontalSpace,
                  const Text("Yes"),
                  const Spacer(),
                  if (controller.needCOPRequirements.value)
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<Cop>(
                        value: null,
                        isExpanded: true,
                        style: Get.textTheme.bodySmall,
                        items: controller.cops
                            .map((e) => DropdownMenuItem(
                                value: e,
                                onTap: () {
                                  if (controller.copRequirementsSelected.any(
                                          (element) => element.id == e.id) ==
                                      true) {
                                    controller.copRequirementsSelected
                                        .removeWhere(
                                            (element) => element.id == e.id);
                                  } else {
                                    controller.copRequirementsSelected.add(e);
                                  }
                                },
                                child: Obx(() {
                                  return Row(
                                    children: [
                                      Checkbox(
                                          value: controller
                                              .copRequirementsSelected
                                              .any((element) =>
                                                  element.id == e.id),
                                          onChanged: (value) {
                                            if (controller
                                                    .copRequirementsSelected
                                                    .any((element) =>
                                                        element.id == e.id) ==
                                                true) {
                                              controller.copRequirementsSelected
                                                  .removeWhere((element) =>
                                                      element.id == e.id);
                                            } else {
                                              controller.copRequirementsSelected
                                                  .add(e);
                                            }
                                          }),
                                      Text(e.name ?? "",
                                          style: Get.textTheme.titleMedium),
                                    ],
                                  );
                                })))
                            .toList(),
                        onChanged: (value) {},
                        hint: const Text("Select"),
                        buttonStyleData: ButtonStyleData(
                            height: 40,
                            width: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: DropdownDecoration()),
                      ),
                    ),
                ],
              ),
              8.verticalSpace,
              Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: controller.copRequirementsSelected
                      .map(
                        (e) => Chip(label: Text(e.name ?? "")),
                      )
                      .toList()),
              12.verticalSpace,
              Text("Add Watch Keepings requirements",
                  style: Get.textTheme.formFieldHeading),
              16.verticalSpace,
              Row(
                children: [
                  8.horizontalSpace,
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Radio<bool>(
                        value: controller.needWatchKeepingRequirements.value,
                        groupValue: false,
                        onChanged: (_) {
                          controller.needWatchKeepingRequirements.value = false;
                          controller.watchKeepingRequirementsSelected.clear();
                        }),
                  ),
                  8.horizontalSpace,
                  const Text("No"),
                  16.horizontalSpace,
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: Radio<bool>(
                        value: controller.needWatchKeepingRequirements.value,
                        groupValue: true,
                        onChanged: (_) {
                          controller.needWatchKeepingRequirements.value = true;
                        }),
                  ),
                  8.horizontalSpace,
                  const Text("Yes"),
                  const Spacer(),
                  if (controller.needWatchKeepingRequirements.value)
                    DropdownButtonHideUnderline(
                      child: DropdownButton2<WatchKeeping>(
                        value: null,
                        isExpanded: true,
                        style: Get.textTheme.bodySmall,
                        items: controller.watchKeepings
                            .map((e) => DropdownMenuItem(
                                value: e,
                                onTap: () {
                                  if (controller
                                          .watchKeepingRequirementsSelected
                                          .any((element) =>
                                              element.id == e.id) ==
                                      true) {
                                    controller.watchKeepingRequirementsSelected
                                        .removeWhere(
                                            (element) => element.id == e.id);
                                  } else {
                                    controller.watchKeepingRequirementsSelected
                                        .add(e);
                                  }
                                },
                                child: Obx(() {
                                  return Row(
                                    children: [
                                      Checkbox(
                                          value: controller
                                              .watchKeepingRequirementsSelected
                                              .any((element) =>
                                                  element.id == e.id),
                                          onChanged: (value) {
                                            if (controller
                                                    .watchKeepingRequirementsSelected
                                                    .any((element) =>
                                                        element.id == e.id) ==
                                                true) {
                                              controller
                                                  .watchKeepingRequirementsSelected
                                                  .removeWhere((element) =>
                                                      element.id == e.id);
                                            } else {
                                              controller
                                                  .watchKeepingRequirementsSelected
                                                  .add(e);
                                            }
                                          }),
                                      Text(e.name ?? "",
                                          style: Get.textTheme.titleMedium),
                                    ],
                                  );
                                })))
                            .toList(),
                        onChanged: (value) {},
                        hint: const Text("Select"),
                        buttonStyleData: ButtonStyleData(
                            height: 40,
                            width: 200,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: DropdownDecoration()),
                      ),
                    ),
                ],
              ),
              8.verticalSpace,
              Wrap(
                  spacing: 16,
                  runSpacing: 8,
                  children: controller.watchKeepingRequirementsSelected
                      .map(
                        (e) => Chip(label: Text(e.name ?? "")),
                      )
                      .toList()),
              16.verticalSpace,
              Text("Add contact details",
                  style: Get.textTheme.formFieldHeading),
              12.verticalSpace,
              Row(
                children: [
                  Text("Mobile Number",
                      style: Get.textTheme.formFieldSmallHeading),
                  Spacer(),
                  8.horizontalSpace,
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Radio<bool>(
                        value: controller.showMobileNumber.value,
                        groupValue: false,
                        onChanged: (_) {
                          controller.showMobileNumber.value = false;
                        }),
                  ),
                  8.horizontalSpace,
                  const Text("No"),
                  16.horizontalSpace,
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: Radio<bool>(
                        value: controller.showMobileNumber.value,
                        groupValue: true,
                        onChanged: (_) {
                          controller.showMobileNumber.value = true;
                        }),
                  ),
                  8.horizontalSpace,
                  const Text("Yes"),
                ],
              ),
              16.verticalSpace,
              Row(
                children: [
                  Text("Email Address",
                      style: Get.textTheme.formFieldSmallHeading),
                  Spacer(),
                  8.horizontalSpace,
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: Radio<bool>(
                        value: controller.showEmail.value,
                        groupValue: false,
                        onChanged: (_) {
                          controller.showEmail.value = false;
                        }),
                  ),
                  8.horizontalSpace,
                  const Text("No"),
                  16.horizontalSpace,
                  SizedBox(
                    height: 16,
                    width: 16,
                    child: Radio<bool>(
                        value: controller.showEmail.value,
                        groupValue: true,
                        onChanged: (_) {
                          controller.showEmail.value = true;
                        }),
                  ),
                  8.horizontalSpace,
                  const Text("Yes"),
                ],
              ),
              16.verticalSpace,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Job post expiry",
                      style: Get.textTheme.formFieldHeading),
                  Spacer(),
                  DropdownButtonHideUnderline(
                    child: DropdownButton2<int>(
                      value: controller.jobExpiry.value,
                      isExpanded: true,
                      style: Get.textTheme.bodySmall,
                      items: [1, 7, 15, 30]
                          .map((e) => DropdownMenuItem<int>(
                              value: e,
                              onTap: () {
                                controller.jobExpiry.value = e;
                              },
                              child: Text("$e days",
                                  style: Get.textTheme.titleMedium)))
                          .toList(),
                      onChanged: (value) {},
                      hint: const Text("Select"),
                      buttonStyleData: ButtonStyleData(
                          height: 40,
                          width: 200,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          decoration: DropdownDecoration()),
                    ),
                  ),
                ],
              ),
              32.verticalSpace,
              Center(
                child: SizedBox(
                  width: 232,
                  child: CustomElevatedButon(
                      onPressed: () {
                        controller.currentStep.value = 3;
                      },
                      child: const Text("SAVE & CONTINUE")),
                ),
              ),
              32.verticalSpace,
            ],
          ),
        ),
      );
    });
  }
}
