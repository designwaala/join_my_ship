import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_cli/get_cli.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:lottie/lottie.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../controllers/company_detail_controller.dart';
import 'package:collection/collection.dart';

class CompanyDetailView extends GetView<CompanyDetailController> {
  const CompanyDetailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          key: controller.parentKey,
          body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, innerScrolled) => <Widget>[
                    SliverAppBar(
                      pinned: true,
                      title: const Text('Company Detail'),
                      centerTitle: true,
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                    ),
                    SliverAppBar(
                        toolbarHeight: 128,
                        expandedHeight: 128,
                        floating: true,
                        leading: const SizedBox(),
                        // title: const Text('Company Detail'),
                        // centerTitle: true,
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        flexibleSpace: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 16),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 5),
                              child: Row(
                                children: [
                                  Container(
                                    height: 50.h,
                                    width: 50.h,
                                    decoration: BoxDecoration(
                                        color:
                                            Color(Random().nextInt(0xffffffff))
                                                .withAlpha(0xff),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Center(
                                        child: Text(
                                            controller.employer?.companyName
                                                    ?.split("")
                                                    .firstOrNull ??
                                                "",
                                            style: const TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white))),
                                  ),
                                  20.horizontalSpace,
                                  Expanded(
                                    child: Text(
                                        controller.employer?.companyName ?? "",
                                        maxLines: 2,
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold)),
                                  ),
                                  Icon(Icons.verified_user,
                                      color: Get.theme.primaryColor)
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                64.horizontalSpace,
                                Icon(Icons.location_on),
                                8.horizontalSpace,
                                Text(UserStates.instance.countries
                                        ?.firstWhereOrNull((country) =>
                                            country.id ==
                                            controller.employer?.country)
                                        ?.countryName ??
                                    "")
                              ],
                            ),
                            32.verticalSpace
                          ],
                        ))
                  ],
              body: controller.isLoading.value
                  ? Center(child: CircularProgressIndicator())
                  : controller.jobs.isEmpty
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 300,
                              width: 300,
                              child: Lottie.asset(
                                'assets/animations/no_results.json',
                                repeat: false,
                              ),
                            ),
                            10.verticalSpace,
                            const Text(
                              "No Results Found!",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      : controller.buildCaptureWidget.value
                          ? Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Column(
                                children: [
                                  const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Please Wait"),
                                        SizedBox(
                                            height: 16,
                                            width: 16,
                                            child: CircularProgressIndicator())
                                      ],
                                    ),
                                  ),
                                  8.verticalSpace,
                                  WidgetsToImage(
                                      controller:
                                          controller.widgetsToImageController,
                                      child: Column(
                                        children: [
                                          _buildCard(controller.jobToBuild!,
                                              shareView: true),
                                        ],
                                      )),
                                ],
                              ),
                            )
                          : ListView.builder(
                              padding: const EdgeInsets.only(top: 16),
                              scrollDirection: Axis.vertical,
                              itemCount: controller.jobs.length,
                              itemBuilder: (context, index) => Obx(
                                () {
                                  return controller.jobs.isEmpty
                                      ? const Center(
                                          child: Text("No jobs posted"))
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: _buildCard(
                                              controller.jobs[index]));
                                },
                              ),
                            )));
    });
  }

  _buildCard(Job job, {bool shareView = false}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(128),
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl: job.employerDetails?.profilePic ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
                10.horizontalSpace,
                Flexible(
                  flex: 15,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${!controller.isReferredJob.value ? "Job By: " : ""}${job.employerDetails?.firstName ?? ""} ${job.employerDetails?.lastName ?? ""}",
                        overflow: TextOverflow.ellipsis,
                        style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                          controller.isReferredJob.value
                              ? "Referred job"
                              : job.employerDetails?.companyName ?? "",
                          overflow: TextOverflow.ellipsis,
                          // "Westline Ship Management Pvt. Ltd.",
                          style: Get.textTheme.bodySmall?.copyWith(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    UserStates.instance.crewUser?.userTypeKey == 2
                        ? controller.followingJob.value == job.id
                            ? const CircularProgressIndicator()
                            : FilledButton.icon(
                                onPressed: () {
                                  controller.followJob(
                                      job.employerDetails?.id, job.id);
                                },
                                icon: const Icon(
                                  Icons.add,
                                  size: 20,
                                ),
                                label: const Text("Follow"),
                                style: FilledButton.styleFrom(
                                    minimumSize: Size.zero,
                                    padding: EdgeInsets.fromLTRB(4, 4, 8, 4),
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    foregroundColor: Colors.white,
                                    backgroundColor: Get.theme.primaryColor,
                                    shape: const StadiumBorder()),
                              )
                        : const SizedBox()
                  ],
                ),
                8.verticalSpace,
                Column(
                  children: [
                    Row(
                      children: [
                        Text("Tentative Joining Date: ",
                            style: Get.textTheme.bodyLarge),
                        Text(
                          job.tentativeJoining!,
                          style:
                              Get.textTheme.bodyMedium?.copyWith(fontSize: 14),
                        )
                      ],
                    ),
                    // Flexible(
                    //   child:
                    //       RichText(
                    //     maxLines: 2,
                    //     text:
                    //         TextSpan(
                    //       children: [
                    //         TextSpan(
                    //             text:
                    //                 "Vessel Type: ",
                    //             style:
                    //                 Get.textTheme.bodyLarge),
                    //         TextSpan(
                    //             text:
                    //                 controller.vesselList?.vessels?.map((e) => e.subVessels ?? []).expand((e) => e).firstWhereOrNull((e) => e.id == job.vesselId)?.name ?? ""),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    Row(
                      children: [
                        Flexible(
                          child: Text("Vessel Type: ",
                              maxLines: 2, style: Get.textTheme.bodyLarge),
                        ),
                        Text(controller.vesselList?.vessels
                                ?.map((e) => e.subVessels ?? [])
                                .expand((e) => e)
                                .firstWhereOrNull((e) => e.id == job.vesselId)
                                ?.name ??
                            ""),
                      ],
                    ),
                    Row(
                      children: [
                        Text("GRT: ", style: Get.textTheme.bodyLarge),
                        Text(job.gRT.toString())
                      ],
                    ),
                  ],
                ),

                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: job.jobRankWithWages
                              ?.map((rankWithWages) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        UserStates.instance.crewUser?.rankId ==
                                                    rankWithWages.rankNumber ||
                                                (UserStates.instance.crewUser
                                                            ?.promotionApplied ==
                                                        true &&
                                                    controller.ranks
                                                            .firstWhereOrNull(
                                                                (rank) =>
                                                                    UserStates
                                                                        .instance
                                                                        .crewUser
                                                                        ?.rankId ==
                                                                    rank.id)
                                                            ?.promotedTo ==
                                                        rankWithWages
                                                            .rankNumber)
                                            ? SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: Radio<int?>(
                                                    value: job.id ==
                                                            controller
                                                                .selectedRank
                                                                .value
                                                                ?.key
                                                        ? controller
                                                            .selectedRank
                                                            .value
                                                            ?.value
                                                        : null,
                                                    groupValue: rankWithWages
                                                        .rankNumber,
                                                    onChanged: (_) {
                                                      print(controller
                                                          .selectedRank);
                                                      controller.selectedRank
                                                              .value =
                                                          MapEntry(
                                                              job.id ?? -1,
                                                              rankWithWages
                                                                      .rankNumber ??
                                                                  -1);
                                                    }))
                                            : const Icon(
                                                Icons.radio_button_checked,
                                                color: Color.fromARGB(
                                                    255, 169, 168, 170),
                                                size: 20,
                                              ),
                                        10.horizontalSpace,
                                        Flexible(
                                          child: Text(
                                            "${controller.ranks.firstWhereOrNull((rank) => rank.id == rankWithWages.rankNumber)?.name ?? ""} - ${rankWithWages.wages} USD",
                                            style:
                                                const TextStyle(fontSize: 15),
                                            maxLines: 2,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ))
                              .toList() ??
                          []),
                ),
                if (controller.selectedRank.value?.key != job.id &&
                    controller.showErrorForJob.value == job.id)
                  Text("Please select atleast one rank",
                      style: Get.textTheme.bodySmall
                          ?.copyWith(color: Get.theme.colorScheme.error)),
                if (job.jobCoc != null && job.jobCoc?.isNotEmpty == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COC Requirements: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(job.jobCoc
                              ?.map(
                                (e) =>
                                    "${controller.cocs.firstWhereOrNull((coc) => coc.id == e.cocId)?.name ?? ""} |",
                              )
                              .toString()
                              .removeAll("(")
                              .removeAll(",")
                              .removeAll(" |)") ??
                          ""),
                    ],
                  ),
                if (job.jobCop != null && job.jobCop?.isNotEmpty == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COP Requirements: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(job.jobCop
                              ?.map(
                                (e) =>
                                    "${controller.cops.firstWhereOrNull((cop) => cop.id == e.copId)?.name ?? ""} |",
                              )
                              .toString()
                              .removeAll("(")
                              .removeAll(",")
                              .removeAll(" |)") ??
                          ""),
                    ],
                  ),
                if (job.jobWatchKeeping != null &&
                    job.jobWatchKeeping?.isNotEmpty == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Watch-Keeping Requirements: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(job.jobWatchKeeping
                              ?.map(
                                (e) =>
                                    "${controller.watchKeepings.firstWhereOrNull((watchKeeping) => watchKeeping.id == e.watchKeepingId)?.name ?? ""} |",
                              )
                              .toString()
                              .removeAll("(")
                              .removeAll(",")
                              .removeAll(" |)") ??
                          ""),
                    ],
                  ),
                if (job.mailInfo == true)
                  Row(
                    children: [
                      Text(
                        "Email: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        job.employerDetails?.email ?? "",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                if (job.numberInfo == true)
                  Row(
                    children: [
                      Text(
                        "Mobile: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        job.employerDetails?.number ?? "",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                4.verticalSpace,
                //TODO: Waiting for Prince
                /* Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      17.horizontalSpace,
                                                      TextButton.icon(
                                                          onPressed: () {},
                                                          icon: const Icon(
                                                            Icons.thumb_up,
                                                            size: 18,
                                                            color: Colors.blue,
                                                          ),
                                                          style: TextButton.styleFrom(
                                                            splashFactory:
                                                                NoSplash.splashFactory,
                                                            padding: const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10),
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius.circular(
                                                                        15),
                                                                side: const BorderSide(
                                                                    width: 1.8,
                                                                    color: Colors.blue)),
                                                          ),
                                                          label: Text(
                                                            " Likes ${job.likes}",
                                                            style: Get
                                                                .textTheme.bodyMedium
                                                                ?.copyWith(
                                                                    color: Colors.blue),
                                                          )),
                                                    ],
                                                  ), */
                10.verticalSpace,
                if (!shareView)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton.icon(
                          onPressed: () {
                            // TODO: Like
                          },
                          icon: const Icon(
                            Icons.thumb_up_alt_outlined,
                            size: 18,
                          ),
                          label: const Text(
                            "Like",
                            style: TextStyle(fontSize: 13),
                          )),
                      controller.applyingJob.value == job.id
                          ? const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [CircularProgressIndicator()],
                            )
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18))),
                              onPressed: controller.applications.any(
                                              (application) =>
                                                  application.jobId == job.id ||
                                                  application.jobData?.id ==
                                                      job.id) ==
                                          true ||
                                      job.jobRankWithWages?.none(
                                              (rankWithWage) =>
                                                  rankWithWage.rankNumber ==
                                                      UserStates.instance.crewUser
                                                          ?.rankId ||
                                                  (rankWithWage.rankNumber ==
                                                      controller.ranks
                                                          .firstWhereOrNull(
                                                              (rank) =>
                                                                  rank.id ==
                                                                  UserStates
                                                                      .instance
                                                                      .crewUser
                                                                      ?.rankId)
                                                          ?.promotedTo)) ==
                                          true ||
                                      UserStates
                                              .instance.crewUser?.userTypeKey !=
                                          2
                                  ? null
                                  : () {
                                      if (controller.selectedRank.value?.key !=
                                          job.id) {
                                        controller.showErrorForJob.value =
                                            job.id;
                                        return;
                                      }
                                      showDialog(
                                        context: Get.context!,
                                        barrierDismissible: false,
                                        builder: (context) => AlertDialog(
                                          title: const Text(
                                            "Are You Sure ?",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          actionsPadding:
                                              const EdgeInsets.only(bottom: 25),
                                          content: const Text(
                                            "Are you sure you want to use your 100 credits?",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          actionsAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          actions: [
                                            ElevatedButton(
                                              onPressed: Get.back,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.white,
                                                foregroundColor: Colors.black,
                                                elevation: 3,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 35),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: const Text("NO"),
                                            ),
                                            ElevatedButton(
                                              onPressed: () async {
                                                Get.back();
                                                controller.apply(job.id);
                                              },
                                              style: ElevatedButton.styleFrom(
                                                elevation: 3,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 35),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                              ),
                                              child: const Text("YES"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                              child: Text(
                                controller.applications.any((application) =>
                                            application.jobId == job.id ||
                                            application.jobData?.id ==
                                                job.id) ==
                                        true
                                    ? "APPLIED"
                                    : "APPLY NOW",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ),
                      TextButton.icon(
                        onPressed: () {
                          controller.captureWidget(job);
                        },
                        icon: const Icon(
                          Icons.share_sharp,
                          size: 18,
                          color: Colors.black,
                        ),
                        label: const Text(
                          "Share",
                          style: TextStyle(fontSize: 13, color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                5.verticalSpace,
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Send an application for 100 credits",
                      style: Get.textTheme.bodySmall?.copyWith(fontSize: 10),
                    ),
                  ],
                ),
                18.verticalSpace,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
