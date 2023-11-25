import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:get_cli/get_cli.dart';
import 'package:join_mp_ship/app/modules/boosted_jobs/bindings/boosted_jobs_binding.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/user_details.dart';
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
                        onComplete: () async {
                          if ((controller.currentIndex + 1) <
                              (controller.args?.jobGrouped?.length ?? 0)) {
                            Get.back();
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
                            /* Get.offNamed(Routes.BOOSTED_JOBS,
                                arguments: BoostedJobsArguments(
                                    employerWithJobsList:
                                        controller.args?.employerWithJobsList,
                                    currentIndex:
                                        (controller.args?.currentIndex ?? 0) +
                                            1),
                                id: ((controller.args?.currentIndex ?? 0) + 1),
                                preventDuplicates: false); */
                          } else {
                            Get.back();
                          }
                        },
                        controller: controller.storyController,
                        indicatorColor: const Color(0xFFDADADA),
                        indicatorForegroundColor: const Color(0xFFFE9738),
                        storyItems: controller.jobs
                                .map(
                                  (job) => StoryItem(
                                    Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 24),
                                        child: CustomScrollView(
                                          slivers: [
                                            SliverFillRemaining(
                                              hasScrollBody: false,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  48.verticalSpace,
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                            "Tentative Joining Date: ",
                                                            style: Get.textTheme
                                                                .bodyLarge),
                                                        Text(
                                                          job.postBoost
                                                                  ?.tentativeJoining ??
                                                              "",
                                                          style: Get.textTheme
                                                              .bodyMedium
                                                              ?.copyWith(
                                                                  fontSize: 14),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8),
                                                    child: Row(
                                                      children: [
                                                        Flexible(
                                                          child: Text(
                                                              "Vessel Type: ",
                                                              maxLines: 2,
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyLarge),
                                                        ),
                                                        Text(controller
                                                                .vesselList
                                                                ?.vessels
                                                                ?.map((e) =>
                                                                    e.subVessels ??
                                                                    [])
                                                                .expand(
                                                                    (e) => e)
                                                                .firstWhereOrNull((e) =>
                                                                    e.id ==
                                                                    job.postBoost
                                                                        ?.vesselId)
                                                                ?.name ??
                                                            ""),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            bottom: 8),
                                                    child: Row(
                                                      children: [
                                                        Text("GRT: ",
                                                            style: Get.textTheme
                                                                .bodyLarge),
                                                        Text(job.postBoost?.gRT
                                                                .toString() ??
                                                            "")
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(vertical: 3),
                                                    child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: job.postBoost
                                                                ?.jobRankWithWages
                                                                ?.map(
                                                                    (rankWithWages) =>
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 3),
                                                                          child:
                                                                              Row(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              UserStates.instance.crewUser?.rankId == rankWithWages.rankNumber || (UserStates.instance.crewUser?.promotionApplied == true && controller.ranks.firstWhereOrNull((rank) => UserStates.instance.crewUser?.rankId == rank.id)?.promotedTo == rankWithWages.rankNumber)
                                                                                  ? const SizedBox(
                                                                                      height: 20,
                                                                                      width: 20,
                                                                                    )
                                                                                  : SvgPicture.string('''<svg xmlns="http://www.w3.org/2000/svg" width="20" height="20" viewBox="0 0 20 20" fill="none">
  <path fill-rule="evenodd" clip-rule="evenodd" d="M4.25665 4.05583C4.85415 3.975 5.58581 3.96083 6.46581 3.95916C6.5181 3.27871 6.82535 2.64309 7.3261 2.17942C7.82685 1.71574 8.48419 1.45821 9.16665 1.45833H10.8333C11.5155 1.45841 12.1725 1.71592 12.6731 2.17939C13.1736 2.64287 13.4808 3.27817 13.5333 3.95833C14.4141 3.96083 15.1458 3.975 15.7433 4.05583C16.4933 4.15583 17.125 4.3725 17.6266 4.87333C18.1283 5.375 18.3433 6.00666 18.445 6.75666C18.5416 7.47916 18.5416 8.39833 18.5416 9.53749V12.9625C18.5416 14.1017 18.5416 15.0208 18.445 15.7433C18.3433 16.4933 18.1283 17.125 17.6266 17.6267C17.125 18.1283 16.4933 18.3433 15.7433 18.445C15.0208 18.5417 14.1016 18.5417 12.9625 18.5417H7.03748C5.89831 18.5417 4.97915 18.5417 4.25665 18.445C3.50665 18.3433 2.87498 18.1283 2.37331 17.6267C1.87165 17.125 1.65665 16.4933 1.55581 15.7433C1.45831 15.0208 1.45831 14.1017 1.45831 12.9625V9.53749C1.45831 8.39833 1.45831 7.47916 1.55581 6.75666C1.65581 6.00666 1.87248 5.375 2.37331 4.87333C2.87498 4.37166 3.50665 4.15666 4.25665 4.05583ZM12.2766 3.95833H7.72331C7.77341 3.61125 7.94689 3.29385 8.21197 3.06428C8.47705 2.83471 8.81598 2.70834 9.16665 2.70833H10.8333C11.184 2.70834 11.5229 2.83471 11.788 3.06428C12.0531 3.29385 12.2266 3.61125 12.2766 3.95833ZM4.42331 17.2058C3.81165 17.1233 3.48831 16.9725 3.25748 16.7425C3.02665 16.5117 2.87665 16.1883 2.79415 15.5758C2.70998 14.9467 2.70831 14.1125 2.70831 12.9167V10.1083C4.01581 10.6567 5.09165 11.1 6.04165 11.4342V12.5C6.04165 12.6658 6.10749 12.8247 6.2247 12.9419C6.34192 13.0591 6.50089 13.125 6.66665 13.125C6.83241 13.125 6.99138 13.0591 7.10859 12.9419C7.2258 12.8247 7.29165 12.6658 7.29165 12.5V11.8292C8.34467 12.1287 9.44014 12.2512 10.5333 12.1917C11.2475 12.1583 11.9475 12.0367 12.7083 11.8292V12.5C12.7083 12.6658 12.7742 12.8247 12.8914 12.9419C13.0086 13.0591 13.1676 13.125 13.3333 13.125C13.4991 13.125 13.658 13.0591 13.7753 12.9419C13.8925 12.8247 13.9583 12.6658 13.9583 12.5V11.4342C14.9083 11.0992 15.9841 10.6567 17.2916 10.1075V12.9167C17.2916 14.1125 17.29 14.9467 17.2058 15.5767C17.1233 16.1883 16.9725 16.5117 16.7425 16.7425C16.5116 16.9733 16.1883 17.1233 15.5758 17.2058C14.9466 17.29 14.1125 17.2917 12.9166 17.2917H7.08331C5.88748 17.2917 5.05248 17.29 4.42331 17.2058ZM7.29165 10.53C8.11165 10.7767 8.81165 10.91 9.52498 10.9425C9.84165 10.9575 10.1583 10.9575 10.475 10.9425C11.1883 10.9092 11.8891 10.7758 12.7083 10.53V9.58333C12.7083 9.41757 12.7742 9.2586 12.8914 9.14139C13.0086 9.02418 13.1676 8.95833 13.3333 8.95833C13.4991 8.95833 13.658 9.02418 13.7753 9.14139C13.8925 9.2586 13.9583 9.41757 13.9583 9.58333V10.1042C14.8691 9.76583 15.9425 9.31916 17.29 8.7525C17.2858 7.98333 17.2691 7.39583 17.2058 6.92333C17.1233 6.31166 16.9725 5.98833 16.7425 5.75749C16.5116 5.52666 16.1883 5.37666 15.5758 5.29416C14.9466 5.21 14.1125 5.20833 12.9166 5.20833H7.08331C5.88748 5.20833 5.05248 5.21 4.42331 5.29416C3.81165 5.37666 3.48831 5.52749 3.25748 5.75749C3.02665 5.98833 2.87665 6.31166 2.79415 6.92416C2.73081 7.39583 2.71415 7.9825 2.70998 8.7525C4.05748 9.31916 5.13081 9.76583 6.04165 10.1042V9.58333C6.04165 9.41757 6.10749 9.2586 6.2247 9.14139C6.34192 9.02418 6.50089 8.95833 6.66665 8.95833C6.83241 8.95833 6.99138 9.02418 7.10859 9.14139C7.2258 9.2586 7.29165 9.41757 7.29165 9.58333V10.53Z" fill="#FFA24D"/>
</svg>'''),
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
                                                  if (job.postBoost?.jobCoc !=
                                                          null &&
                                                      job.postBoost?.jobCoc
                                                              ?.isNotEmpty ==
                                                          true)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "COC Requirements: ",
                                                            style: Get.textTheme
                                                                .bodyLarge,
                                                          ),
                                                          Text(job.postBoost
                                                                  ?.jobCoc
                                                                  ?.map(
                                                                    (e) =>
                                                                        "${controller.cocs.firstWhereOrNull((coc) => coc.id == e.cocId)?.name ?? ""} |",
                                                                  )
                                                                  .toString()
                                                                  .removeAll(
                                                                      "(")
                                                                  .removeAll(
                                                                      ",")
                                                                  .removeAll(
                                                                      " |)") ??
                                                              ""),
                                                        ],
                                                      ),
                                                    ),
                                                  if (job.postBoost?.jobCop !=
                                                          null &&
                                                      job.postBoost?.jobCop
                                                              ?.isNotEmpty ==
                                                          true)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "COP Requirements: ",
                                                            style: Get.textTheme
                                                                .bodyLarge,
                                                          ),
                                                          Text(job.postBoost
                                                                  ?.jobCop
                                                                  ?.map(
                                                                    (e) =>
                                                                        "${controller.cops.firstWhereOrNull((cop) => cop.id == e.copId)?.name ?? ""} |",
                                                                  )
                                                                  .toString()
                                                                  .removeAll(
                                                                      "(")
                                                                  .removeAll(
                                                                      ",")
                                                                  .removeAll(
                                                                      " |)") ??
                                                              ""),
                                                        ],
                                                      ),
                                                    ),
                                                  if (job.postBoost
                                                              ?.jobWatchKeeping !=
                                                          null &&
                                                      job
                                                              .postBoost
                                                              ?.jobWatchKeeping
                                                              ?.isNotEmpty ==
                                                          true)
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              bottom: 8),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Watch-Keeping Requirements: ",
                                                            style: Get.textTheme
                                                                .bodyLarge,
                                                          ),
                                                          Text(job.postBoost
                                                                  ?.jobWatchKeeping
                                                                  ?.map(
                                                                    (e) =>
                                                                        "${controller.watchKeepings.firstWhereOrNull((watchKeeping) => watchKeeping.id == e.watchKeepingId)?.name ?? ""} |",
                                                                  )
                                                                  .toString()
                                                                  .removeAll(
                                                                      "(")
                                                                  .removeAll(
                                                                      ",")
                                                                  .removeAll(
                                                                      " |)") ??
                                                              ""),
                                                        ],
                                                      ),
                                                    ),
                                                  if (job.postBoost?.mailInfo ==
                                                      true)
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Email: ",
                                                          style: Get.textTheme
                                                              .bodyLarge,
                                                        ),
                                                        Text(
                                                          job
                                                                  .postBoost
                                                                  ?.employerDetails
                                                                  ?.email ??
                                                              "",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                  if (job.postBoost
                                                          ?.numberInfo ==
                                                      true)
                                                    Row(
                                                      children: [
                                                        Text(
                                                          "Mobile: ",
                                                          style: Get.textTheme
                                                              .bodyLarge,
                                                        ),
                                                        Text(
                                                          job
                                                                  .postBoost
                                                                  ?.employerDetails
                                                                  ?.number ??
                                                              "",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 13),
                                                        ),
                                                      ],
                                                    ),
                                                  const Spacer(),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      ElevatedButton(
                                                          style: ElevatedButton.styleFrom(
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              12))),
                                                          onPressed: () {},
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        12,
                                                                    horizontal:
                                                                        32),
                                                            child: Row(
                                                              children: [
                                                                Icon(Icons
                                                                    .visibility_outlined),
                                                                4.horizontalSpace,
                                                                Text("View Job")
                                                              ],
                                                            ),
                                                          )),
                                                      InkWell(
                                                          onTap: () {},
                                                          child: Container(
                                                            padding:
                                                                EdgeInsets.all(
                                                                    6),
                                                            decoration: BoxDecoration(
                                                                shape: BoxShape
                                                                    .circle,
                                                                border: Border.all(
                                                                    width: 3,
                                                                    color: Get
                                                                        .theme
                                                                        .primaryColor)),
                                                            child: Container(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            12),
                                                                decoration: BoxDecoration(
                                                                    color: Get
                                                                        .theme
                                                                        .primaryColor,
                                                                    shape: BoxShape
                                                                        .circle),
                                                                child: Icon(
                                                                    Icons
                                                                        .arrow_forward,
                                                                    color: Colors
                                                                        .white)),
                                                          ))
                                                    ],
                                                  ),
                                                  32.verticalSpace,
                                                ],
                                              ),
                                            )
                                          ],
                                        )),
                                    duration: const Duration(
                                        seconds: kDebugMode ? 1 : 15),
                                  ),
                                )
                                .toList() ??
                            [],
                      ),
                    ),
                  ],
                );
        }));
  }
}
