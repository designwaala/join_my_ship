import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/flag_model.dart';
import 'package:join_my_ship/app/data/models/ranks_model.dart';
import 'package:join_my_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_my_ship/utils/extensions/date_time.dart';
import 'package:join_my_ship/widgets/custom_text_form_field.dart';

class AddARecord extends GetView<CrewOnboardingController> {
  final ScrollController scrollController;
  const AddARecord({Key? key, required this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isPreparingRecordBottomSheet.value
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
              ],
            )
          : SingleChildScrollView(
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
                  Text("Add a record",
                      style: Get.textTheme.bodyMedium?.copyWith(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  16.verticalSpace,
                  Text("Company Name", style: headingStyle),
                  16.verticalSpace,
                  CustomTextFormField(
                      controller: controller.recordCompanyName,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                            RegExp(r'^[a-zA-Z ]+'))
                      ],
                      hintText: "Company Name"),
                  16.verticalSpace,
                  Text("Ship Name", style: headingStyle),
                  16.verticalSpace,
                  CustomTextFormField(
                      controller: controller.recordShipName,
                      hintText: "Ship Name"),
                  20.verticalSpace,
                  Table(
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      TableRow(children: [
                        Text("IMO Number", style: headingStyle),
                        CustomTextFormField(
                            controller: controller.recordIMONumber,
                            keyboardType: TextInputType.number,
                            hintText: "IMO Number"),
                      ]),
                      TableRow(children: [
                        Text("Rank", style: headingStyle),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<Rank>(
                            value: controller.recordRank.value,
                            isExpanded: true,
                            style: Get.textTheme.bodySmall,
                            items: controller.ranks
                                    ?.map((e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e.name ?? "",
                                          style: Get.textTheme.titleMedium,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        )))
                                    .toList() ??
                                [],
                            onChanged: (value) {
                              controller.recordRank.value = value;
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
                        ),
                      ]),
                      TableRow(children: [
                        Text("Flag Name", style: headingStyle),
                        TypeAheadFormField<Flag>(
                            textFieldConfiguration: TextFieldConfiguration(
                              decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Flag Name",
                                hintStyle: Get.textTheme.bodySmall,
                                isDense: true,
                                constraints: const BoxConstraints(
                                    maxHeight: 32, maxWidth: 32),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Get.theme.primaryColor),
                                    borderRadius: BorderRadius.circular(64)),
                              ),
                              controller: controller.recordFlagName,
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
                                controller.recordFlagName.text =
                                    suggestion.flagCode ?? "";
                              },
                              suggestionsCallback: (String pattern) {
                                return Future.value(controller.flags?.where(
                                    (flag) =>
                                        flag.flagCode?.toLowerCase().startsWith(
                                            pattern.toLowerCase()) ==
                                        true));
                              },),
                      ]),
                      TableRow(children: [
                        Text("GRT", style: headingStyle),
                        CustomTextFormField(
                            controller: controller.recordGrt,
                            keyboardType: TextInputType.number,
                            hintText: "Enter GRT"),
                      ]),
                      TableRow(children: [
                        Text("Vessel Type", style: headingStyle),
                        DropdownButtonHideUnderline(
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
                                                style: Get.textTheme.titleSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                          ...?e.subVessels?.map((e) =>
                                              DropdownMenuItem<int>(
                                                  value: e.id,
                                                  child: Text(e.name ?? "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Get
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                              fontSize: 12))))
                                        ])
                                    .expand((element) => element)
                                    .toList() ??
                                [],

                            // .map((e) => DropdownMenuItem(
                            //     value: e.name,
                            //     child: Text(e.name ?? "",
                            //         style: Get.textTheme.titleMedium)))
                            // .toList(),
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
                                  border:
                                      Border.all(color: Get.theme.primaryColor),
                                )),
                          ),
                        ),
                      ]),
                      TableRow(
                        children: [
                          Text("Sign-On Date", style: headingStyle),
                          CustomTextFormField(
                              controller: controller.recordSignOnDate,
                              onTap: () async {
                                DateTime? selectedDateTime =
                                    await showDatePicker(
                                        context: Get.context!,
                                        initialDate:
                                            DateTime.parse("1990-01-01"),
                                        firstDate: DateTime.parse("1950-01-01"),
                                        lastDate: DateTime.parse("2050-01-01"));
                                controller.recordSignOnDate.text =
                                    selectedDateTime?.getServerDate() ?? "";
                                controller.calculateDuration();
                              },
                              icon: const Icon(
                                Icons.calendar_month,
                              ),
                              isDate: true,
                              hintText: "dd-mm-yyyy"),
                        ],
                      ),
                      TableRow(
                        children: [
                          Text("Sign-Off Date", style: headingStyle),
                          CustomTextFormField(
                            controller: controller.recordSignOffDate,
                            onTap: () async {
                              DateTime? selectedDateTime = await showDatePicker(
                                  context: Get.context!,
                                  initialDate: DateTime.parse("1990-01-01"),
                                  firstDate: DateTime.parse("1950-01-01"),
                                  lastDate: DateTime.parse("2050-01-01"));
                              controller.recordSignOffDate.text =
                                  selectedDateTime?.getServerDate() ?? "";
                              controller.calculateDuration();
                            },
                            isDate: true,
                            hintText: "dd-mm-yyyy",
                            icon: const Icon(
                              Icons.calendar_month,
                            ),
                          ),
                        ],
                      ),
                    ]
                        .map((e) => [
                              e,
                              TableRow(
                                  children: [16.verticalSpace, 0.verticalSpace])
                            ])
                        .expand((element) => element)
                        .toList(),
                  ),
                  if (controller.recordContractDuration.value != null) ...[
                    Row(
                      children: [
                        Expanded(
                            child:
                                Text("Contract Duration", style: headingStyle)),
                        24.horizontalSpace,
                        Expanded(
                            child: Text(
                                controller.recordContractDuration.value ?? ""))
                      ],
                    ),
                    24.verticalSpace,
                  ],
                  const Divider(thickness: 2),
                  16.verticalSpace,
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
                          ? const CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: () async {
                                if (await controller.addServiceRecord()) {
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
                  28.verticalSpace,
                  Get.mediaQuery.viewInsets.bottom.verticalSpace
                ],
              ),
            );
    });
  }
}
