import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/main.dart';

import '../controllers/crew_detail_controller.dart';

class CrewDetailView extends GetView<CrewDetailController> {
  const CrewDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Crew Detail"),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Center(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          children: [
                            36.verticalSpace,
                            InkWell(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                          shape: alertDialogShape,
                                          content: CachedNetworkImage(
                                              imageUrl:
                                                  controller.crew?.profilePic ??
                                                      ""),
                                          actions: [
                                            FilledButton(
                                                onPressed: Get.back,
                                                child: const Text("Cancel")),
                                            8.horizontalSpace
                                          ],
                                        ));
                              },
                              child: CachedNetworkImage(
                                imageUrl: controller.crew?.profilePic ?? "",
                                height: 120,
                                width: 120,
                                imageBuilder: (context, imageProvider) =>
                                    Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Get.theme.primaryColor),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover))),
                                ),
                              ),
                            ),
                            8.verticalSpace,
                            Center(
                              child: Text("Tap to view",
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                      color: Get.theme.primaryColor)),
                            ),
                            32.verticalSpace,
                            Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Name",
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.w600)),
                                      Text(controller.crew?.firstName ?? "",
                                          textAlign: TextAlign.end,
                                          style: Get.textTheme.titleMedium)
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Rank",
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.w600)),
                                      Text(
                                          controller.ranks
                                                  ?.firstWhereOrNull((rank) =>
                                                      rank.id ==
                                                      controller.crew?.rankId)
                                                  ?.name ??
                                              "",
                                          textAlign: TextAlign.end,
                                          style: Get.textTheme.titleMedium)
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Looking for Promotion",
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.w600)),
                                      Text(
                                          controller.crew?.promotionApplied ==
                                                  true
                                              ? "YES"
                                              : "NO",
                                          textAlign: TextAlign.end,
                                          style: Get.textTheme.titleMedium)
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Date of Birth",
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.w600)),
                                      Text(controller.crew?.dob ?? "",
                                          textAlign: TextAlign.end,
                                          style: Get.textTheme.titleMedium)
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Gender",
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.w600)),
                                      Text(
                                          genderMap[controller.crew?.gender ??
                                                  -1] ??
                                              "",
                                          textAlign: TextAlign.end,
                                          style: Get.textTheme.titleMedium)
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Marital Status",
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.w600)),
                                      Text(
                                          maritalStatuses[controller
                                                      .crew?.maritalStatus ??
                                                  -1] ??
                                              "",
                                          textAlign: TextAlign.end,
                                          style: Get.textTheme.titleMedium)
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Nationality",
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.w600)),
                                      Text(
                                          controller.countries
                                                  ?.firstWhereOrNull((e) =>
                                                      e.id ==
                                                      controller
                                                          .crew?.countryId)
                                                  ?.countryName ??
                                              "",
                                          textAlign: TextAlign.end,
                                          style: Get.textTheme.titleMedium)
                                    ]),
                                if (controller
                                        .crewDetail?.cdcIssuingAuthority !=
                                    null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("CDC",
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        Text(
                                            controller
                                                    .crewDetail
                                                    ?.cdcIssuingAuthority
                                                    ?.customName ??
                                                controller
                                                    .crewDetail
                                                    ?.cdcIssuingAuthority
                                                    ?.issuingAuthority ??
                                                "",
                                            textAlign: TextAlign.end,
                                            style: Get.textTheme.titleMedium)
                                      ]),
                                if (controller
                                        .crewDetail?.passportIssuingAuthority !=
                                    null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Passport",
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        Text(
                                            controller
                                                    .crewDetail
                                                    ?.passportIssuingAuthority
                                                    ?.customName ??
                                                controller
                                                    .crewDetail
                                                    ?.passportIssuingAuthority
                                                    ?.issuingAuthority ??
                                                "",
                                            textAlign: TextAlign.end,
                                            style: Get.textTheme.titleMedium)
                                      ]),
                                if (controller
                                        .crewDetail
                                        ?.validCOCIssuingAuthority
                                        ?.isNotEmpty ==
                                    true)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("COC",
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        Text(
                                            controller.crewDetail
                                                    ?.validCOCIssuingAuthority
                                                    ?.map((e) =>
                                                        e.issuingAuthority ??
                                                        e.customName)
                                                    .join(", ") ??
                                                "",
                                            textAlign: TextAlign.end,
                                            style: Get.textTheme.titleMedium)
                                      ]),
                                if (controller
                                        .crewDetail
                                        ?.validCOPIssuingAuthority
                                        ?.isNotEmpty ==
                                    true)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("COP",
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        Text(
                                            controller.crewDetail
                                                    ?.validCOPIssuingAuthority
                                                    ?.map((e) =>
                                                        e.issuingAuthority ??
                                                        e.customName)
                                                    .join(", ") ??
                                                "",
                                            textAlign: TextAlign.end,
                                            style: Get.textTheme.titleMedium)
                                      ]),
                                if (controller
                                        .crewDetail
                                        ?.validWatchKeepingIssuingAuthority
                                        ?.isNotEmpty ==
                                    true)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Watch Keeping",
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        Text(
                                            controller.crewDetail
                                                    ?.validWatchKeepingIssuingAuthority
                                                    ?.map((e) =>
                                                        e.issuingAuthority ??
                                                        e.customName)
                                                    .join(", ") ??
                                                "",
                                            textAlign: TextAlign.end,
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600))
                                      ]),
                                if (controller.crewDetail?.sTCWIssuingAuthority
                                        ?.isNotEmpty ==
                                    true)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("STCW",
                                            style: Get.textTheme.titleMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                        Text(
                                            controller.crewDetail
                                                    ?.sTCWIssuingAuthority
                                                    ?.map((e) =>
                                                        e.issuingAuthority ??
                                                        e.customName)
                                                    .join(", ") ??
                                                "",
                                            textAlign: TextAlign.end,
                                            style: Get.textTheme.titleMedium)
                                      ]),
                              ]
                                  .map((e) => [
                                        e,
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              8.verticalSpace,
                                              0.verticalSpace
                                            ])
                                      ])
                                  .expand((element) => element)
                                  .toList(),
                            )
                          ],
                        ),
                      ),
                      24.verticalSpace,
                    ],
                  ),
                );
        }));
  }
}
