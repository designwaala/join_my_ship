import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_cli/get_cli.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../controllers/job_openings_controller.dart';

class JobOpeningsView extends GetView<JobOpeningsController> {
  const JobOpeningsView({Key? key}) : super(key: key);

  _showBottomSheet(BuildContext context) {
    Map<String, dynamic> filters = {};
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: false,
      builder: (context) => Container(
        height: 350,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(35),
            topRight: Radius.circular(35),
          ),
        ),
        child: Column(
          children: [
            20.verticalSpace,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 35),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Container(
                            height: 4,
                            width: 35,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          8.verticalSpace,
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Flexible(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Rank>(
                              iconStyleData: const IconStyleData(
                                  icon: Icon(Icons.keyboard_arrow_down)),
                              hint: const Text(
                                "Select Rank",
                                style: TextStyle(fontSize: 14),
                              ),
                              buttonStyleData:
                                  const ButtonStyleData(height: 40, width: 130),
                              dropdownStyleData: const DropdownStyleData(
                                  maxHeight: 200, width: 130),
                              onChanged: (value) {
                                filters['rank'] = value;
                              },
                              items: controller.ranks
                                  .map(
                                    (value) => DropdownMenuItem<Rank>(
                                      value: value,
                                      child: Flexible(
                                        child: Text(
                                          value.name ?? "",
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                          ),
                        ),
                      ),
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
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.blue),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Flexible(
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton2<Vessel>(
                              iconStyleData: const IconStyleData(
                                  icon: Icon(Icons.keyboard_arrow_down)),
                              hint: const Text(
                                "Select",
                                style: TextStyle(fontSize: 14),
                              ),
                              buttonStyleData:
                                  const ButtonStyleData(height: 40, width: 130),
                              dropdownStyleData: const DropdownStyleData(
                                  maxHeight: 140, width: 130),
                              onChanged: (value) {
                                filters['vessel'] = value;
                              },
                              items: controller.vesselList?.vessels
                                  ?.map(
                                    (value) => DropdownMenuItem<Vessel>(
                                      value: value,
                                      child: Flexible(
                                        child: Text(
                                          value.vesselName ?? "",
                                          maxLines: 2,
                                        ),
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
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
              padding: const EdgeInsets.symmetric(horizontal: 40),
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
                      controller.filterOn.value = true;
                      controller.applyFilters(filters: filters);
                      Get.back();
                    },
                    child: const Text("Save"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ).then((value) {
      debugPrint("ModalBottomSheet Closed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Jobs',
            style: Get.theme.textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        leading: InkWell(
          onTap: Get.back,
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
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const CircularProgressIndicatorWidget()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Job Openings",
                            style:
                                Get.textTheme.bodyLarge?.copyWith(fontSize: 16),
                          ),
                          IconButton(
                            onPressed: () {
                              if (!controller.filterOn.value) {
                                _showBottomSheet(context);
                              } else {
                                controller.filterOn.value = false;
                                controller.removeFilters();
                              }
                            },
                            icon: ImageIcon(
                              const AssetImage("assets/icons/equalizer.png"),
                              size: 24,
                              color: controller.filterOn.value
                                  ? Colors.blue
                                  : Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                    controller.jobOpenings.isEmpty
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
                        : Flexible(
                            child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              itemCount: controller.jobOpenings.length,
                              itemBuilder: (context, index) => Obx(
                                () {
                                  return controller.jobOpenings.isEmpty
                                      ? const Center(
                                          child: Text("No jobs posted"))
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: Card(
                                            elevation: 5,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15, top: 15),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(128),
                                                        child: CachedNetworkImage(
                                                            height: 50,
                                                            width: 50,
                                                            imageUrl: controller
                                                                    .jobOpenings[
                                                                        index]
                                                                    .employerDetails
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
                                                              "${!controller.isReferredJob.value ? "JOB BY: " : ""}${controller.jobOpenings[index].employerDetails?.firstName ?? ""} ${controller.jobOpenings[index].employerDetails?.lastName ?? ""}",
                                                              overflow:
                                                                  TextOverflow
                                                                      .ellipsis,
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyMedium
                                                                  ?.copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          16),
                                                            ),
                                                            Text(
                                                                controller
                                                                        .isReferredJob
                                                                        .value
                                                                    ? "Referred job"
                                                                    : controller
                                                                            .jobOpenings[
                                                                                index]
                                                                            .employerDetails
                                                                            ?.username ??
                                                                        "",
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                                // "Westline Ship Management Pvt. Ltd.",
                                                                style: Get
                                                                    .textTheme
                                                                    .bodySmall
                                                                    ?.copyWith(
                                                                        fontSize:
                                                                            11,
                                                                        fontWeight:
                                                                            FontWeight.bold)),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 25,
                                                      vertical: 10),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      if (!controller
                                                          .isReferredJob.value)
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          children: [
                                                            TextButton.icon(
                                                              onPressed: () {},
                                                              icon: const Icon(
                                                                Icons.add,
                                                                size: 20,
                                                              ),
                                                              label: const Text(
                                                                  "Follow"),
                                                              style: TextButton
                                                                  .styleFrom(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .only(
                                                                        left: 8,
                                                                        right:
                                                                            15),
                                                                foregroundColor:
                                                                    Colors
                                                                        .white,
                                                                backgroundColor:
                                                                    Colors.blue,
                                                                shape:
                                                                    RoundedRectangleBorder(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              20),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      !controller.isReferredJob
                                                              .value
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
                                                                          .jobOpenings[
                                                                              index]
                                                                          .tentativeJoining!,
                                                                      style: Get
                                                                          .textTheme
                                                                          .bodyMedium
                                                                          ?.copyWith(
                                                                              fontSize: 14),
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
                                                                //                 controller.vesselList?.vessels?.map((e) => e.subVessels ?? []).expand((e) => e).firstWhereOrNull((e) => e.id == controller.jobOpenings[index].vesselId)?.name ?? ""),
                                                                //       ],
                                                                //     ),
                                                                //   ),
                                                                // ),
                                                                Row(
                                                                  children: [
                                                                    Flexible(
                                                                      child: Text(
                                                                          "Vessel Type: ",
                                                                          maxLines:
                                                                              2,
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
                                                                            .expand((e) =>
                                                                                e)
                                                                            .firstWhereOrNull((e) =>
                                                                                e.id ==
                                                                                controller.jobOpenings[index].vesselId)
                                                                            ?.name ??
                                                                        ""),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "GRT: ",
                                                                        style: Get
                                                                            .textTheme
                                                                            .bodyLarge),
                                                                    Text(controller
                                                                        .jobOpenings[
                                                                            index]
                                                                        .gRT
                                                                        .toString())
                                                                  ],
                                                                ),
                                                              ],
                                                            )
                                                          : Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "Rank: ",
                                                                        style: Get
                                                                            .textTheme
                                                                            .bodyLarge),
                                                                    const Text(
                                                                        "Second Engineer"
                                                                        // controller
                                                                        //   .jobOpenings[index]
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
                                                                        // .jobOpenings[index]
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
                                                                            .expand((e) =>
                                                                                e)
                                                                            .firstWhereOrNull((e) =>
                                                                                e.id ==
                                                                                controller.jobOpenings[index].vesselId)
                                                                            ?.name ??
                                                                        ""),
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    Text(
                                                                        "Flag: ",
                                                                        style: Get
                                                                            .textTheme
                                                                            .bodyLarge),
                                                                    const Text(
                                                                        "INDIA"
                                                                        // controller
                                                                        // .jobOpenings[index]
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
                                                                      // .jobOpenings[index]
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
                                                                          .jobOpenings[
                                                                              index]
                                                                          .tentativeJoining
                                                                          .toString(),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 10,
                                                                vertical: 3),
                                                        child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: controller
                                                                    .jobOpenings[
                                                                        index]
                                                                    .jobRankWithWages
                                                                    ?.map((rankWithWages) =>
                                                                        Padding(
                                                                          padding:
                                                                              const EdgeInsets.symmetric(vertical: 3),
                                                                          child:
                                                                              Row(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.start,
                                                                            children: [
                                                                              const Icon(
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
                                                      if (controller
                                                                  .jobOpenings[
                                                                      index]
                                                                  .jobCoc !=
                                                              null &&
                                                          controller
                                                                  .jobOpenings[
                                                                      index]
                                                                  .jobCoc
                                                                  ?.isNotEmpty ==
                                                              true)
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "COC Requirements: ",
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyLarge,
                                                            ),
                                                            Text(controller
                                                                    .jobOpenings[
                                                                        index]
                                                                    .jobCoc
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
                                                      if (controller
                                                                  .jobOpenings[
                                                                      index]
                                                                  .jobCop !=
                                                              null &&
                                                          controller
                                                                  .jobOpenings[
                                                                      index]
                                                                  .jobCop
                                                                  ?.isNotEmpty ==
                                                              true)
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "COP Requirements: ",
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyLarge,
                                                            ),
                                                            Text(controller
                                                                    .jobOpenings[
                                                                        index]
                                                                    .jobCop
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
                                                      if (controller
                                                                  .jobOpenings[
                                                                      index]
                                                                  .jobWatchKeeping !=
                                                              null &&
                                                          controller
                                                                  .jobOpenings[
                                                                      index]
                                                                  .jobWatchKeeping
                                                                  ?.isNotEmpty ==
                                                              true)
                                                        Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Text(
                                                              "Watch-Keeping Requirements: ",
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyLarge,
                                                            ),
                                                            Text(controller
                                                                    .jobOpenings[
                                                                        index]
                                                                    .jobWatchKeeping
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
                                                      if (controller
                                                              .jobOpenings[
                                                                  index]
                                                              .mailInfo ==
                                                          true)
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Email: ",
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyLarge,
                                                            ),
                                                            Text(
                                                              controller
                                                                      .jobOpenings[
                                                                          index]
                                                                      .employerDetails
                                                                      ?.email ??
                                                                  "",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13),
                                                            ),
                                                          ],
                                                        ),
                                                      if (controller
                                                              .jobOpenings[
                                                                  index]
                                                              .numberInfo ==
                                                          true)
                                                        Row(
                                                          children: [
                                                            Text(
                                                              "Mobile: ",
                                                              style: Get
                                                                  .textTheme
                                                                  .bodyLarge,
                                                            ),
                                                            Text(
                                                              controller
                                                                      .jobOpenings[
                                                                          index]
                                                                      .employerDetails
                                                                      ?.number ??
                                                                  "",
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          13),
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
                                                          " Likes ${controller.jobOpenings[index].likes}",
                                                          style: Get
                                                              .textTheme.bodyMedium
                                                              ?.copyWith(
                                                                  color: Colors.blue),
                                                        )),
                                                  ],
                                                ), */
                                                      10.verticalSpace,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          TextButton.icon(
                                                              onPressed: () {
                                                                // TODO: Like
                                                              },
                                                              icon: const Icon(
                                                                Icons
                                                                    .thumb_up_alt_outlined,
                                                                size: 18,
                                                              ),
                                                              label: const Text(
                                                                "Like",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        13),
                                                              )),
                                                          ElevatedButton(
                                                            style: ElevatedButton.styleFrom(
                                                                padding: const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        20),
                                                                shape: RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            18))),
                                                            onPressed: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    false,
                                                                builder:
                                                                    (context) =>
                                                                        AlertDialog(
                                                                  title:
                                                                      const Text(
                                                                    "Are You Sure ?",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: TextStyle(
                                                                        color: Colors
                                                                            .blue),
                                                                  ),
                                                                  shape:
                                                                      RoundedRectangleBorder(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            20),
                                                                  ),
                                                                  actionsPadding:
                                                                      const EdgeInsets
                                                                              .only(
                                                                          bottom:
                                                                              25),
                                                                  content:
                                                                      const Text(
                                                                    "Are you sure you want to use your 100 credits?",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          14.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w600,
                                                                    ),
                                                                  ),
                                                                  actionsAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  actions: [
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          Get.back,
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        backgroundColor:
                                                                            Colors.white,
                                                                        foregroundColor:
                                                                            Colors.black,
                                                                        elevation:
                                                                            3,
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 35),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                      ),
                                                                      child: const Text(
                                                                          "NO"),
                                                                    ),
                                                                    ElevatedButton(
                                                                      onPressed:
                                                                          () =>
                                                                              Get.offAndToNamed(Routes.JOB_APPLIED_SUCCESSFULLY),
                                                                      style: ElevatedButton
                                                                          .styleFrom(
                                                                        elevation:
                                                                            3,
                                                                        padding:
                                                                            const EdgeInsets.symmetric(horizontal: 35),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(20),
                                                                        ),
                                                                      ),
                                                                      child: const Text(
                                                                          "YES"),
                                                                    ),
                                                                  ],
                                                                ),
                                                              );
                                                            },
                                                            child: const Text(
                                                              "APPLY NOW",
                                                              style: TextStyle(
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                          TextButton.icon(
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                              Icons.share_sharp,
                                                              size: 18,
                                                              color:
                                                                  Colors.black,
                                                            ),
                                                            label: const Text(
                                                              "Share",
                                                              style: TextStyle(
                                                                  fontSize: 13,
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      5.verticalSpace,
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            "Send an application for 100 credits",
                                                            style: Get.textTheme
                                                                .bodySmall
                                                                ?.copyWith(
                                                                    fontSize:
                                                                        10),
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
                                },
                              ),
                            ),
                          ),
                  ],
                ),
              ),
      ),
    );
  }
}
