import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/subscription_model.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/utils/remote_config.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';

import '../controllers/liked_jobs_controller.dart';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_cli/get_cli.dart';
import 'package:join_my_ship/app/data/models/job_model.dart';
import 'package:join_my_ship/app/data/models/ranks_model.dart';
import 'package:join_my_ship/app/data/models/vessel_list_model.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/widgets/circular_progress_indicator_widget.dart';
import 'package:join_my_ship/widgets/dropdown_decoration.dart';
import 'package:lottie/lottie.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:collection/collection.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class LikedJobsView extends GetView<LikedJobsController> {
  const LikedJobsView({Key? key}) : super(key: key);

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: false,
      builder: (context) => Obx(() {
        controller.toApplyRanks.value = [...controller.selectedRanks];
        controller.toApplyVesselTypes.value = [
          ...controller.selectedVesselTypes
        ];
        return Container(
          // height: 350,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 4,
                              width: 64,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade400,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            16.verticalSpace,
                            Text(
                              "Filter",
                              style: Get.textTheme.titleLarge
                                  ?.copyWith(fontSize: 22),
                            ),
                          ],
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Rank",
                            style: Get.textTheme.bodyLarge
                                ?.copyWith(color: Colors.blue, fontSize: 18),
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Rank>(
                              isExpanded: true,
                              style: Get.textTheme.bodySmall,
                              items: controller.ranks
                                      .map((e) => DropdownMenuItem<Rank>(
                                          value: e,
                                          child: Row(
                                            children: [
                                              Obx(() {
                                                return SizedBox(
                                                  height: 8,
                                                  width: 8,
                                                  child: Checkbox(
                                                      value: controller
                                                          .toApplyRanks
                                                          .contains(e.id),
                                                      onChanged: (_) {
                                                        if (e.id == null) {
                                                          return;
                                                        }
                                                        if (controller
                                                            .toApplyRanks
                                                            .contains(e.id)) {
                                                          controller
                                                              .toApplyRanks
                                                              .remove(e.id);
                                                        } else {
                                                          controller
                                                              .toApplyRanks
                                                              .add(e.id!);
                                                        }
                                                      }),
                                                );
                                              }),
                                              16.horizontalSpace,
                                              Flexible(
                                                child: Text(e.name ?? "",
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: Get
                                                        .textTheme.titleMedium),
                                              ),
                                            ],
                                          )))
                                      .toList() ??
                                  [],
                              onChanged: (value) {
                                if (value?.id == null) {
                                  return;
                                }
                                if (controller.toApplyRanks
                                    .contains(value!.id!)) {
                                  controller.toApplyRanks.remove(value.id);
                                } else {
                                  controller.toApplyRanks.add(value.id!);
                                }
                              },
                              hint: const Text("Select Rank"),
                              buttonStyleData: ButtonStyleData(
                                  height: 40,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: DropdownDecoration()),
                            ),
                          ),
                        )
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            "Vessel Type",
                            style: Get.textTheme.bodyLarge
                                ?.copyWith(color: Colors.blue, fontSize: 18),
                          ),
                        ),
                        8.horizontalSpace,
                        Expanded(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<int>(
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
                                            ...?e.subVessels
                                                ?.map(
                                                    (e) =>
                                                        DropdownMenuItem<int>(
                                                            value: e.id,
                                                            child: Row(
                                                              children: [
                                                                Obx(() {
                                                                  return SizedBox(
                                                                    height: 8,
                                                                    width: 8,
                                                                    child: Checkbox(
                                                                        value: controller.toApplyVesselTypes.contains(e.id),
                                                                        onChanged: (_) {
                                                                          if (e.id ==
                                                                              null) {
                                                                            return;
                                                                          }
                                                                          if (controller
                                                                              .toApplyVesselTypes
                                                                              .contains(e.id)) {
                                                                            controller.toApplyVesselTypes.remove(e.id);
                                                                          } else {
                                                                            controller.toApplyVesselTypes.add(e.id!);
                                                                          }
                                                                        }),
                                                                  );
                                                                }),
                                                                16.horizontalSpace,
                                                                Flexible(
                                                                  child: Text(
                                                                      e.name ??
                                                                          "",
                                                                      maxLines:
                                                                          1,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis,
                                                                      style: Get
                                                                          .textTheme
                                                                          .bodyMedium
                                                                          ?.copyWith(
                                                                              fontSize: 12)),
                                                                ),
                                                              ],
                                                            )))
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
                                if (value == null) {
                                  return;
                                }
                                if (controller.toApplyVesselTypes
                                    .contains(value)) {
                                  controller.toApplyVesselTypes.remove(value);
                                } else {
                                  controller.toApplyVesselTypes.add(value);
                                }
                              },
                              hint: const Text("Select Vessel"),
                              buttonStyleData: ButtonStyleData(
                                  height: 40,
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 8),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(64),
                                    border: Border.all(
                                        color: Get.theme.primaryColor),
                                  )),
                            ),
                          ),
                        ),
                      ],
                    ),
                    25.verticalSpace,
                  ],
                ),
              ),
              20.verticalSpace,
              const Divider(
                height: 1,
                color: Colors.black38,
              ),
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        side: const BorderSide(width: 1.5, color: Colors.blue),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                    15.horizontalSpace,
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        controller.selectedRanks.value = [
                          ...controller.toApplyRanks
                        ];
                        controller.selectedVesselTypes.value = [
                          ...controller.toApplyVesselTypes
                        ];
                        controller.applyFilters();
                        Get.back();
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
              16.verticalSpace
            ],
          ),
        );
      }),
    ).then((value) {
      debugPrint("ModalBottomSheet Closed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.parentKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Liked Jobs'),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const CircularProgressIndicatorWidget()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    controller.jobOpenings.isEmpty
                        ? Center(
                            child: Column(
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
                                  "No Liked Jobs Found!",
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
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
                                              child:
                                                  CircularProgressIndicator())
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
                            : Flexible(
                                child: RefreshIndicator(
                                  onRefresh: () async {
                                    controller.isLoading.value = true;
                                    await controller.loadJobOpenings();
                                    controller.isLoading.value = false;
                                  },
                                  child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    itemCount: controller.jobOpenings.length,
                                    itemBuilder: (context, index) => Obx(
                                      () {
                                        return controller.jobOpenings.isEmpty
                                            ? const Center(
                                                child: Text("No jobs posted"))
                                            : Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3),
                                                child: _buildCard(controller
                                                    .jobOpenings[index]));
                                      },
                                    ),
                                  ),
                                ),
                              ),
                  ],
                ),
              ),
      ),
    );
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
                                onPressed: job.employerDetails?.followStatus ==
                                        true
                                    ? null
                                    : () {
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
                      controller.likingJob.value == job.id
                          ? CircularProgressIndicator()
                          : TextButton.icon(
                              onPressed: () {
                                controller.likeJob(job.id);
                              },
                              icon: Icon(
                                job.isJobLiked == true
                                    ? Icons.thumb_up_alt_sharp
                                    : Icons.thumb_up_alt_outlined,
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
                                      if (UserStates
                                              .instance.crewUser?.isVerified !=
                                          1) {
                                        controller.fToast.safeShowToast(
                                            child: errorToast(RemoteConfigUtils
                                                .instance
                                                .accountUnderVerificationCopy));
                                        return;
                                      }
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
                                          shape: alertDialogShape,
                                          title: const Text(
                                            "Are You Sure ?",
                                            textAlign: TextAlign.center,
                                            style:
                                                TextStyle(color: Colors.blue),
                                          ),
                                          actionsPadding:
                                              const EdgeInsets.only(bottom: 25),
                                          content: Text(
                                            "Are you sure you want to use your ${UserStates.instance.subscription?.firstWhereOrNull((subscription) => subscription.isTypeKey?.type == PlanType.applyJob)?.points?.toString() ?? ""} credits?",
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
