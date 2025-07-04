import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_cli/get_cli.dart';
import 'package:join_my_ship/app/data/models/job_model.dart';
import 'package:join_my_ship/app/data/models/subscription_model.dart';
import 'package:join_my_ship/app/data/providers/subscription_provider.dart';
import 'package:join_my_ship/app/modules/crew_referral/controllers/crew_referral_controller.dart';
import 'package:join_my_ship/app/modules/employer_job_applications/controllers/employer_job_applications_controller.dart';
import 'package:join_my_ship/app/modules/employer_job_posts/controllers/employer_job_posts_controller.dart';
import 'package:join_my_ship/app/modules/job_post/controllers/job_post_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/widgets/circular_progress_indicator_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:collection/collection.dart';

class EmployerJobPostsView extends GetView<EmployerJobPostsController> {
  const EmployerJobPostsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.parentKey,
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
                            print(controller
                                .jobPosts[index].employerDetails?.userTypeKey);
                            return controller.jobPosts.isEmpty
                                ? const Center(child: Text("No jobs posted"))
                                : Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: PreferencesHelper.instance.isCrew ==
                                            true
                                        ? _buildCrewReferralCard(
                                            controller.jobPosts[index])
                                        : _buildCard(
                                            controller.jobPosts[index]),
                                  );
                          }),
                        ),
                      ),
      ),
    );
  }

  _buildCrewReferralCard(Job job, {bool shareView = false}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                      flex: 15,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${job.employerDetails?.firstName ?? ""} ${job.employerDetails?.lastName ?? ""}",
                            overflow: TextOverflow.ellipsis,
                            style: Get.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text("Referred Job",
                              style: Get.textTheme.bodySmall
                                  ?.copyWith(color: Colors.grey.shade700))
                        ],
                      ),
                    ),
                    controller.jobIdBeingDeleted.value == job.id
                        ? const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator())
                        : PopupMenuButton<int>(
                            onSelected: (value) {
                              switch (value) {
                                case 1:
                                  PreferencesHelper.instance.isCrew == true
                                      ? Get.offNamed(Routes.CREW_REFERRAL,
                                          arguments: CrewReferralArguments(
                                              jobToEdit: job))
                                      : Get.offNamed(Routes.JOB_POST,
                                          arguments:
                                              JobPostArguments(jobToEdit: job));
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    8.verticalSpace,
                    Column(
                      children: [
                        Row(
                          children: [
                            Text("Rank: ", style: Get.textTheme.bodyLarge),
                            Text(
                              UserStates.instance.ranks
                                      ?.firstWhereOrNull((rank) =>
                                          job.jobRankWithWages?.firstOrNull
                                              ?.rankNumber ==
                                          rank.id)
                                      ?.name ??
                                  "",
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 14),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text("Vessel IMO No: ",
                                style: Get.textTheme.bodyLarge),
                            Text(
                              job.vesselIMO?.toString() ?? "",
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 14),
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text("Vessel Type: ",
                                  maxLines: 2, style: Get.textTheme.bodyLarge),
                            ),
                            Text(UserStates.instance.vessels?.vessels
                                    ?.map((e) => e.subVessels ?? [])
                                    .expand((e) => e)
                                    .firstWhereOrNull(
                                        (e) => e.id == job.vesselId)
                                    ?.name ??
                                ""),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text("Flag: ",
                                  maxLines: 2, style: Get.textTheme.bodyLarge),
                            ),
                            Text(UserStates.instance.flags
                                    ?.firstWhereOrNull(
                                        (flag) => job.flag == flag.id)
                                    ?.flagCode ??
                                ""),
                          ],
                        ),
                        Row(
                          children: [
                            Flexible(
                              child: Text("Joining Port: ",
                                  maxLines: 2, style: Get.textTheme.bodyLarge),
                            ),
                            Text(job.joiningPort ?? ""),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Tentative Joining Date: ",
                                style: Get.textTheme.bodyLarge),
                            Text(
                              job.tentativeJoining!,
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(fontSize: 14),
                            )
                          ],
                        ),
                      ],
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
                                        "${UserStates.instance.cocs?.firstWhereOrNull((coc) => coc.id == e.cocId)?.name ?? ""} |",
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
                                        "${UserStates.instance.cops?.firstWhereOrNull((cop) => cop.id == e.copId)?.name ?? ""} |",
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
                                        "${UserStates.instance.watchKeepings?.firstWhereOrNull((watchKeeping) => watchKeeping.id == e.watchKeepingId)?.name ?? ""} |",
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
                    10.verticalSpace,
                  ],
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!shareView) ...[
                  Row(
                    children: [
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
                          ),
                          label: Text(
                            " ${job.jobLikeCount}",
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: Colors.blue),
                          )),
                      4.horizontalSpace,
                      Expanded(
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
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
                    ],
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
                              PreferencesHelper.instance.isCrew == true
                                  ? Get.offNamed(Routes.CREW_REFERRAL,
                                      arguments:
                                          CrewReferralArguments(jobToEdit: job))
                                  : Get.offNamed(Routes.JOB_POST,
                                      arguments:
                                          JobPostArguments(jobToEdit: job));
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
                    Text(UserStates.instance.vessels?.vessels
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
                                RxBool isLoadingSubscription = true.obs;
                                UserStates.instance.subscription ??=
                                    await getIt<SubscriptionProvider>()
                                        .getSubscriptions();
                                isLoadingSubscription.value = false;
                                bool? shouldHighlight = await showDialog(
                                  context: Get.context!,
                                  barrierDismissible: false,
                                  builder: (context) => Obx(() {
                                    return AlertDialog(
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
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Get
                                                          .theme.primaryColor)),
                                          const Spacer(),
                                          Tooltip(
                                              message:
                                                  "Highlighting a job post will send one time notification to all the ranks required.",
                                              child: Icon(Icons.info_outline,
                                                  color: Get.theme.primaryColor,
                                                  size: 16))
                                        ],
                                      ),
                                      actionsPadding:
                                          const EdgeInsets.only(bottom: 25),
                                      content: isLoadingSubscription.value
                                          ? const CircularProgressIndicator()
                                          : Text(
                                              "Are you sure you want to use\nyour ${UserStates.instance.subscription?.firstWhereOrNull((subs) => subs.isTypeKey?.type == PlanType.employerHighlight)?.points ?? ""} credits?",
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
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
                                    );
                                  }),
                                );
                                if (shouldHighlight == true) {
                                  controller.highlightJob(
                                      job.id!,
                                      UserStates.instance.subscription
                                              ?.firstWhereOrNull((subs) =>
                                                  subs.isTypeKey?.type ==
                                                  PlanType.employerHighlight)
                                              ?.planName
                                              ?.id ??
                                          -1);
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
                        onPressed: () {
                          if (job.id == null) {
                            return;
                          }
                          controller.boostJob(job.id!);
                        },
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
