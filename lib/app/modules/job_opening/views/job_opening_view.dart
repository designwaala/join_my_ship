import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_cli/get_cli.dart';
import 'package:join_my_ship/app/data/models/job_model.dart';
import 'package:join_my_ship/app/data/models/ranks_model.dart';
import 'package:join_my_ship/app/data/models/subscription_model.dart';
import 'package:join_my_ship/app/data/models/vessel_list_model.dart';
import 'package:join_my_ship/app/data/providers/subscription_provider.dart';
import 'package:join_my_ship/app/modules/crew_referral/controllers/crew_referral_controller.dart';
import 'package:join_my_ship/app/modules/employer_job_applications/controllers/employer_job_applications_controller.dart';
import 'package:join_my_ship/app/modules/job_opening/controllers/job_opening_controller.dart';
import 'package:join_my_ship/app/modules/job_post/controllers/job_post_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/utils/remote_config.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/widgets/circular_progress_indicator_widget.dart';
import 'package:join_my_ship/widgets/dropdown_decoration.dart';
import 'package:join_my_ship/widgets/job_cards/crew_referral_job_card.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';
import 'package:lottie/lottie.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:collection/collection.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class JobOpeningView extends GetView<JobOpeningController> {
  const JobOpeningView({Key? key}) : super(key: key);

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
                        Text(
                          "Rank",
                          style: Get.textTheme.bodyLarge
                              ?.copyWith(color: Colors.blue, fontSize: 18),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<Rank>(
                            isExpanded: true,
                            style: Get.textTheme.bodySmall,
                            items: controller.ranks
                                    .map((e) => DropdownMenuItem<Rank>(
                                        value: e,
                                        child: Row(
                                          children: [
                                            Obx(() {
                                              return Checkbox(
                                                  value: controller.toApplyRanks
                                                      .contains(e.id),
                                                  onChanged: (_) {
                                                    if (e.id == null) {
                                                      return;
                                                    }
                                                    if (controller.toApplyRanks
                                                        .contains(e.id)) {
                                                      controller.toApplyRanks
                                                          .remove(e.id);
                                                    } else {
                                                      controller.toApplyRanks
                                                          .add(e.id!);
                                                    }
                                                  });
                                            }),
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
                                width: 200,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: DropdownDecoration()),
                          ),
                        )
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Vessel Type",
                          style: Get.textTheme.bodyLarge
                              ?.copyWith(color: Colors.blue, fontSize: 18),
                        ),
                        DropdownButtonHideUnderline(
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
                                                style: Get.textTheme.titleSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                          ...?e.subVessels?.map(
                                              (e) => DropdownMenuItem<int>(
                                                  value: e.id,
                                                  child: Row(
                                                    children: [
                                                      Obx(() {
                                                        return Checkbox(
                                                            value: controller
                                                                .toApplyVesselTypes
                                                                .contains(e.id),
                                                            onChanged: (_) {
                                                              if (e.id ==
                                                                  null) {
                                                                return;
                                                              }
                                                              if (controller
                                                                  .toApplyVesselTypes
                                                                  .contains(
                                                                      e.id)) {
                                                                controller
                                                                    .toApplyVesselTypes
                                                                    .remove(
                                                                        e.id);
                                                              } else {
                                                                controller
                                                                    .toApplyVesselTypes
                                                                    .add(e.id!);
                                                              }
                                                            });
                                                      }),
                                                      Flexible(
                                                        child: Text(
                                                            e.name ?? "",
                                                            maxLines: 1,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            style: Get.textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        12)),
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
                                width: 200,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(64),
                                  border:
                                      Border.all(color: Get.theme.primaryColor),
                                )),
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
    print(controller.jobOpening.value?.employerDetails?.id);
    return Scaffold(
      key: controller.parentKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Job'),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const CircularProgressIndicatorWidget()
            : SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    controller.jobOpening.value?.id == null
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
                                  "No Such Job Found!",
                                  style: TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600),
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
                                            controller
                                        .jobOpening.value?.employerDetails?.userTypeKey == 2 ? 
                                          _buildCrewReferralCard(shareView: true) :
                                          PreferencesHelper.instance.userId ==
                                    controller
                                        .jobOpening.value?.employerDetails?.id ? _buildMyCard(shareView: true) :    
                                          _buildCard(shareView: true),
                                          ],
                                        )),
                                  ],
                                ),
                              )
                            : true || PreferencesHelper.instance.userId ==
                                    controller
                                        .jobOpening.value?.employerDetails?.id
                                ? 
                                controller
                                        .jobOpening.value?.employerDetails?.userTypeKey == 2 ? 
                                        _buildCrewReferralCard() :
                                  PreferencesHelper.instance.userId ==
                                    controller
                                        .jobOpening.value?.employerDetails?.id ? _buildMyCard(shareView: true) :
                                        _buildCard()
                                : Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Card(
                                      elevation: 5,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
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
                                                      BorderRadius.circular(
                                                          128),
                                                  child: CachedNetworkImage(
                                                      height: 50,
                                                      width: 50,
                                                      imageUrl: controller
                                                              .jobOpening
                                                              .value
                                                              ?.employerDetails
                                                              ?.profilePic ??
                                                          ""),
                                                ),
                                                10.horizontalSpace,
                                                Flexible(
                                                  flex: 15,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "${!controller.isReferredJob.value ? "Job By: " : ""}${controller.jobOpening.value?.employerDetails?.firstName ?? ""} ${controller.jobOpening.value?.employerDetails?.lastName ?? ""}",
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        style: Get.textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize: 16),
                                                      ),
                                                      Text(
                                                          controller
                                                                  .isReferredJob
                                                                  .value
                                                              ? "Referred job"
                                                              : controller
                                                                      .jobOpening
                                                                      .value
                                                                      ?.employerDetails
                                                                      ?.companyName ??
                                                                  "",
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          // "Westline Ship Management Pvt. Ltd.",
                                                          style: Get.textTheme
                                                              .bodySmall
                                                              ?.copyWith(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                    ],
                                                  ),
                                                ),
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
                                                if (!controller
                                                    .isReferredJob.value)
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.end,
                                                    children: [
                                                      UserStates
                                                                  .instance
                                                                  .crewUser
                                                                  ?.userTypeKey ==
                                                              2
                                                          ? controller.followingJob
                                                                      .value ==
                                                                  controller
                                                                      .jobOpening
                                                                      .value
                                                                      ?.id
                                                              ? CircularProgressIndicator()
                                                              : TextButton.icon(
                                                                  onPressed:
                                                                      () {
                                                                    controller.followJob(
                                                                        controller
                                                                            .jobOpening
                                                                            .value
                                                                            ?.employerDetails
                                                                            ?.id,
                                                                        controller
                                                                            .jobOpening
                                                                            .value
                                                                            ?.id);
                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.add,
                                                                    size: 20,
                                                                  ),
                                                                  label: const Text(
                                                                      "Follow"),
                                                                  style: TextButton
                                                                      .styleFrom(
                                                                    padding: const EdgeInsets
                                                                            .only(
                                                                        left: 8,
                                                                        right:
                                                                            15),
                                                                    foregroundColor:
                                                                        Colors
                                                                            .white,
                                                                    backgroundColor:
                                                                        Colors
                                                                            .blue,
                                                                    shape:
                                                                        RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              20),
                                                                    ),
                                                                  ),
                                                                )
                                                          : const SizedBox()
                                                    ],
                                                  ),
                                                !controller.isReferredJob.value
                                                    ? Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "Tentative Joining Date: ",
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge),
                                                              Text(
                                                                controller
                                                                        .jobOpening
                                                                        .value
                                                                        ?.tentativeJoining ??
                                                                    "",
                                                                style: Get
                                                                    .textTheme
                                                                    .bodyMedium
                                                                    ?.copyWith(
                                                                        fontSize:
                                                                            14),
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
                                                          //                 controller.vesselList?.vessels?.map((e) => e.subVessels ?? []).expand((e) => e).firstWhereOrNull((e) => e.id == controller.jobOpening.value?.vesselId)?.name ?? ""),
                                                          //       ],
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                          Row(
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
                                                                          (e) =>
                                                                              e)
                                                                      .firstWhereOrNull((e) =>
                                                                          e.id ==
                                                                          controller
                                                                              .jobOpening
                                                                              .value
                                                                              ?.vesselId)
                                                                      ?.name ??
                                                                  ""),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text("GRT: ",
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge),
                                                              Text(controller
                                                                      .jobOpening
                                                                      .value
                                                                      ?.gRT
                                                                      .toString() ??
                                                                  "")
                                                            ],
                                                          ),
                                                        ],
                                                      )
                                                    : Column(
                                                        children: [
                                                          Row(
                                                            children: [
                                                              Text("Rank: ",
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge),
                                                              const Text(
                                                                  "Second Engineer"
                                                                  // controller
                                                                  //   .jobOpening.value?
                                                                  //   .rank
                                                                  //   .toString(),
                                                                  )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "Vessel IMO No: ",
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge),
                                                              const Text(
                                                                  "988441"
                                                                  // controller
                                                                  // .jobOpening.value?
                                                                  // .vesselImoNo
                                                                  // .toString(),
                                                                  )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "Vessel Type: ",
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge),
                                                              Text(controller
                                                                      .vesselList
                                                                      ?.vessels
                                                                      ?.map((e) =>
                                                                          e.subVessels ??
                                                                          [])
                                                                      .expand(
                                                                          (e) =>
                                                                              e)
                                                                      .firstWhereOrNull((e) =>
                                                                          e.id ==
                                                                          controller
                                                                              .jobOpening
                                                                              .value
                                                                              ?.vesselId)
                                                                      ?.name ??
                                                                  ""),
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text("Flag: ",
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge),
                                                              const Text("INDIA"
                                                                  // controller
                                                                  // .jobOpening.value?
                                                                  // .flag
                                                                  // .toString(),
                                                                  )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "Joining Port: ",
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge),
                                                              const Text(
                                                                "Kochi",
                                                                // controller
                                                                // .jobOpening.value?
                                                                // .joiningPort
                                                                // .toString(),
                                                              )
                                                            ],
                                                          ),
                                                          Row(
                                                            children: [
                                                              Text(
                                                                  "Tentative Joining Date: ",
                                                                  style: Get
                                                                      .textTheme
                                                                      .bodyLarge),
                                                              Text(
                                                                controller
                                                                        .jobOpening
                                                                        .value
                                                                        ?.tentativeJoining
                                                                        .toString() ??
                                                                    "",
                                                              )
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10,
                                                      vertical: 3),
                                                  child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: controller
                                                              .jobOpening
                                                              .value
                                                              ?.jobRankWithWages
                                                              ?.map(
                                                                  (rankWithWages) =>
                                                                      Padding(
                                                                        padding:
                                                                            const EdgeInsets.symmetric(vertical: 3),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            UserStates.instance.crewUser?.rankId == rankWithWages.rankNumber || (UserStates.instance.crewUser?.promotionApplied == true && controller.ranks.firstWhereOrNull((rank) => UserStates.instance.crewUser?.rankId == rank.id)?.promotedTo == rankWithWages.rankNumber)
                                                                                ? SizedBox(
                                                                                    height: 20,
                                                                                    width: 20,
                                                                                    child: Radio<int?>(
                                                                                        value: controller.jobOpening.value?.id == controller.selectedRank.value?.key ? controller.selectedRank.value?.value : null,
                                                                                        groupValue: rankWithWages.rankNumber,
                                                                                        onChanged: (_) {
                                                                                          print(controller.selectedRank);
                                                                                          controller.selectedRank.value = MapEntry(controller.jobOpening.value?.id ?? -1, rankWithWages.rankNumber ?? -1);
                                                                                        }))
                                                                                : const Icon(
                                                                                    Icons.radio_button_checked,
                                                                                    color: Color.fromARGB(255, 169, 168, 170),
                                                                                    size: 20,
                                                                                  ),
                                                                            10.horizontalSpace,
                                                                            Text(
                                                                              controller.ranks.firstWhereOrNull((rank) => rank.id == rankWithWages.rankNumber)?.name ?? "",
                                                                              style: const TextStyle(fontSize: 15),
                                                                            ),
                                                                            Text(" - ${rankWithWages.wages} USD")
                                                                          ],
                                                                        ),
                                                                      ))
                                                              .toList() ??
                                                          []),
                                                ),
                                                if (controller.selectedRank
                                                            .value?.key !=
                                                        controller.jobOpening
                                                            .value?.id &&
                                                    controller.showErrorForJob
                                                            .value ==
                                                        controller.jobOpening
                                                            .value?.id)
                                                  Text(
                                                      "Please select atleast one rank",
                                                      style: Get
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                              color: Get
                                                                  .theme
                                                                  .colorScheme
                                                                  .error)),
                                                if (controller.jobOpening.value
                                                            ?.jobCoc !=
                                                        null &&
                                                    controller
                                                            .jobOpening
                                                            .value
                                                            ?.jobCoc
                                                            ?.isNotEmpty ==
                                                        true)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "COC Requirements: ",
                                                        style: Get.textTheme
                                                            .bodyLarge,
                                                      ),
                                                      Text(controller.jobOpening
                                                              .value?.jobCoc
                                                              ?.map(
                                                                (e) =>
                                                                    "${controller.cocs.firstWhereOrNull((coc) => coc.id == e.cocId)?.name ?? ""} |",
                                                              )
                                                              .toString()
                                                              .removeAll("(")
                                                              .removeAll(",")
                                                              .removeAll(
                                                                  " |)") ??
                                                          ""),
                                                    ],
                                                  ),
                                                if (controller.jobOpening.value
                                                            ?.jobCop !=
                                                        null &&
                                                    controller
                                                            .jobOpening
                                                            .value
                                                            ?.jobCop
                                                            ?.isNotEmpty ==
                                                        true)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "COP Requirements: ",
                                                        style: Get.textTheme
                                                            .bodyLarge,
                                                      ),
                                                      Text(controller.jobOpening
                                                              .value?.jobCop
                                                              ?.map(
                                                                (e) =>
                                                                    "${controller.cops.firstWhereOrNull((cop) => cop.id == e.copId)?.name ?? ""} |",
                                                              )
                                                              .toString()
                                                              .removeAll("(")
                                                              .removeAll(",")
                                                              .removeAll(
                                                                  " |)") ??
                                                          ""),
                                                    ],
                                                  ),
                                                if (controller.jobOpening.value
                                                            ?.jobWatchKeeping !=
                                                        null &&
                                                    controller
                                                            .jobOpening
                                                            .value
                                                            ?.jobWatchKeeping
                                                            ?.isNotEmpty ==
                                                        true)
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        "Watch-Keeping Requirements: ",
                                                        style: Get.textTheme
                                                            .bodyLarge,
                                                      ),
                                                      Text(controller
                                                              .jobOpening
                                                              .value
                                                              ?.jobWatchKeeping
                                                              ?.map(
                                                                (e) =>
                                                                    "${controller.watchKeepings.firstWhereOrNull((watchKeeping) => watchKeeping.id == e.watchKeepingId)?.name ?? ""} |",
                                                              )
                                                              .toString()
                                                              .removeAll("(")
                                                              .removeAll(",")
                                                              .removeAll(
                                                                  " |)") ??
                                                          ""),
                                                    ],
                                                  ),
                                                if (controller.jobOpening.value
                                                        ?.mailInfo ==
                                                    true)
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "Email: ",
                                                        style: Get.textTheme
                                                            .bodyLarge,
                                                      ),
                                                      Text(
                                                        controller
                                                                .jobOpening
                                                                .value
                                                                ?.employerDetails
                                                                ?.email ??
                                                            "",
                                                        style: const TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                if (controller.jobOpening.value
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
                                                        controller
                                                                .jobOpening
                                                                .value
                                                                ?.employerDetails
                                                                ?.number ??
                                                            "",
                                                        style: const TextStyle(
                                                            fontSize: 13),
                                                      ),
                                                    ],
                                                  ),
                                                10.verticalSpace,
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    controller.likingJob.value
                                                        ? CircularProgressIndicator()
                                                        : TextButton.icon(
                                                            onPressed:
                                                                controller
                                                                    .likeJob,
                                                            icon: Icon(
                                                              controller
                                                                          .jobOpening
                                                                          .value
                                                                          ?.isJobLiked ==
                                                                      true
                                                                  ? Icons
                                                                      .thumb_up_alt_rounded
                                                                  : Icons
                                                                      .thumb_up_alt_outlined,
                                                              size: 18,
                                                            ),
                                                            label: const Text(
                                                              "Like",
                                                              style: TextStyle(
                                                                  fontSize: 13),
                                                            )),
                                                    Column(
                                                      children: [
                                                        TextButton.icon(
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              Icons
                                                                  .thumb_up_alt_outlined,
                                                              size: 18,
                                                              color:
                                                                  Colors.blue,
                                                            ),
                                                            style: TextButton
                                                                .styleFrom(
                                                              splashFactory:
                                                                  NoSplash
                                                                      .splashFactory,
                                                              padding: const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      10),
                                                              shape: RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              15),
                                                                  side: const BorderSide(
                                                                      width:
                                                                          1.8,
                                                                      color: Colors
                                                                          .blue)),
                                                            ),
                                                            label: Text(
                                                              " Likes ${controller.jobOpening.value?.jobLikeCount}",
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                      color: Colors
                                                                          .blue),
                                                            )),
                                                        controller.applyingJob
                                                                    .value ==
                                                                controller
                                                                    .jobOpening
                                                                    .value
                                                                    ?.id
                                                            ? const Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  CircularProgressIndicator()
                                                                ],
                                                              )
                                                            : ElevatedButton(
                                                                style: ElevatedButton.styleFrom(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            20),
                                                                    shape: RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(18))),
                                                                onPressed: controller.applications.any((application) => application.jobId == controller.jobOpening.value?.id || application.jobData?.id == controller.jobOpening.value?.id) == true ||
                                                                        controller.jobOpening.value?.jobRankWithWages?.none((rankWithWage) => rankWithWage.rankNumber == UserStates.instance.crewUser?.rankId || (rankWithWage.rankNumber == controller.ranks.firstWhereOrNull((rank) => rank.id == UserStates.instance.crewUser?.rankId)?.promotedTo)) ==
                                                                            true ||
                                                                        UserStates.instance.crewUser?.userTypeKey !=
                                                                            2
                                                                    ? null
                                                                    : () {
                                                                        if (UserStates.instance.crewUser?.isVerified !=
                                                                            1) {
                                                                          controller
                                                                              .fToast
                                                                              .safeShowToast(child: errorToast(RemoteConfigUtils.instance.accountUnderVerificationCopy));
                                                                          return;
                                                                        }
                                                                        if (controller.selectedRank.value?.key !=
                                                                            controller.jobOpening.value?.id) {
                                                                          controller.showErrorForJob.value = controller
                                                                              .jobOpening
                                                                              .value
                                                                              ?.id;
                                                                          return;
                                                                        }
                                                                        showDialog(
                                                                          context:
                                                                              context,
                                                                          barrierDismissible:
                                                                              false,
                                                                          builder: (context) =>
                                                                              AlertDialog(
                                                                            shape:
                                                                                alertDialogShape,
                                                                            title:
                                                                                const Text(
                                                                              "Are You Sure ?",
                                                                              textAlign: TextAlign.center,
                                                                              style: TextStyle(color: Colors.blue),
                                                                            ),
                                                                            actionsPadding:
                                                                                const EdgeInsets.only(bottom: 25),
                                                                            content:
                                                                                Text(
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
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 35),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(20),
                                                                                  ),
                                                                                ),
                                                                                child: const Text("NO"),
                                                                              ),
                                                                              ElevatedButton(
                                                                                onPressed: () async {
                                                                                  Get.back();
                                                                                  controller.apply(controller.jobOpening.value?.id);
                                                                                },
                                                                                style: ElevatedButton.styleFrom(
                                                                                  elevation: 3,
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 35),
                                                                                  shape: RoundedRectangleBorder(
                                                                                    borderRadius: BorderRadius.circular(20),
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
                                                                              application.jobId == controller.jobOpening.value?.id ||
                                                                              application.jobData?.id == controller.jobOpening.value?.id) ==
                                                                          true
                                                                      ? "APPLIED"
                                                                      : "APPLY NOW",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          14),
                                                                ),
                                                              ),
                                                      ],
                                                    ),
                                                    TextButton.icon(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.share_sharp,
                                                        size: 18,
                                                        color: Colors.black,
                                                      ),
                                                      label: const Text(
                                                        "Share",
                                                        style: TextStyle(
                                                            fontSize: 13,
                                                            color:
                                                                Colors.black),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                5.verticalSpace,
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Send an application for 100 credits",
                                                      style: Get
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                              fontSize: 10),
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
                                  ),
                  ],
                ),
              ),
      ),
    );
  }

  _buildCard({bool shareView = false}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 15),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(128),
                  child: CachedNetworkImage(
                    height: 50,
                    width: 50,
                    imageUrl: controller.jobOpening.value?.employerDetails?.profilePic ?? "",
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
                        "${!controller.isReferredJob.value ? "Job By: " : ""}${controller.jobOpening.value?.employerDetails?.firstName ?? ""} ${controller.jobOpening.value?.employerDetails?.lastName ?? ""}",
                        overflow: TextOverflow.ellipsis,
                        style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                          controller.isReferredJob.value
                              ? "Referred job"
                              : controller.jobOpening.value?.employerDetails?.companyName ?? "",
                          overflow: TextOverflow.ellipsis,
                          // "Westline Ship Management Pvt. Ltd.",
                          style: Get.textTheme.bodySmall?.copyWith(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                      8.verticalSpace,
                      UserStates.instance.crewUser?.userTypeKey == 2
                          ? controller.followingJob.value == controller.jobOpening.value?.id
                              ? const CircularProgressIndicator()
                              : InkWell(
                                  onTap: () {
                                    if (controller.jobOpening.value?.employerDetails?.followStatus ==
                                        true) {
                                      return;
                                    }
                                    controller.followJob(
                                        controller.jobOpening.value?.employerDetails?.id, controller.jobOpening.value?.id);
                                  },
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/add.svg",
                                        color:
                                            controller.jobOpening.value?.employerDetails?.followStatus ==
                                                    true
                                                ? Colors.grey
                                                : null,
                                      ),
                                      4.horizontalSpace,
                                      const Text("Follow")
                                    ],
                                  ),
                                )
                          : const SizedBox()
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
                8.verticalSpace,
                Column(
                  children: [
                    Row(
                      children: [
                        Text("Tentative Joining Date: ",
                            style: Get.textTheme.bodyLarge),
                        Text(
                          controller.jobOpening.value!.tentativeJoining!,
                          style:
                              Get.textTheme.bodyMedium?.copyWith(fontSize: 14),
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
                                .firstWhereOrNull((e) => e.id == controller.jobOpening.value?.vesselId)
                                ?.name ??
                            ""),
                      ],
                    ),
                    Row(
                      children: [
                        Text("GRT: ", style: Get.textTheme.bodyLarge),
                        Text(controller.jobOpening.value?.gRT.toString() ?? "")
                      ],
                    ),
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.jobOpening.value?.jobRankWithWages
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
                                                    value: controller.jobOpening.value?.id ==
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
                                                              controller.jobOpening.value?.id ?? -1,
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
                if (controller.selectedRank.value?.key != controller.jobOpening.value?.id &&
                    controller.showErrorForJob.value == controller.jobOpening.value?.id)
                  Text("Please select atleast one rank",
                      style: Get.textTheme.bodySmall
                          ?.copyWith(color: Get.theme.colorScheme.error)),
                if (controller.jobOpening.value?.jobCoc != null && controller.jobOpening.value?.jobCoc?.isNotEmpty == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COC Requirements: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(controller.jobOpening.value?.jobCoc
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
                if (controller.jobOpening.value?.jobCop != null && controller.jobOpening.value?.jobCop?.isNotEmpty == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COP Requirements: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(controller.jobOpening.value?.jobCop
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
                if (controller.jobOpening.value?.jobWatchKeeping != null &&
                    controller.jobOpening.value?.jobWatchKeeping?.isNotEmpty == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Watch-Keeping Requirements: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(controller.jobOpening.value?.jobWatchKeeping
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
                if (controller.jobOpening.value?.mailInfo == true)
                  Row(
                    children: [
                      Text(
                        "Email: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        controller.jobOpening.value?.employerDetails?.email ?? "",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                if (controller.jobOpening.value?.numberInfo == true)
                  Row(
                    children: [
                      Text(
                        "Mobile: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        controller.jobOpening.value?.employerDetails?.number ?? "",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ],
                  ),
                4.verticalSpace,
                10.verticalSpace,
                if (!shareView)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.likingJob.value == controller.jobOpening.value?.id
                          ? const CircularProgressIndicator()
                          : TextButton.icon(
                              onPressed: () {
                                if (controller.jobOpening.value?.isJobLiked == true) {
                                  return;
                                }
                                controller.likeJob();
                              },
                              icon: Icon(
                                controller.jobOpening.value?.isJobLiked == true
                                    ? Icons.thumb_up_alt_rounded
                                    : Icons.thumb_up_alt_outlined,
                                size: 18,
                              ),
                              label: Text(
                                controller.jobOpening.value?.isJobLiked == true ? "Liked!" : "Like",
                                style: TextStyle(fontSize: 13),
                              )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          controller.applyingJob.value == controller.jobOpening.value?.id
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()],
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18))),
                                  onPressed: controller.applications.any((application) =>
                                                  application.jobId == controller.jobOpening.value?.id ||
                                                  application.jobData?.id ==
                                                      controller.jobOpening.value?.id) ==
                                              true ||
                                          controller.jobOpening.value?.jobRankWithWages?.none((rankWithWage) =>
                                                  rankWithWage.rankNumber ==
                                                      UserStates.instance
                                                          .crewUser?.rankId ||
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
                                          UserStates.instance.crewUser?.userTypeKey != 2
                                      ? null
                                      : () {
                                          if (UserStates.instance.crewUser
                                                  ?.isVerified !=
                                              1) {
                                            controller.fToast.safeShowToast(
                                                child: errorToast(
                                                    RemoteConfigUtils.instance.accountUnderVerificationCopy));
                                            return;
                                          }
                                          if (controller
                                                  .selectedRank.value?.key !=
                                              controller.jobOpening.value?.id) {
                                            controller.showErrorForJob.value =
                                                controller.jobOpening.value?.id;
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
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              actionsPadding:
                                                  const EdgeInsets.only(
                                                      bottom: 25),
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        Colors.black,
                                                    elevation: 3,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 35),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  child: const Text("NO"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    Get.back();
                                                    controller.apply(controller.jobOpening.value?.id);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 3,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 35),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
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
                                                application.jobId == controller.jobOpening.value?.id ||
                                                application.jobData?.id ==
                                                    controller.jobOpening.value?.id) ==
                                            true
                                        ? "APPLIED"
                                        : "APPLY NOW",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          controller.captureWidget();
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

  _buildMyCard({bool shareView = false}) {
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
                    imageUrl: controller
                            .jobOpening.value?.employerDetails?.profilePic ??
                        "",
                    fit: BoxFit.cover,
                  ),
                ),
                10.horizontalSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${controller.jobOpening.value?.employerDetails?.firstName ?? ""} ${controller.jobOpening.value?.employerDetails?.lastName ?? ""}",
                        overflow: TextOverflow.ellipsis,
                        style: Get.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                          controller.jobOpening.value?.employerDetails
                                  ?.companyName ??
                              "",
                          overflow: TextOverflow.ellipsis,
                          // "Westline Ship Management Pvt. Ltd.",
                          style: Get.textTheme.bodySmall?.copyWith(
                              fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                // const Spacer(),
                controller.jobIdBeingDeleted.value ==
                        controller.jobOpening.value?.id
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
                                          jobToEdit:
                                              controller.jobOpening.value))
                                  : Get.offNamed(Routes.JOB_POST,
                                      arguments: JobPostArguments(
                                          jobToEdit:
                                              controller.jobOpening.value));
                              return;
                            case 2:
                              controller.captureWidget();
                              return;
                            case 3:
                              controller.deleteJobPost();
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
                      controller.jobOpening.value?.tentativeJoining ?? "",
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
                            .firstWhereOrNull((e) =>
                                e.id == controller.jobOpening.value?.vesselId)
                            ?.name ??
                        ""),
                  ],
                ),
                Row(
                  children: [
                    Text("GRT: ", style: Get.textTheme.bodyLarge),
                    Text(controller.jobOpening.value?.gRT.toString() ?? "")
                  ],
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.jobOpening.value?.jobRankWithWages
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
                if (controller.jobOpening.value?.jobCoc != null &&
                    controller.jobOpening.value?.jobCoc?.isNotEmpty == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COC Requirements: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(controller.jobOpening.value?.jobCoc
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
                if (controller.jobOpening.value?.jobCop != null &&
                    controller.jobOpening.value?.jobCop?.isNotEmpty == true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "COP Requirements: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(controller.jobOpening.value?.jobCop
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
                if (controller.jobOpening.value?.jobWatchKeeping != null &&
                    controller.jobOpening.value?.jobWatchKeeping?.isNotEmpty ==
                        true)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Watch-Keeping Requirements: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(controller.jobOpening.value?.jobWatchKeeping
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
                if (controller.jobOpening.value?.mailInfo == true)
                  Row(
                    children: [
                      Text(
                        "Email: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        controller.jobOpening.value?.employerDetails?.email ??
                            "",
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                if (controller.jobOpening.value?.numberInfo == true)
                  Row(
                    children: [
                      Text(
                        "Mobile: ",
                        style: Get.textTheme.bodyLarge,
                      ),
                      Text(
                        controller.jobOpening.value?.employerDetails?.number ??
                            "",
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
                                                    " Likes ${controller.jobOpening.value?.likes}",
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
                      controller.highlightingJob.value ==
                              controller.jobOpening.value?.id
                          ? const CircularProgressIndicator()
                          : TextButton.icon(
                              onPressed: () async {
                                if (controller.jobOpening.value?.id == null) {
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
                                      controller.jobOpening.value?.id ?? -1,
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
                            " ${controller.jobOpening.value?.jobLikeCount}",
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: Colors.blue),
                          )),
                      TextButton.icon(
                        onPressed: () {
                          if (controller.jobOpening.value?.id == null) {
                            return;
                          }
                          controller
                              .boostJob(controller.jobOpening.value?.id ?? -1);
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
                                jobId: controller.jobOpening.value?.id)),
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

    _buildCrewReferralCard({bool shareView = false}) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Column(
        children: [
          if (controller.jobOpening.value != null)
          CrewReferralJobCard(job: controller.jobOpening.value!),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!shareView)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      controller.likingJob.value 
                          ? const CircularProgressIndicator()
                          : TextButton.icon(
                              onPressed: () {
                               
                                controller.likeJob();
                              },
                              icon: Icon(
                                controller.jobOpening.value?.isJobLiked == true
                                    ? Icons.thumb_up_alt_rounded
                                    : Icons.thumb_up_alt_outlined,
                                size: 18,
                              ),
                              label: Text(
                                controller.jobOpening.value?.isJobLiked == true ? "Liked!" : "Like",
                                style: TextStyle(fontSize: 13),
                              )),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          controller.applyingJob.value == controller.jobOpening.value?.id
                              ? const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [CircularProgressIndicator()],
                                )
                              : ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(18))),
                                  onPressed: controller.applications.any((application) =>
                                                  application.jobId == controller.jobOpening.value?.id ||
                                                  application.jobData?.id ==
                                                      controller.jobOpening.value?.id) ==
                                              true ||
                                          controller.jobOpening.value?.jobRankWithWages?.none((rankWithWage) =>
                                                  rankWithWage.rankNumber ==
                                                      UserStates.instance
                                                          .crewUser?.rankId ||
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
                                          UserStates.instance.crewUser?.userTypeKey != 2
                                      ? null
                                      : () {
                                          if (UserStates.instance.crewUser
                                                  ?.isVerified !=
                                              1) {
                                            controller.fToast.safeShowToast(
                                                child: errorToast(
                                                    RemoteConfigUtils.instance.accountUnderVerificationCopy));
                                            return;
                                          }
                                          controller.selectedRank.value =
                                              MapEntry(
                                                  controller.jobOpening.value?.id ?? -1,
                                                  controller.jobOpening.value
                                                          ?.jobRankWithWages
                                                          ?.firstOrNull
                                                          ?.rankNumber ??
                                                      -1);

                                          showDialog(
                                            context: Get.context!,
                                            barrierDismissible: false,
                                            builder: (context) => AlertDialog(
                                              shape: alertDialogShape,
                                              title: const Text(
                                                "Are You Sure ?",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.blue),
                                              ),
                                              actionsPadding:
                                                  const EdgeInsets.only(
                                                      bottom: 25),
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
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.white,
                                                    foregroundColor:
                                                        Colors.black,
                                                    elevation: 3,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 35),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                    ),
                                                  ),
                                                  child: const Text("NO"),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () async {
                                                    Get.back();
                                                    controller.apply(controller.jobOpening.value?.id);
                                                  },
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    elevation: 3,
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 35),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
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
                                                application.jobId == controller.jobOpening.value?.id ||
                                                application.jobData?.id ==
                                                    controller.jobOpening.value?.id) ==
                                            true
                                        ? "APPLIED"
                                        : "APPLY NOW",
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                ),
                        ],
                      ),
                      TextButton.icon(
                        onPressed: () {
                          controller.captureWidget();
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
