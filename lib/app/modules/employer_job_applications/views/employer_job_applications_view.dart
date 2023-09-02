import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/modules/applicant_detail/controllers/applicant_detail_controller.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:join_mp_ship/widgets/dropdown_decoration.dart';
import 'package:lottie/lottie.dart';
import '../controllers/employer_job_applications_controller.dart';

class EmployerJobApplicationsView
    extends GetView<EmployerJobApplicationsController> {
  const EmployerJobApplicationsView({Key? key}) : super(key: key);

  _showBottomSheet(BuildContext context) {
    controller.toApplyRanks.value = [...controller.selectedRanks];
    controller.toApplyGenderFilter.value = controller.genderFilter.value;
    controller.toApplyIsShortlisted.value = controller.isShortlisted.value;
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: false,
      builder: (context) => Obx(
        () => Container(
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
                              width: 64,
                              decoration: BoxDecoration(
                                color: Colors.grey[400],
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
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                controller.toApplyIsShortlisted.value == true
                                    ? Colors.blue
                                    : Colors.black,
                            backgroundColor:
                                controller.toApplyIsShortlisted.value == true
                                    ? const Color.fromARGB(255, 227, 231, 249)
                                    : Colors.white,
                            side: const BorderSide(
                                width: 1.5, color: Colors.blue),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            if (controller.toApplyIsShortlisted.value == true) {
                              controller.toApplyIsShortlisted.value = null;
                            } else {
                              controller.toApplyIsShortlisted.value = true;
                            }
                          },
                          child: Row(
                            children: [
                              if (controller.toApplyIsShortlisted.value ==
                                  true) ...[
                                const Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                                4.horizontalSpace
                              ],
                              const Text(
                                "Shortlisted",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        1.horizontalSpace,
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor:
                                controller.toApplyIsShortlisted.value == false
                                    ? Colors.blue
                                    : Colors.black,
                            backgroundColor:
                                controller.toApplyIsShortlisted.value == false
                                    ? const Color.fromARGB(255, 227, 231, 249)
                                    : Colors.white,
                            side: const BorderSide(
                                width: 1.5, color: Colors.blue),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            if (controller.toApplyIsShortlisted.value ==
                                false) {
                              controller.toApplyIsShortlisted.value = null;
                            } else {
                              controller.toApplyIsShortlisted.value = false;
                            }
                          },
                          child: Row(
                            children: [
                              if (controller.toApplyIsShortlisted.value ==
                                  false) ...[
                                const Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                                4.horizontalSpace
                              ],
                              const Text(
                                "Not Shortlisted",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
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
                                              overflow: TextOverflow.ellipsis,
                                              style: Get.textTheme.titleMedium),
                                        ),
                                      ],
                                    )))
                                .toList(),
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
                          "Gender",
                          style: Get.textTheme.bodyLarge
                              ?.copyWith(color: Colors.blue, fontSize: 18),
                        ),
                        DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            hint: const Text(
                              "Select Gender",
                              style: TextStyle(fontSize: 14),
                            ),
                            buttonStyleData: ButtonStyleData(
                                height: 40,
                                width: 200,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: DropdownDecoration()),
                            onChanged: (value) {},
                            items: genderMap.keys
                                .map(
                                  (value) => DropdownMenuItem<int>(
                                    value: value,
                                    onTap: () {
                                      if (controller
                                              .toApplyGenderFilter.value ==
                                          value) {
                                        controller.toApplyGenderFilter.value =
                                            null;
                                      } else {
                                        controller.toApplyGenderFilter.value =
                                            value;
                                      }
                                    },
                                    child: Obx(() {
                                      return Row(
                                        children: [
                                          Icon(
                                              controller.toApplyGenderFilter
                                                          .value ==
                                                      value
                                                  ? Icons.radio_button_checked
                                                  : Icons.radio_button_off,
                                              color: Get.theme.primaryColor),
                                          8.horizontalSpace,
                                          Text(
                                            genderMap[value] ?? "",
                                            maxLines: 2,
                                          ),
                                        ],
                                      );
                                    }),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              30.verticalSpace,
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
                        controller.filterOn.value = false;
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                    10.horizontalSpace,
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
                        controller.genderFilter.value =
                            controller.toApplyGenderFilter.value;
                        controller.isShortlisted.value =
                            controller.toApplyIsShortlisted.value;
                        controller.filterOn.value = true;
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
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Applications'),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const CircularProgressIndicatorWidget()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                      title: Text(
                        "Job Applications",
                        style: Get.textTheme.bodyLarge?.copyWith(fontSize: 19),
                      ),
                      subtitle: Text(
                          "${controller.jobApplications.length} Applications Received"),
                      trailing: IconButton(
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
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        alignment: WrapAlignment.start,
                        children: [
                          if (controller.isShortlisted.value == true)
                            Chip(
                              label: Text("Shortlisted"),
                              backgroundColor: Colors.blue[100],
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      color: Get.theme.primaryColor)),
                              onDeleted: () {
                                controller.isShortlisted.value = null;
                                controller.applyFilters();
                              },
                            ),
                          if (controller.isShortlisted.value == false)
                            Chip(
                              label: Text("Not Shortlisted"),
                              backgroundColor: Colors.blue[100],
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      color: Get.theme.primaryColor)),
                              onDeleted: () {
                                controller.isShortlisted.value = null;
                                controller.applyFilters();
                              },
                            ),
                          ...controller.selectedRanks.map((rank) => Chip(
                              onDeleted: () {
                                controller.selectedRanks
                                    .removeWhere((e) => e == rank);
                                controller.applyFilters();
                              },
                              backgroundColor: Colors.blue[100],
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      color: Get.theme.primaryColor)),
                              label: Text(controller.ranks
                                      .firstWhereOrNull((e) => e.id == rank)
                                      ?.name ??
                                  ""))),
                          if (controller.genderFilter.value != null)
                            Chip(
                              label: Text(
                                  genderMap[controller.genderFilter.value] ??
                                      ""),
                              backgroundColor: Colors.blue[100],
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      color: Get.theme.primaryColor)),
                              onDeleted: () {
                                controller.genderFilter.value = null;
                                controller.applyFilters();
                              },
                            ),
                        ]),
                  ),
                  controller.jobApplications.isEmpty
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
                                "No Results Found!",
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      : Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            itemCount: controller.jobApplications.length,
                            itemBuilder: (context, index) => Card(
                              elevation: 3,
                              shadowColor:
                                  const Color.fromARGB(255, 237, 233, 241),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: InkWell(
                                onTap: () {
                                  Get.toNamed(Routes.APPLICANT_DETAIL,
                                      arguments: ApplicantDetailArguments(
                                          userId: controller
                                              .jobApplications[index]
                                              .userData
                                              ?.id,
                                          application: controller
                                              .jobApplications[index]));
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(128),
                                        child: CachedNetworkImage(
                                            imageUrl: controller
                                                    .jobApplications[index]
                                                    .userData
                                                    ?.profilePic ??
                                                "",
                                            height: 55,
                                            fit: BoxFit.cover,
                                            width: 55),
                                      ),
                                      8.horizontalSpace,
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              controller.jobApplications[index]
                                                      .userData?.firstName ??
                                                  "",
                                              style: Get.textTheme.bodyLarge
                                                  ?.copyWith(fontSize: 16),
                                            ),
                                            2.verticalSpace,
                                            Wrap(
                                              alignment:
                                                  WrapAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                  controller.ranks
                                                          .firstWhereOrNull(
                                                              (rank) =>
                                                                  rank.id ==
                                                                  controller
                                                                      .jobApplications[
                                                                          index]
                                                                      .userData
                                                                      ?.rankId)
                                                          ?.name ??
                                                      "",
                                                  style:
                                                      Get.textTheme.bodyMedium,
                                                ),
                                                SizedBox(width: 6),
                                                RichText(
                                                  text: TextSpan(
                                                    children: [
                                                      if (controller
                                                              .jobApplications[
                                                                  index]
                                                              .userDetails
                                                              ?.validCOCIssuingAuthority
                                                              ?.isNotEmpty ==
                                                          true) ...[
                                                        TextSpan(
                                                            text: "COC: ",
                                                            style: Get.textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                        TextSpan(
                                                            text: controller
                                                                    .jobApplications[
                                                                        index]
                                                                    .userDetails
                                                                    ?.validCOCIssuingAuthority
                                                                    ?.map((e) =>
                                                                        e.issuingAuthority ??
                                                                        e
                                                                            .customName)
                                                                    .join(
                                                                        ", ") ??
                                                                "",
                                                            style: Get.textTheme
                                                                .bodyMedium),
                                                      ],
                                                      if (controller
                                                              .jobApplications[
                                                                  index]
                                                              .userDetails
                                                              ?.validWatchKeepingIssuingAuthority
                                                              ?.isNotEmpty ==
                                                          true) ...[
                                                        TextSpan(
                                                            text: "WKC: ",
                                                            style: Get.textTheme
                                                                .bodyMedium
                                                                ?.copyWith(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold)),
                                                        TextSpan(
                                                            text: controller
                                                                    .jobApplications[
                                                                        index]
                                                                    .userDetails
                                                                    ?.validWatchKeepingIssuingAuthority
                                                                    ?.map((e) =>
                                                                        e.issuingAuthority ??
                                                                        e
                                                                            .customName)
                                                                    .join(
                                                                        ", ") ??
                                                                "",
                                                            style: Get.textTheme
                                                                .bodyMedium),
                                                      ]
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: controller
                                                    .applicationShortListing
                                                    .value ==
                                                controller
                                                    .jobApplications[index].id
                                            ? null
                                            : () {
                                                controller.shortListApplication(
                                                    controller
                                                        .jobApplications[index]
                                                        .id);
                                              },
                                        icon: Obx(() {
                                          return controller
                                                      .applicationShortListing
                                                      .value ==
                                                  controller
                                                      .jobApplications[index].id
                                              ? const Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                        height: 16,
                                                        width: 16,
                                                        child:
                                                            CircularProgressIndicator())
                                                  ],
                                                )
                                              : ImageIcon(
                                                  AssetImage(controller
                                                              .jobApplications[
                                                                  index]
                                                              .shortlistedStatus ==
                                                          true
                                                      ? 'assets/icons/bookmark_filled.png'
                                                      : 'assets/icons/bookmark_outlined.png'),
                                                  color: controller
                                                              .jobApplications[
                                                                  index]
                                                              .shortlistedStatus ==
                                                          true
                                                      ? Colors.blue
                                                      : Colors.black,
                                                  size: controller
                                                              .jobApplications[
                                                                  index]
                                                              .shortlistedStatus ==
                                                          true
                                                      ? 30
                                                      : 29,
                                                );
                                        }),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ],
              ),
      ),
    );
  }
}
