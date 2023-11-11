import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_cli/get_cli.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/app/modules/employer_job_applications/controllers/employer_job_applications_controller.dart';
import 'package:join_mp_ship/app/modules/employer_job_posts/controllers/employer_job_posts_controller.dart';
import 'package:join_mp_ship/app/modules/job_post/controllers/job_post_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

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
            : controller.jobPosts.isEmpty
                ? Column(
                    children: [
                      LottieBuilder.asset("assets/animations/no_results.json"),
                      16.verticalSpace,
                      const Text("No Jobs Posted By You.")
                    ],
                  )
                : controller.buildCaptureWidget.value
                    ? Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
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
                                controller: controller.widgetsToImageController,
                                child: Column(
                                  children: [
                                    _buildCard(controller.jobToBuild!,
                                        shareView: true),
                                  ],
                                )),
                          ],
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListView.builder(
                          itemCount: controller.jobPosts.length,
                          itemBuilder: (context, index) => Obx(() {
                            return controller.jobPosts.isEmpty
                                ? const Center(child: Text("No jobs posted"))
                                : Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child:
                                        _buildCard(controller.jobPosts[index]),
                                  );
                          }),
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
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${job.employerDetails?.firstName ?? ""} ${job.employerDetails?.lastName ?? ""}",
                        overflow: TextOverflow.ellipsis,
                        style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(job.employerDetails?.companyName ?? "",
                          overflow: TextOverflow.ellipsis,
                          // "Westline Ship Management Pvt. Ltd.",
                          style: Get.textTheme.bodySmall?.copyWith(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                // const Spacer(),
                controller.jobIdBeingDeleted.value == job.id
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator())
                    : PopupMenuButton<int>(
                        onSelected: (value) {
                          switch (value) {
                            case 1:
                              Get.offNamed(Routes.JOB_POST,
                                  arguments: JobPostArguments(jobToEdit: job));
                              return;
                            case 2:
                              controller.captureWidget(job);
                              return;
                            case 3:
                              controller.deleteJobPost(job.id ?? -1);
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
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                        onOpened: () {},
                      ),
                8.horizontalSpace,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text("Tentative Joining Date: ",
                        style: Get.textTheme.bodyLarge),
                    Text(
                      job.tentativeJoining!,
                      style: Get.textTheme.bodyMedium?.copyWith(fontSize: 14),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text("Vessel Type: ", style: Get.textTheme.bodyLarge),
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: job.jobRankWithWages
                              ?.map((rankWithWages) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        const Icon(
                                          Icons.radio_button_checked,
                                          color: Color.fromARGB(
                                              255, 169, 168, 170),
                                          size: 20,
                                        ),
                                        10.horizontalSpace,
                                        Text(
                                          controller.ranks
                                                  .firstWhereOrNull((rank) =>
                                                      rank.id ==
                                                      rankWithWages.rankNumber)
                                                  ?.name ??
                                              "",
                                          style: const TextStyle(fontSize: 15),
                                        ),
                                        Text(" - ${rankWithWages.wages} USD")
                                      ],
                                    ),
                                  ))
                              .toList() ??
                          []),
                ),
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
                        style: const TextStyle(fontSize: 14),
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
                5.verticalSpace,
                if (!shareView) ...[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.highlightingJob.value == job.id
                          ? const CircularProgressIndicator()
                          : TextButton.icon(
                              onPressed: () async {
                                if (job.id == null) {
                                  return;
                                }
                                bool? shouldHighlight = await showDialog(
                                  context: Get.context!,
                                  barrierDismissible: false,
                                  builder: (context) => AlertDialog(
                                    shape: alertDialogShape,
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Spacer(),
                                        Icon(Icons.send,
                                            color: Get.theme.primaryColor),
                                        8.horizontalSpace,
                                        Text("Highlight",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Get
                                                        .theme.primaryColor)),
                                        const Spacer(),
                                        const Tooltip(
                                            message:
                                                "Highlighting a job post will send one time notification to all the ranks required.",
                                            child: Icon(Icons.info_outline,
                                                size: 16))
                                      ],
                                    ),
                                    actionsPadding:
                                        const EdgeInsets.only(bottom: 25),
                                    content: const Text(
                                      "Are you sure you want to use\nyour 1000 credits?",
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
                                          padding: const EdgeInsets.symmetric(
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
                                          Get.back(result: true);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 3,
                                          padding: const EdgeInsets.symmetric(
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
                                if (shouldHighlight == true) {
                                  controller.highlightJob(job.id!);
                                }
                              },
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
                      TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.thumb_up,
                            size: 18,
                            color: Colors.blue,
                          ),
                          style: TextButton.styleFrom(
                            splashFactory: NoSplash.splashFactory,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            /* shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(
                                    width: 1.8, color: Colors.blue)), */
                          ),
                          label: Text(
                            " ${job.jobLikeCount}",
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: Colors.blue),
                          )),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.diamond_outlined,
                          size: 22,
                          color: Colors.yellow,
                        ),
                        style: TextButton.styleFrom(padding: EdgeInsets.zero),
                        label: const Text(
                          "Boost",
                          style: TextStyle(fontSize: 14, color: Colors.yellow),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12))),
                        onPressed: () => Get.toNamed(
                            Routes.EMPLOYER_JOB_APPLICATIONS,
                            arguments: EmployerJobApplicationsArguments(
                                jobId: job.id)),
                        child: const Text(
                          "View Applications",
                          style: TextStyle(fontSize: 13),
                        )),
                  ),
                  16.verticalSpace
                ]
              ],
            ),
          ),
        ],
      ),
    );
  }
}
