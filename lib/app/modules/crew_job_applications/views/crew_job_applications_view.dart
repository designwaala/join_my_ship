import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:get_cli/extensions/string.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/modules/application_status/controllers/application_status_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

import '../controllers/crew_job_applications_controller.dart';

class CrewJobApplicationsView extends GetView<CrewJobApplicationsController> {
  const CrewJobApplicationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text('Jobs Applied'),
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : controller.buildCaptureWidget.value
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  _buildCard(controller.applicationToBuild!,
                                      shareView: true),
                                ],
                              )),
                        ],
                      ),
                    )
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: Column(
                        children: controller.applications
                            .map((application) => _buildCard(application))
                            .toList(),
                      ));
        }));
  }

  Widget _buildCard(Application application, {bool shareView = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Card(
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
                        imageUrl:
                            application.jobData?.employerDetails?.profilePic ??
                                ""),
                  ),
                  10.horizontalSpace,
                  Flexible(
                    flex: 15,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "JOB BY: ${application.jobData?.employerDetails?.firstName ?? ""} ${application.jobData?.employerDetails?.lastName ?? ""}",
                          overflow: TextOverflow.ellipsis,
                          style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    children: [
                      Row(
                        children: [
                          Text("Tentative Joining Date: ",
                              style: Get.textTheme.bodyLarge),
                          Text(
                            application.jobData?.tentativeJoining ?? "",
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
                          Text(controller.vesselList?.vessels
                                  ?.map((e) => e.subVessels ?? [])
                                  .expand((e) => e)
                                  .firstWhereOrNull((e) =>
                                      e.id == application.jobData?.vesselId)
                                  ?.name ??
                              ""),
                        ],
                      ),
                      Row(
                        children: [
                          Text("GRT: ", style: Get.textTheme.bodyLarge),
                          Text(application.jobData?.gRT.toString() ?? "")
                        ],
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Row(
                        children: [
                          Text("Vessel Type: ", style: Get.textTheme.bodyLarge),
                          Text(controller.vesselList?.vessels
                                  ?.map((e) => e.subVessels ?? [])
                                  .expand((e) => e)
                                  .firstWhereOrNull((e) =>
                                      e.id == application.jobData?.vesselId)
                                  ?.name ??
                              ""),
                        ],
                      ),
                      Row(
                        children: [
                          Text("Tentative Joining Date: ",
                              style: Get.textTheme.bodyLarge),
                          Text(
                            application.jobData?.tentativeJoining.toString() ??
                                "",
                          )
                        ],
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: application.jobData?.jobRankWithWages
                                ?.map((rankWithWages) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Icon(
                                            application.rankId ==
                                                    rankWithWages.rankNumber
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            color: application.rankId ==
                                                    rankWithWages.rankNumber
                                                ? Get.theme.primaryColor
                                                : Colors.grey,
                                            size: 20,
                                          ),
                                          10.horizontalSpace,
                                          Text(
                                            controller.ranks
                                                    .firstWhereOrNull((rank) =>
                                                        rank.id ==
                                                        rankWithWages
                                                            .rankNumber)
                                                    ?.name ??
                                                "",
                                            style:
                                                const TextStyle(fontSize: 15),
                                          ),
                                          Text(" - ${rankWithWages.wages} USD")
                                        ],
                                      ),
                                    ))
                                .toList() ??
                            []),
                  ),
                  if (application.jobData?.jobCoc != null &&
                      application.jobData?.jobCoc?.isNotEmpty == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "COC Requirements: ",
                          style: Get.textTheme.bodyLarge,
                        ),
                        Text(application.jobData?.jobCoc
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
                  if (application.jobData?.jobCop != null &&
                      application.jobData?.jobCop?.isNotEmpty == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "COP Requirements: ",
                          style: Get.textTheme.bodyLarge,
                        ),
                        Text(application.jobData?.jobCop
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
                  if (application.jobData?.jobWatchKeeping != null &&
                      application.jobData?.jobWatchKeeping?.isNotEmpty == true)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Watch-Keeping Requirements: ",
                          style: Get.textTheme.bodyLarge,
                        ),
                        Text(application.jobData?.jobWatchKeeping
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
                  if (application.jobData?.mailInfo == true)
                    Row(
                      children: [
                        Text(
                          "Email: ",
                          style: Get.textTheme.bodyLarge,
                        ),
                        Text(
                          application.jobData?.employerDetails?.email ?? "",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  if (application.jobData?.numberInfo == true)
                    Row(
                      children: [
                        Text(
                          "Mobile: ",
                          style: Get.textTheme.bodyLarge,
                        ),
                        Text(
                          application.jobData?.employerDetails?.number ?? "",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  16.verticalSpace,
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
                        FilledButton(
                            onPressed: () {
                              Get.toNamed(Routes.APPLICATION_STATUS,
                                  arguments: ApplicationStatusArguments(
                                      application: application));
                            },
                            child: Text("Check Status")),
                        TextButton.icon(
                          onPressed: () {
                            controller.captureWidget(application);
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
                  18.verticalSpace,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
