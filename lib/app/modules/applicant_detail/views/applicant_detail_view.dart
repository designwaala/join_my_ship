import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';

import '../controllers/applicant_detail_controller.dart';

class ApplicantDetailView extends GetView<ApplicantDetailController> {
  const ApplicantDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Applicants'),
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
                                          content: CachedNetworkImage(
                                              imageUrl: controller
                                                      .applicant?.profilePic ??
                                                  ""),
                                          actions: [
                                            FilledButton(
                                                onPressed: Get.back,
                                                child: Text("Cancel")),
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
                            Table(
                              children: [
                                TableRow(children: [
                                  Text("Name",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              color: Get.theme.primaryColor)),
                                  Text(
                                    controller.applicant?.firstName ?? "",
                                    textAlign: TextAlign.end,
                                  )
                                ]),
                                TableRow(children: [
                                  Text("Rank",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              color: Get.theme.primaryColor)),
                                  Text(
                                    controller.ranks
                                            ?.firstWhereOrNull((rank) =>
                                                rank.id ==
                                                controller.applicant?.rankId)
                                            ?.name ??
                                        "",
                                    textAlign: TextAlign.end,
                                  )
                                ]),
                                TableRow(children: [
                                  Text("Looking for Promotion",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              color: Get.theme.primaryColor)),
                                  Text(
                                    controller.applicant?.promotionApplied ==
                                            true
                                        ? "YES"
                                        : "NO",
                                    textAlign: TextAlign.end,
                                  )
                                ]),
                                TableRow(children: [
                                  Text("Date of Birth",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              color: Get.theme.primaryColor)),
                                  Text(
                                    controller.applicant?.dob ?? "",
                                    textAlign: TextAlign.end,
                                  )
                                ]),
                                TableRow(children: [
                                  Text("Marital Status",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              color: Get.theme.primaryColor)),
                                  Text(
                                    genderMap[controller.applicant?.gender ??
                                            -1] ??
                                        "",
                                    textAlign: TextAlign.end,
                                  )
                                ]),
                                TableRow(children: [
                                  Text("Nationality",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              color: Get.theme.primaryColor)),
                                  Text(
                                    controller.countries
                                            ?.firstWhereOrNull((e) =>
                                                e.id ==
                                                controller.applicant?.country)
                                            ?.countryName ??
                                        "",
                                    textAlign: TextAlign.end,
                                  )
                                ]),
                                if (controller.applicantDetails
                                        ?.cdcIssuingAuthority !=
                                    null)
                                  TableRow(children: [
                                    Text("CDC",
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Get.theme.primaryColor)),
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
                                    )
                                  ]),
                                if (controller.applicantDetails
                                        ?.passportIssuingAuthority !=
                                    null)
                                  TableRow(children: [
                                    Text("Passport",
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Get.theme.primaryColor)),
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
                                    )
                                  ]),
                                if (controller
                                        .applicantDetails
                                        ?.validCOCIssuingAuthority
                                        ?.isNotEmpty ==
                                    true)
                                  TableRow(children: [
                                    Text("COC",
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Get.theme.primaryColor)),
                                    Text(
                                      controller.applicantDetails
                                              ?.validCOCIssuingAuthority
                                              ?.map((e) =>
                                                  e.issuingAuthority ??
                                                  e.customName)
                                              .join(", ") ??
                                          "",
                                      textAlign: TextAlign.end,
                                    )
                                  ]),
                                if (controller
                                        .applicantDetails
                                        ?.validCOPIssuingAuthority
                                        ?.isNotEmpty ==
                                    true)
                                  TableRow(children: [
                                    Text("COP",
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Get.theme.primaryColor)),
                                    Text(
                                      controller.applicantDetails
                                              ?.validCOPIssuingAuthority
                                              ?.map((e) =>
                                                  e.issuingAuthority ??
                                                  e.customName)
                                              .join(", ") ??
                                          "",
                                      textAlign: TextAlign.end,
                                    )
                                  ]),
                                if (controller
                                        .applicantDetails
                                        ?.validWatchKeepingIssuingAuthority
                                        ?.isNotEmpty ==
                                    true)
                                  TableRow(children: [
                                    Text("Watch Keeping",
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Get.theme.primaryColor)),
                                    Text(
                                      controller.applicantDetails
                                              ?.validWatchKeepingIssuingAuthority
                                              ?.map((e) =>
                                                  e.issuingAuthority ??
                                                  e.customName)
                                              .join(", ") ??
                                          "",
                                      textAlign: TextAlign.end,
                                    )
                                  ]),
                                if (controller.applicantDetails
                                        ?.sTCWIssuingAuthority?.isNotEmpty ==
                                    true)
                                  TableRow(children: [
                                    Text("STCW",
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Get.theme.primaryColor)),
                                    Text(
                                      controller.applicantDetails
                                              ?.sTCWIssuingAuthority
                                              ?.map((e) =>
                                                  e.issuingAuthority ??
                                                  e.customName)
                                              .join(", ") ??
                                          "",
                                      textAlign: TextAlign.end,
                                    )
                                  ]),
                              ]
                                  .map((e) => [
                                        e,
                                        TableRow(children: [
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
                            controller.isShortListing.value
                                ? CircularProgressIndicator()
                                : InkWell(
                                    onTap: controller.shortList,
                                    child: Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: Get.theme.primaryColor)),
                                      child: Image.asset(
                                        controller.application.value
                                                    ?.shortlistedStatus ==
                                                true
                                            ? 'assets/icons/bookmark_filled.png'
                                            : 'assets/icons/bookmark_outlined.png',
                                        height: 28,
                                        width: 28,
                                        color: Get.theme.primaryColor,
                                      ),
                                    ),
                                  ),
                            const Spacer(),
                            controller.isGettingResume.value
                                ? CircularProgressIndicator()
                                : InkWell(
                                    onTap: controller.downloadResume,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(64),
                                          gradient:
                                              const LinearGradient(colors: [
                                            Color(0xFF386BF6),
                                            Color(0xFF22D1EE),
                                          ])),
                                      child: Row(
                                        children: [
                                          Text("Download Resume",
                                              style: Get.textTheme.titleMedium
                                                  ?.copyWith(
                                                      color: Colors.white)),
                                          4.horizontalSpace,
                                          const Icon(
                                            Icons.download,
                                            color: Colors.white,
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.all(4),
                              child: Image.asset(
                                controller.application.value
                                            ?.shortlistedStatus ==
                                        true
                                    ? 'assets/icons/bookmark_filled.png'
                                    : 'assets/icons/bookmark_outlined.png',
                                height: 28,
                                width: 28,
                                color: Colors.transparent,
                              ),
                            ),
                          ],
                        ),
                      ),
                      32.verticalSpace,
                    ],
                  ),
                );
        }));
  }
}
