import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/flag_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/modules/crew_referral/controllers/crew_referral_controller.dart';
import 'package:join_mp_ship/app/modules/job_post/controllers/job_post_controller.dart';
import 'package:join_mp_ship/utils/styles.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
import 'package:join_mp_ship/widgets/dropdown_decoration.dart';
import 'package:time_machine/time_machine.dart';
import 'package:join_mp_ship/utils/extensions/date_time.dart';
import 'package:collection/collection.dart';

class JobForm extends GetView<CrewReferralController> {
  const JobForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    24.verticalSpace,
                    Text("Refer a new job", style: Get.textTheme.titleLarge),
                    28.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text("Tentative Joining",
                              style: Get.textTheme.titleSmall
                                  ?.copyWith(color: Get.theme.primaryColor)),
                        ),
                        20.horizontalSpace,
                        Expanded(
                            flex: 3,
                            child: CustomTextFormField(
                              isDate: true,
                              hintText: "dd-mm-yyyy",
                              onTap: () async {
                                LocalDate a =
                                    LocalDate.dateTime(DateTime.now());
                                LocalDate b = a.addMonths(1);
                                DateTime c = DateTime(
                                    b.year,
                                    b.monthOfYear,
                                    DateTime(a.addMonths(2).year,
                                            a.addMonths(2).monthOfYear, 0)
                                        .day);
                                DateTime? selectedDateTime =
                                    await showDatePicker(
                                        context: Get.context!,
                                        initialDate: DateTime.now(),
                                        firstDate: DateTime.now(),
                                        lastDate: c);
                                controller.tentativeJoining.text =
                                    selectedDateTime?.getServerDate() ?? "";
                              },
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                              controller: controller.tentativeJoining,
                              validator: (value) {
                                DateTime? timeEntered = DateTime.tryParse(
                                    value?.split("-").reversed.join("-") ?? "");
                                LocalDate a =
                                    LocalDate.dateTime(DateTime.now());
                                LocalDate b = a.addMonths(1);
                                DateTime c = DateTime(
                                    b.year,
                                    b.monthOfYear,
                                    DateTime(a.addMonths(2).year,
                                            a.addMonths(2).monthOfYear, 0)
                                        .day);
                                if (timeEntered?.isBefore(DateTime.now()) ==
                                        true ||
                                    timeEntered?.isAfter(c) == true) {
                                  return "Please enter valid Date";
                                }
                                return null;
                              },
                            ))
                      ],
                    ),
                    if (controller.misses.contains(Miss.tentativeJoining)) ...[
                      8.verticalSpace,
                      Text(Miss.tentativeJoining.errorMessage,
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Colors.red)),
                    ],
                    12.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text("Vessel Type",
                              style: Get.textTheme.titleSmall
                                  ?.copyWith(color: Get.theme.primaryColor)),
                        ),
                        20.horizontalSpace,
                        Expanded(
                          flex: 3,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<int>(
                              value: controller.recordVesselType.value,
                              isExpanded: true,
                              style: Get.textTheme.bodySmall,
                              items: controller.vesselList?.vessels
                                      ?.map((e) => [
                                            DropdownMenuItem<int>(
                                                enabled: false,
                                                child: Text(
                                                  e.vesselName ?? "",
                                                  maxLines: 1,
                                                  style: Get
                                                      .textTheme.titleSmall
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                )),
                                            ...?e.subVessels?.map((e) =>
                                                DropdownMenuItem<int>(
                                                    value: e.id,
                                                    child: Text(e.name ?? "",
                                                        maxLines: 1,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Get.textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontSize: 12))))
                                          ])
                                      .expand((element) => element)
                                      .toList() ??
                                  [],
                              onChanged: (value) {
                                controller.recordVesselType.value = value;
                              },
                              hint: const Text("Select Vessel"),
                              buttonStyleData: ButtonStyleData(
                                  height: 40,
                                  width: 200,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(64),
                                    border: Border.all(
                                        color: Get.theme.primaryColor),
                                  )),
                            ),
                          ),
                        )
                      ],
                    ),
                    if (controller.misses.contains(Miss.vesselType)) ...[
                      8.verticalSpace,
                      Text(Miss.vesselType.errorMessage,
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Colors.red)),
                    ],
                    12.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text("Vessel IMO No.",
                              style: Get.textTheme.titleSmall
                                  ?.copyWith(color: Get.theme.primaryColor)),
                        ),
                        20.horizontalSpace,
                        Expanded(
                            flex: 3,
                            child: CustomTextFormField(
                              hintText: "Enter IMO",
                              controller: controller.vesselIMONo,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly
                              ],
                              keyboardType: TextInputType.number,
                            ))
                      ],
                    ),
                    if (controller.misses.contains(Miss.vesselIMONo)) ...[
                      8.verticalSpace,
                      Text(Miss.vesselIMONo.errorMessage,
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Colors.red)),
                    ],
                    12.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text("Flag",
                              style: Get.textTheme.titleSmall
                                  ?.copyWith(color: Get.theme.primaryColor)),
                        ),
                        20.horizontalSpace,
                        Expanded(
                            flex: 3,
                            child: TypeAheadFormField<Flag>(
                              textFieldConfiguration: TextFieldConfiguration(
                                controller: controller.flag,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Flag",
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
                                  (BuildContext context, Flag itemData) {
                                return Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(itemData.flagCode ?? ""),
                                      Text(itemData.countryName ?? "",
                                          style: Get.textTheme.bodySmall
                                              ?.copyWith(color: Colors.grey)),
                                    ],
                                  ),
                                );
                              },
                              onSuggestionSelected: (Flag suggestion) {
                                controller.selectedFlag.value = suggestion;
                                controller.flag.text =
                                    suggestion.flagCode ?? "";
                              },
                              suggestionsCallback: (String pattern) {
                                return Future.value(controller.flags.where(
                                    (flag) =>
                                        flag.flagCode?.toLowerCase().startsWith(
                                            pattern.toLowerCase()) ==
                                        true));
                              },
                            ))
                      ],
                    ),
                    if (controller.misses.contains(Miss.flag)) ...[
                      8.verticalSpace,
                      Text(Miss.flag.errorMessage,
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Colors.red)),
                    ],
                    12.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Text("Joining Port",
                              style: Get.textTheme.titleSmall
                                  ?.copyWith(color: Get.theme.primaryColor)),
                        ),
                        20.horizontalSpace,
                        Expanded(
                            flex: 3,
                            child: CustomTextFormField(
                              hintText: "Enter Port",
                              controller: controller.joiningPort,
                            ))
                      ],
                    ),
                    if (controller.misses.contains(Miss.joiningPort)) ...[
                      8.verticalSpace,
                      Text(Miss.joiningPort.errorMessage,
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Colors.red)),
                    ],
                    18.verticalSpace,
                    Text("Crew Requirements",
                        style: Get.textTheme.titleSmall
                            ?.copyWith(color: Get.theme.primaryColor)),
                    18.verticalSpace,
                    ...CrewRequirements.values.map((e) => Obx(() {
                          return Row(
                            children: [
                              Radio<CrewRequirements>(
                                  groupValue:
                                      controller.selectedCrewRequirement.value,
                                  value: e,
                                  onChanged: (_) {
                                    controller.selectedRank.value = null;
                                    controller.selectedCrewRequirement.value =
                                        e;
                                  }),
                              Text(e.name, style: Get.textTheme.bodyMedium),
                              const Spacer(),
                              if (controller.selectedCrewRequirement.value == e)
                                DropdownButtonHideUnderline(
                                  child: DropdownButton2<Rank>(
                                    value: controller.selectedRank.value,
                                    isExpanded: true,
                                    style: Get.textTheme.bodySmall,
                                    items: controller.ranks
                                        .where((p0) => p0.jobType == e)
                                        .map((e) => DropdownMenuItem<Rank>(
                                            value: e,
                                            child: Text(e.name ?? "",
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style:
                                                    Get.textTheme.titleMedium)))
                                        .toList(),
                                    onChanged: (Rank? newRank) {
                                      controller.selectedRank.value = newRank;
                                    },
                                    hint: const Text("Select Rank"),
                                    buttonStyleData: ButtonStyleData(
                                        height: 40,
                                        width: 150,
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        decoration: DropdownDecoration()),
                                  ),
                                ),
                            ],
                          );
                        })),
                    if (controller.misses.contains(Miss.rank))
                      Text(Miss.rank.errorMessage,
                          style: Get.textTheme.bodySmall
                              ?.copyWith(color: Get.theme.colorScheme.error)),
                    24.verticalSpace,
                    Text("Add COC requirements",
                        style: Get.textTheme.titleSmall
                            ?.copyWith(color: Get.theme.primaryColor)),
                    16.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              8.horizontalSpace,
                              SizedBox(
                                width: 16,
                                height: 16,
                                child: Radio<bool>(
                                    value: controller.needCOCRequirements.value,
                                    groupValue: false,
                                    onChanged: (_) {
                                      controller.needCOCRequirements.value =
                                          false;
                                      controller.cocRequirementsSelected
                                          .clear();
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
                                      controller.needCOCRequirements.value =
                                          true;
                                    }),
                              ),
                              8.horizontalSpace,
                              const Text("Yes"),
                            ],
                          ),
                        ),
                        12.horizontalSpace,
                        if (controller.needCOCRequirements.value)
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<Coc>(
                                value: null,
                                isExpanded: true,
                                style: Get.textTheme.bodySmall,
                                items: controller.cocs
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        onTap: () {
                                          if (controller.cocRequirementsSelected
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
                                                                element.id ==
                                                                e.id) ==
                                                        true) {
                                                      controller
                                                          .cocRequirementsSelected
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  e.id);
                                                    } else {
                                                      controller
                                                          .cocRequirementsSelected
                                                          .add(e);
                                                    }
                                                  }),
                                              Flexible(
                                                child: Text(
                                                  e.name ?? "",
                                                  style:
                                                      Get.textTheme.titleMedium,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          );
                                        })))
                                    .toList(),
                                onChanged: (value) {},
                                hint: const Text("Select"),
                                buttonStyleData: ButtonStyleData(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: DropdownDecoration()),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (controller.misses.contains(Miss.coc)) ...[
                      8.verticalSpace,
                      Text(Miss.coc.errorMessage,
                          style: Get.textTheme.bodySmall
                              ?.copyWith(color: Get.theme.colorScheme.error)),
                    ],
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
                        style: Get.textTheme.titleSmall
                            ?.copyWith(color: Get.theme.primaryColor)),
                    16.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            8.horizontalSpace,
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: Radio<bool>(
                                  value: controller.needCOPRequirements.value,
                                  groupValue: false,
                                  onChanged: (_) {
                                    controller.needCOPRequirements.value =
                                        false;
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
                          ],
                        )),
                        12.horizontalSpace,
                        if (controller.needCOPRequirements.value)
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<Cop>(
                                value: null,
                                isExpanded: true,
                                style: Get.textTheme.bodySmall,
                                items: controller.cops
                                    .map((e) => DropdownMenuItem(
                                        value: e,
                                        onTap: () {
                                          if (controller.copRequirementsSelected
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
                                                                element.id ==
                                                                e.id) ==
                                                        true) {
                                                      controller
                                                          .copRequirementsSelected
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  e.id);
                                                    } else {
                                                      controller
                                                          .copRequirementsSelected
                                                          .add(e);
                                                    }
                                                  }),
                                              Flexible(
                                                child: Text(
                                                  e.name ?? "",
                                                  style:
                                                      Get.textTheme.titleMedium,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          );
                                        })))
                                    .toList(),
                                onChanged: (value) {},
                                hint: const Text("Select"),
                                buttonStyleData: ButtonStyleData(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: DropdownDecoration()),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (controller.misses.contains(Miss.cop)) ...[
                      8.verticalSpace,
                      Text(Miss.cop.errorMessage,
                          style: Get.textTheme.bodySmall
                              ?.copyWith(color: Get.theme.colorScheme.error)),
                    ],
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
                        style: Get.textTheme.titleSmall
                            ?.copyWith(color: Get.theme.primaryColor)),
                    16.verticalSpace,
                    Row(
                      children: [
                        Expanded(
                            child: Row(
                          children: [
                            8.horizontalSpace,
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: Radio<bool>(
                                  value: controller
                                      .needWatchKeepingRequirements.value,
                                  groupValue: false,
                                  onChanged: (_) {
                                    controller.needWatchKeepingRequirements
                                        .value = false;
                                    controller.watchKeepingRequirementsSelected
                                        .clear();
                                  }),
                            ),
                            8.horizontalSpace,
                            const Text("No"),
                            16.horizontalSpace,
                            SizedBox(
                              height: 16,
                              width: 16,
                              child: Radio<bool>(
                                  value: controller
                                      .needWatchKeepingRequirements.value,
                                  groupValue: true,
                                  onChanged: (_) {
                                    controller.needWatchKeepingRequirements
                                        .value = true;
                                  }),
                            ),
                            8.horizontalSpace,
                            const Text("Yes"),
                          ],
                        )),
                        12.horizontalSpace,
                        if (controller.needWatchKeepingRequirements.value)
                          Expanded(
                            child: DropdownButtonHideUnderline(
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
                                            controller
                                                .watchKeepingRequirementsSelected
                                                .removeWhere((element) =>
                                                    element.id == e.id);
                                          } else {
                                            controller
                                                .watchKeepingRequirementsSelected
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
                                                                element.id ==
                                                                e.id) ==
                                                        true) {
                                                      controller
                                                          .watchKeepingRequirementsSelected
                                                          .removeWhere(
                                                              (element) =>
                                                                  element.id ==
                                                                  e.id);
                                                    } else {
                                                      controller
                                                          .watchKeepingRequirementsSelected
                                                          .add(e);
                                                    }
                                                  }),
                                              Text(e.name ?? "",
                                                  style: Get
                                                      .textTheme.titleMedium),
                                            ],
                                          );
                                        })))
                                    .toList(),
                                onChanged: (value) {},
                                hint: const Text("Select"),
                                buttonStyleData: ButtonStyleData(
                                    height: 40,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    decoration: DropdownDecoration()),
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (controller.misses.contains(Miss.watchKeeping)) ...[
                      8.verticalSpace,
                      Text(Miss.watchKeeping.errorMessage,
                          style: Get.textTheme.bodySmall
                              ?.copyWith(color: Get.theme.colorScheme.error)),
                    ],
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text("Job post expiry",
                              style: Get.textTheme.titleSmall
                                  ?.copyWith(color: Get.theme.primaryColor)),
                        ),
                        12.horizontalSpace,
                        Expanded(
                          child: DropdownButtonHideUnderline(
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
                                          style: Get.textTheme.bodySmall)))
                                  .toList(),
                              onChanged: (value) {},
                              hint: const Text("Select"),
                              buttonStyleData: ButtonStyleData(
                                  height: 40,
                                  width: 200,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  decoration: DropdownDecoration()),
                            ),
                          ),
                        ),
                      ],
                    ),
                    32.verticalSpace,
                    Center(
                      child: SizedBox(
                        width: 232,
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
                              controller.validate();
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
