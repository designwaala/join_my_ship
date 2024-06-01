import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:get_cli/get_cli.dart';
import 'package:join_my_ship/app/data/models/boosting_model.dart';
import 'package:join_my_ship/app/modules/boosted_jobs/bindings/boosted_jobs_binding.dart';
import 'package:join_my_ship/app/modules/job_opening/controllers/job_opening_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/widgets/job_cards/crew_referral_job_card.dart';
import 'package:story_view/story_view.dart';
import 'package:collection/collection.dart';

import '../controllers/boosted_jobs_controller.dart';

class BoostedJobsView extends GetView<BoostedJobsController> {
  @override
  final String? tag;

  const BoostedJobsView({Key? key, this.tag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            foregroundColor: Colors.white,
            backgroundColor: Get.theme.primaryColor,
            // title: const Text('BoostedJobsView'),
            centerTitle: true,
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(64),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        30.horizontalSpace,
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: CachedNetworkImage(
                            height: 48,
                            width: 48,
                            imageUrl: controller
                                    .jobs.firstOrNull?.userBoost?.profilePic ??
                                "",
                            fit: BoxFit.cover,
                          ),
                        ),
                        12.horizontalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                "JOB BY: ${controller.jobs.firstOrNull?.userBoost?.firstName ?? ""}",
                                style: Get.textTheme.titleMedium?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                            Text(
                                controller.jobs.firstOrNull?.userBoost
                                        ?.companyName ??
                                    "",
                                style: Get.textTheme.bodyMedium
                                    ?.copyWith(color: Colors.white))
                          ],
                        )
                      ],
                    ),
                    24.verticalSpace
                  ],
                ))),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    12.verticalSpace,
                    Expanded(
                      child: StoryView(
                        onStoryShow: (value) {
                          int? index = int.tryParse(
                              (value.view.key as ValueKey).value ?? "");
                          controller.currentJobIndex = index;
                          print(index);
                        },
                        onComplete: () async {
                          Get.back();
                          if ((controller.currentIndex + 1) <
                              (controller.args?.jobGrouped?.length ?? 0)) {
                            Get.to(
                                () => BoostedJobsView(
                                    tag: controller.args?.currentIndex
                                        ?.toString()),
                                arguments: BoostedJobsArguments(
                                    jobGrouped: controller.args?.jobGrouped,
                                    currentIndex:
                                        (controller.args?.currentIndex ?? 0) +
                                            1),
                                binding: BoostedTagJobsBinding(
                                    controller.args?.currentIndex?.toString() ??
                                        ""),
                                preventDuplicates: true);
                          }
                        },
                        controller: controller.storyController,
                        indicatorColor: const Color(0xFFDADADA),
                        indicatorForegroundColor: const Color(0xFFFE9738),
                        storyItems: controller.jobs
                            .mapIndexed(
                              (index, job) => StoryItem(
                                Padding(
                                    key: ValueKey("$index"),
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24),
                                    child: CustomScrollView(
                                      slivers: [
                                        SliverFillRemaining(
                                          hasScrollBody: false,
                                          child: job.postBoost?.gRT == null
                                              ? _referredJob(job)
                                              : _job(job),
                                        )
                                      ],
                                    )),
                                duration: const Duration(
                                    seconds: kDebugMode ? 1 : 15),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              onPressed: () {
                                Get.toNamed(Routes.JOB_OPENING,
                                    arguments: JobOpeningArguments(
                                        jobId: controller
                                            .jobs[
                                                controller.currentJobIndex ?? 0]
                                            .postBoost
                                            ?.id),
                                    preventDuplicates: false);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 32),
                                child: Row(
                                  children: [
                                    const Icon(Icons.visibility_outlined),
                                    4.horizontalSpace,
                                    const Text("View Job")
                                  ],
                                ),
                              )),
                          InkWell(
                              onTap: () {
                                Get.back();
                                if ((controller.currentIndex + 1) <
                                    (controller.args?.jobGrouped?.length ??
                                        0)) {
                                  Get.to(
                                      () => BoostedJobsView(
                                          tag: controller.args?.currentIndex
                                              ?.toString()),
                                      arguments: BoostedJobsArguments(
                                          jobGrouped:
                                              controller.args?.jobGrouped,
                                          currentIndex:
                                              (controller.args?.currentIndex ??
                                                      0) +
                                                  1),
                                      binding: BoostedTagJobsBinding(controller
                                              .args?.currentIndex
                                              ?.toString() ??
                                          ""),
                                      preventDuplicates: true);
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 3,
                                        color: Get.theme.primaryColor)),
                                child: Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                        color: Get.theme.primaryColor,
                                        shape: BoxShape.circle),
                                    child: const Icon(Icons.arrow_forward,
                                        color: Colors.white)),
                              ))
                        ],
                      ),
                    ),
                    32.verticalSpace,
                  ],
                );
        }));
  }

  Widget _referredJob(Employer job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        48.verticalSpace,
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text("Tentative Joining Date: ", style: Get.textTheme.bodyLarge),
              Text(
                job.postBoost?.tentativeJoining ?? "",
                style: Get.textTheme.bodyMedium?.copyWith(fontSize: 14),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Flexible(
                child: Text("Vessel Type: ",
                    maxLines: 2, style: Get.textTheme.bodyLarge),
              ),
              Text(controller.vesselList?.vessels
                      ?.map((e) => e.subVessels ?? [])
                      .expand((e) => e)
                      .firstWhereOrNull((e) => e.id == job.postBoost?.vesselId)
                      ?.name ??
                  ""),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text("Vessel IMO No.: ", style: Get.textTheme.bodyLarge),
              Text(job.postBoost?.vesselIMO.toString() ?? "")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text("Flag: ", style: Get.textTheme.bodyLarge),
              Text(UserStates.instance.flags?.firstWhereOrNull((flag) => flag.id == job.postBoost?.flag)?.flagCode ?? "")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text("Joining Port: ", style: Get.textTheme.bodyLarge),
              Text(job.postBoost?.joiningPort.toString() ?? "")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset("assets/icons/job.svg"),
                                10.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    controller.ranks.firstWhereOrNull((rank) => rank.id == job.postBoost?.jobRankWithWages?.firstOrNull?.rankNumber)?.name ?? "",
                                    style: const TextStyle(fontSize: 15),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          )
        ),
        if (job.postBoost?.jobCoc != null &&
            job.postBoost?.jobCoc?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "COC Requirements: ",
                  style: Get.textTheme.bodyLarge,
                ),
                Text(job.postBoost?.jobCoc
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
          ),
        if (job.postBoost?.jobCop != null &&
            job.postBoost?.jobCop?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "COP Requirements: ",
                  style: Get.textTheme.bodyLarge,
                ),
                Text(job.postBoost?.jobCop
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
          ),
        if (job.postBoost?.jobWatchKeeping != null &&
            job.postBoost?.jobWatchKeeping?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Watch-Keeping Requirements: ",
                  style: Get.textTheme.bodyLarge,
                ),
                Text(job.postBoost?.jobWatchKeeping
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
          ),
        if (job.postBoost?.mailInfo == true)
          Row(
            children: [
              Text(
                "Email: ",
                style: Get.textTheme.bodyLarge,
              ),
              Text(
                job.postBoost?.employerDetails?.email ?? "",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        if (job.postBoost?.numberInfo == true)
          Row(
            children: [
              Text(
                "Mobile: ",
                style: Get.textTheme.bodyLarge,
              ),
              Text(
                job.postBoost?.employerDetails?.number ?? "",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        const Spacer(),
      ],
    );
  }

  Widget _job(Employer job) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        48.verticalSpace,
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text("Tentative Joining Date: ", style: Get.textTheme.bodyLarge),
              Text(
                job.postBoost?.tentativeJoining ?? "",
                style: Get.textTheme.bodyMedium?.copyWith(fontSize: 14),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Flexible(
                child: Text("Vessel Type: ",
                    maxLines: 2, style: Get.textTheme.bodyLarge),
              ),
              Text(controller.vesselList?.vessels
                      ?.map((e) => e.subVessels ?? [])
                      .expand((e) => e)
                      .firstWhereOrNull((e) => e.id == job.postBoost?.vesselId)
                      ?.name ??
                  ""),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text("GRT: ", style: Get.textTheme.bodyLarge),
              Text(job.postBoost?.gRT.toString() ?? "")
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: job.postBoost?.jobRankWithWages
                      ?.map((rankWithWages) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SvgPicture.asset("assets/icons/job.svg"),
                                10.horizontalSpace,
                                Flexible(
                                  child: Text(
                                    "${controller.ranks.firstWhereOrNull((rank) => rank.id == rankWithWages.rankNumber)?.name ?? ""} - ${rankWithWages.wages} USD",
                                    style: const TextStyle(fontSize: 15),
                                    maxLines: 2,
                                  ),
                                ),
                              ],
                            ),
                          ))
                      .toList() ??
                  []),
        ),
        if (job.postBoost?.jobCoc != null &&
            job.postBoost?.jobCoc?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "COC Requirements: ",
                  style: Get.textTheme.bodyLarge,
                ),
                Text(job.postBoost?.jobCoc
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
          ),
        if (job.postBoost?.jobCop != null &&
            job.postBoost?.jobCop?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "COP Requirements: ",
                  style: Get.textTheme.bodyLarge,
                ),
                Text(job.postBoost?.jobCop
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
          ),
        if (job.postBoost?.jobWatchKeeping != null &&
            job.postBoost?.jobWatchKeeping?.isNotEmpty == true)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Watch-Keeping Requirements: ",
                  style: Get.textTheme.bodyLarge,
                ),
                Text(job.postBoost?.jobWatchKeeping
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
          ),
        if (job.postBoost?.mailInfo == true)
          Row(
            children: [
              Text(
                "Email: ",
                style: Get.textTheme.bodyLarge,
              ),
              Text(
                job.postBoost?.employerDetails?.email ?? "",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        if (job.postBoost?.numberInfo == true)
          Row(
            children: [
              Text(
                "Mobile: ",
                style: Get.textTheme.bodyLarge,
              ),
              Text(
                job.postBoost?.employerDetails?.number ?? "",
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        const Spacer(),
      ],
    );
  }
}
