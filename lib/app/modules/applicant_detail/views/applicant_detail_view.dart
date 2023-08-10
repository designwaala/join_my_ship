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
            foregroundColor: const Color(0xFF000000),
            toolbarHeight: 70,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text('Applicants',
                style: Get.theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Color(0xFFF3F3F3), shape: BoxShape.circle),
                child: const Icon(
                  Icons.keyboard_backspace_rounded,
                  color: Colors.black,
                ),
              ),
            )),
        body: Obx(() {
          return controller.isLoading.value
              ? Center(
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
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Get.theme.primaryColor),
                                  shape: BoxShape.circle),
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(128),
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        controller.applicant?.profilePic ?? "",
                                    height: 100,
                                    width: 100,
                                  )),
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
                      Row(
                        children: [
                          Image.asset(
                            controller.args?.application?.applicationStatus ==
                                    ApplicationStatus.SHORT_LISTED
                                ? 'assets/icons/bookmark_filled.png'
                                : 'assets/icons/bookmark_outlined.png',
                            height: 28,
                            width: 28,
                          )
                        ],
                      )
                    ],
                  ),
                );
        }));
  }
}
