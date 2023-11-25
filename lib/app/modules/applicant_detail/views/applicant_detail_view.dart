import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_cli/common/utils/json_serialize/json_ast/utils/grapheme_splitter.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/main.dart';

import '../controllers/applicant_detail_controller.dart';

class ApplicantDetailView extends GetView<ApplicantDetailController> {
  const ApplicantDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        appBar: AppBar(
          title: Text(controller.args?.viewType == ViewType.crewDetail
              ? "Crew"
              : 'Applicants'),
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
                                              imageUrl: controller
                                                      .applicant?.profilePic ??
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
                                imageUrl:
                                    controller.applicant?.profilePic ?? "",
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
                                      Text(
                                          controller.applicant?.firstName ?? "",
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
                                                      controller
                                                          .applicant?.rankId)
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
                                          controller.applicant
                                                      ?.promotionApplied ==
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
                                      Text(controller.applicant?.dob ?? "",
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
                                          genderMap[controller
                                                      .applicant?.gender ??
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
                                          maritalStatuses[controller.applicant
                                                      ?.maritalStatus ??
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
                                                          .applicant?.countryId)
                                                  ?.countryName ??
                                              "",
                                          textAlign: TextAlign.end,
                                          style: Get.textTheme.titleMedium)
                                    ]),
                                if (controller.applicantDetails
                                        ?.cdcIssuingAuthority !=
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
                                                    .applicantDetails
                                                    ?.cdcIssuingAuthority
                                                    ?.customName ??
                                                controller
                                                    .applicantDetails
                                                    ?.cdcIssuingAuthority
                                                    ?.issuingAuthority ??
                                                "",
                                            textAlign: TextAlign.end,
                                            style: Get.textTheme.titleMedium)
                                      ]),
                                if (controller.applicantDetails
                                        ?.passportIssuingAuthority !=
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
                                                    .applicantDetails
                                                    ?.passportIssuingAuthority
                                                    ?.customName ??
                                                controller
                                                    .applicantDetails
                                                    ?.passportIssuingAuthority
                                                    ?.issuingAuthority ??
                                                "",
                                            textAlign: TextAlign.end,
                                            style: Get.textTheme.titleMedium)
                                      ]),
                                if (controller
                                        .applicantDetails
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
                                            controller.applicantDetails
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
                                        .applicantDetails
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
                                            controller.applicantDetails
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
                                        .applicantDetails
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
                                            controller.applicantDetails
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
                                if (controller.applicantDetails
                                        ?.sTCWIssuingAuthority?.isNotEmpty ==
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
                                            controller.applicantDetails
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
                      16.verticalSpace,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            if (controller.args?.viewType !=
                                ViewType.crewDetail)
                              controller.isShortListing.value
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator())
                                  : OutlinedButton(
                                      style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Get.theme.primaryColor,
                                          ),
                                          foregroundColor:
                                              Get.theme.primaryColor,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                width: 5.0,
                                                color: Colors.blue,
                                                style: BorderStyle.solid,
                                              ),
                                              borderRadius:
                                                  BorderRadius.circular(64))),
                                      onPressed: controller.shortList,
                                      child: Row(
                                        children: [
                                          const Icon(Icons.bookmark_outline),
                                          4.horizontalSpace,
                                          const Text("Shortlist")
                                        ],
                                      )),
                            const Spacer(),
                            controller.isFollowing.value
                                ? const SizedBox(
                                    height: 16,
                                    width: 16,
                                    child: CircularProgressIndicator(),
                                  )
                                : OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                        side: BorderSide(
                                          color: Get.theme.primaryColor,
                                        ),
                                        foregroundColor: Get.theme.primaryColor,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(64))),
                                    onPressed: controller.follow,
                                    child: Row(
                                      children: [
                                        const Icon(Icons.favorite_outline),
                                        4.horizontalSpace,
                                        const Text("Save Profile")
                                      ],
                                    ))
                          ],
                        ),
                      ),
                      24.verticalSpace,
                      controller.isGettingResume.value
                          ? const CircularProgressIndicator()
                          : Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 24),
                              child: FilledButton(
                                  onPressed: controller.downloadResume,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.download),
                                      4.horizontalSpace,
                                      const Text("Download Resume")
                                    ],
                                  )),
                            ),
                      24.verticalSpace,
                    ],
                  ),
                );
        }));
  }
}
