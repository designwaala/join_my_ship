import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/utils/extensions/date_time.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';

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
                CircularProgressIndicator(),
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
                      hintText: "Company Name"),
                  16.verticalSpace,
                  Text("Ship Name", style: headingStyle),
                  16.verticalSpace,
                  CustomTextFormField(
                      controller: controller.recordShipName,
                      hintText: "Ship Name"),
                  20.verticalSpace,
                  Table(
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
                        CustomTextFormField(
                            controller: controller.recordFlagName,
                            hintText: "Flag Name"),
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
                      ])
                    ]
                        .map((e) => [
                              e,
                              TableRow(
                                  children: [16.verticalSpace, 0.verticalSpace])
                            ])
                        .expand((element) => element)
                        .toList(),
                  ),
                  Row(
                    children: [
                      Text("Sign-On Date", style: headingStyle),
                      Spacer(),
                      SizedBox(
                        width: 146.w,
                        child: CustomTextFormField(
                            controller: controller.recordSignOnDate,
                            onTap: () async {
                              DateTime? selectedDateTime = await showDatePicker(
                                  context: Get.context!,
                                  initialDate: DateTime.parse("1990-01-01"),
                                  firstDate: DateTime.parse("1990-01-01"),
                                  lastDate: DateTime.now());

                              controller.recordSignOnDate.text =
                                  selectedDateTime?.getServerDate() ?? "";
                            },
                            icon: Icon(
                              Icons.calendar_month,
                            ),
                            readOnly: true,
                            hintText: "yyyy/mm/dd"),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Text("Sign-Off Date", style: headingStyle),
                      Spacer(),
                      SizedBox(
                        width: 146.w,
                        child: CustomTextFormField(
                          controller: controller.recordSignOffDate,
                          onTap: () async {
                            DateTime? selectedDateTime = await showDatePicker(
                                context: Get.context!,
                                initialDate: DateTime.parse("1990-01-01"),
                                firstDate: DateTime.parse("1990-01-01"),
                                lastDate: DateTime.now());
                            controller.recordSignOffDate.text =
                                selectedDateTime?.getServerDate() ?? "";
                          },
                          readOnly: true,
                          hintText: "yyyy/mm/dd",
                          icon: const Icon(
                            Icons.calendar_month,
                          ),
                        ),
                      ),
                    ],
                  ),
                  16.verticalSpace,
                  Row(
                    children: [
                      Text("Contract Duration", style: headingStyle),
                      Spacer(),
                      SizedBox(
                        width: 146.w,
                        child: CustomTextFormField(
                            controller: controller.recordContarctDuration,
                            keyboardType: TextInputType.number,
                            hintText: "In Years"),
                      ),
                    ],
                  ),
                  24.verticalSpace,
                  Divider(thickness: 2),
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
                          ? CircularProgressIndicator()
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
                  28.verticalSpace
                ],
              ),
            );
    });
  }
}
