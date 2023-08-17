import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_cli/get_cli.dart';
import 'package:join_mp_ship/app/modules/employer_job_applications/controllers/employer_job_applications_controller.dart';
import 'package:join_mp_ship/app/modules/employer_job_posts/controllers/employer_job_posts_controller.dart';
import 'package:join_mp_ship/app/modules/job_post/controllers/job_post_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator_widget.dart';

class EmployerJobPostsView extends GetView<EmployerJobPostsController> {
  const EmployerJobPostsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('My Jobs'),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const CircularProgressIndicatorWidget()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: controller.jobPosts.length,
                  itemBuilder: (context, index) => Obx(() {
                    return controller.jobPosts.isEmpty
                        ? const Center(child: Text("No jobs posted"))
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 15),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(128),
                                          child: CachedNetworkImage(
                                              height: 50,
                                              width: 50,
                                              imageUrl: controller
                                                      .jobPosts[index]
                                                      .employerDetails
                                                      ?.profilePic ??
                                                  ""),
                                        ),
                                        10.horizontalSpace,
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${controller.jobPosts[index].employerDetails?.firstName ?? ""} ${controller.jobPosts[index].employerDetails?.lastName ?? ""}",
                                                overflow: TextOverflow.ellipsis,
                                                style: Get.textTheme.bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                              ),
                                              Text(
                                                  controller
                                                          .jobPosts[index]
                                                          .employerDetails
                                                          ?.companyName ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  // "Westline Ship Management Pvt. Ltd.",
                                                  style: Get.textTheme.bodySmall
                                                      ?.copyWith(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        // const Spacer(),
                                        controller.jobIdBeingDeleted.value ==
                                                controller.jobPosts[index].id
                                            ? const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator())
                                            : PopupMenuButton<int>(
                                                onSelected: (value) {
                                                  switch (value) {
                                                    case 1:
                                                      Get.offNamed(
                                                          Routes.JOB_POST,
                                                          arguments: JobPostArguments(
                                                              jobToEdit: controller
                                                                      .jobPosts[
                                                                  index]));
                                                      return;
                                                    case 2:
                                                      return;
                                                    case 3:
                                                      controller.deleteJobPost(
                                                          controller
                                                                  .jobPosts[
                                                                      index]
                                                                  .id ??
                                                              -1);
                                                      return;
                                                  }
                                                },
                                                itemBuilder: (context) => [
                                                  const PopupMenuItem(
                                                    value: 1,
                                                    child: Text("Edit"),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: 2,
                                                    child: Text("Share"),
                                                  ),
                                                  const PopupMenuItem(
                                                    value: 3,
                                                    child: Text(
                                                      "Delete",
                                                      style: TextStyle(
                                                          color: Colors.red),
                                                    ),
                                                  ),
                                                ],
                                                onOpened: () {},
                                              ),
                                        16.horizontalSpace,
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("Tentative Joining Date: ",
                                                style: Get.textTheme.bodyLarge),
                                            Text(
                                              controller.jobPosts[index]
                                                  .tentativeJoining!,
                                              style: Get.textTheme.bodyMedium
                                                  ?.copyWith(fontSize: 14),
                                            )
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("Vessel Type: ",
                                                style: Get.textTheme.bodyLarge),
                                            Text(controller.vesselList?.vessels
                                                    ?.map((e) =>
                                                        e.subVessels ?? [])
                                                    .expand((e) => e)
                                                    .firstWhereOrNull((e) =>
                                                        e.id ==
                                                        controller
                                                            .jobPosts[index]
                                                            .vesselId)
                                                    ?.name ??
                                                ""),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text("GRT: ",
                                                style: Get.textTheme.bodyLarge),
                                            Text(controller.jobPosts[index].gRT
                                                .toString())
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children:
                                                  controller.jobPosts[index]
                                                          .jobRankWithWages
                                                          ?.map(
                                                              (rankWithWages) =>
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        vertical:
                                                                            3),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        const Icon(
                                                                          Icons
                                                                              .radio_button_checked,
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              169,
                                                                              168,
                                                                              170),
                                                                          size:
                                                                              20,
                                                                        ),
                                                                        10.horizontalSpace,
                                                                        Text(
                                                                          controller.ranks.firstWhereOrNull((rank) => rank.id == rankWithWages.rankNumber)?.name ??
                                                                              "",
                                                                          style:
                                                                              const TextStyle(fontSize: 15),
                                                                        ),
                                                                        Text(
                                                                            " - ${rankWithWages.wages} USD")
                                                                      ],
                                                                    ),
                                                                  ))
                                                          .toList() ??
                                                      []),
                                        ),
                                        if (controller.jobPosts[index].jobCoc !=
                                                null &&
                                            controller.jobPosts[index].jobCoc
                                                    ?.isNotEmpty ==
                                                true)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "COC Requirements: ",
                                                style: Get.textTheme.bodyLarge,
                                              ),
                                              Text(controller
                                                      .jobPosts[index].jobCoc
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
                                        if (controller.jobPosts[index].jobCop !=
                                                null &&
                                            controller.jobPosts[index].jobCop
                                                    ?.isNotEmpty ==
                                                true)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "COP Requirements: ",
                                                style: Get.textTheme.bodyLarge,
                                              ),
                                              Text(controller
                                                      .jobPosts[index].jobCop
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
                                        if (controller.jobPosts[index]
                                                    .jobWatchKeeping !=
                                                null &&
                                            controller
                                                    .jobPosts[index]
                                                    .jobWatchKeeping
                                                    ?.isNotEmpty ==
                                                true)
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Watch-Keeping Requirements: ",
                                                style: Get.textTheme.bodyLarge,
                                              ),
                                              Text(controller.jobPosts[index]
                                                      .jobWatchKeeping
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
                                        if (controller
                                                .jobPosts[index].mailInfo ==
                                            true)
                                          Row(
                                            children: [
                                              Text(
                                                "Email: ",
                                                style: Get.textTheme.bodyLarge,
                                              ),
                                              Text(
                                                controller
                                                        .jobPosts[index]
                                                        .employerDetails
                                                        ?.email ??
                                                    "",
                                                style: const TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ],
                                          ),
                                        if (controller
                                                .jobPosts[index].numberInfo ==
                                            true)
                                          Row(
                                            children: [
                                              Text(
                                                "Mobile: ",
                                                style: Get.textTheme.bodyLarge,
                                              ),
                                              Text(
                                                controller
                                                        .jobPosts[index]
                                                        .employerDetails
                                                        ?.number ??
                                                    "",
                                                style: const TextStyle(
                                                    fontSize: 13),
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
                                                    " Likes ${controller.jobPosts[index].likes}",
                                                    style: Get
                                                        .textTheme.bodyMedium
                                                        ?.copyWith(
                                                            color: Colors.blue),
                                                  )),
                                            ],
                                          ), */
                                        5.verticalSpace,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton.icon(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.send,
                                                size: 18,
                                              ),
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero),
                                              label: const Text(
                                                "Highlight",
                                                style: TextStyle(fontSize: 13),
                                              ),
                                            ),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 10),
                                                    shape: RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(20))),
                                                onPressed: () => Get.toNamed(
                                                    Routes
                                                        .EMPLOYER_JOB_APPLICATIONS,
                                                    arguments:
                                                        EmployerJobApplicationsArguments(
                                                            jobId: controller
                                                                .jobPosts[index]
                                                                .id)),
                                                child: const Text(
                                                  "Applications",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                )),
                                            TextButton.icon(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.diamond_outlined,
                                                size: 22,
                                                color: Colors.yellow,
                                              ),
                                              style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero),
                                              label: const Text(
                                                "Boost",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.yellow),
                                              ),
                                            ),
                                          ],
                                        ),
                                        10.verticalSpace,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                  }),
                ),
              ),
      ),
    );
  }
}
