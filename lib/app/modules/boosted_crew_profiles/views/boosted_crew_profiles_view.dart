import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/boosted_crew_profiles/bindings/boosted_crew_profiles_binding.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/extensions/string_extensions.dart';
import 'package:story_view/widgets/story_view.dart';

import '../controllers/boosted_crew_profiles_controller.dart';

class BoostedCrewProfilesView extends GetView<BoostedCrewProfilesController> {
  @override
  final String? tag;

  const BoostedCrewProfilesView({Key? key, this.tag}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          bottom: PreferredSize(
              preferredSize: const Size.fromHeight(64),
              child: Obx(() {
                return controller.isLoading.value
                    ? const SizedBox()
                    : Column(
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
                                  imageUrl: controller.boostedCrew?.userBoost
                                          ?.user?.profilePic ??
                                      "",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              12.horizontalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      "${controller.boostedCrew?.userBoost?.user?.firstName ?? ""} ${controller.boostedCrew?.userBoost?.user?.lastName ?? ""}",
                                      style: Get.textTheme.titleMedium
                                          ?.copyWith(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold)),
                                  Text(
                                      controller.ranks
                                              .firstWhereOrNull((rank) =>
                                                  rank.id ==
                                                  controller.boostedCrew
                                                      ?.userBoost?.user?.rankId)
                                              ?.name ??
                                          "",
                                      style: Get.textTheme.bodyMedium
                                          ?.copyWith(color: Colors.white))
                                ],
                              )
                            ],
                          ),
                          24.verticalSpace
                        ],
                      );
              })),
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : StoryView(
                  onComplete: () {
                    if (((controller.args?.currentIndex ?? 0) + 1) <
                        (controller.args?.boostedCrewList?.length ?? 0)) {
                      Get.back();
                      Get.to(
                          () => BoostedCrewProfilesView(
                              tag: controller.args?.currentIndex?.toString()),
                          arguments: BoostedCrewProfilesArguments(
                              boostedCrewList: controller.args?.boostedCrewList,
                              currentIndex:
                                  (controller.args?.currentIndex ?? 0) + 1),
                          binding: BoostedTagCrewProfilesBinding(
                              controller.args?.currentIndex?.toString() ?? ""),
                          preventDuplicates: true);
                      /* Get.offNamed(Routes.BOOSTED_CREW_PROFILES,
                          arguments: BoostedCrewProfilesArguments(
                              boostedCrewList: controller.args?.boostedCrewList,
                              currentIndex:
                                  (controller.args?.currentIndex ?? 0) + 1)); */
                    } else {
                      Get.back();
                    }
                  },
                  controller: controller.storyController,
                  indicatorColor: const Color(0xFFDADADA),
                  indicatorForegroundColor: const Color(0xFFFE9738),
                  storyItems: [
                    StoryItem(
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Column(
                          children: [
                            48.verticalSpace,
                            Column(
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Name",
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.bold)),
                                      Text(
                                          controller.boostedCrew?.userBoost
                                                  ?.user?.firstName ??
                                              "",
                                          style: Get.textTheme.bodyMedium)
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Rank",
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.bold)),
                                      Text(
                                          controller.ranks
                                                  .firstWhereOrNull((rank) =>
                                                      rank.id ==
                                                      controller
                                                          .boostedCrew
                                                          ?.userBoost
                                                          ?.user
                                                          ?.rankId)
                                                  ?.name ??
                                              "",
                                          style: Get.textTheme.bodyMedium)
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Looking For Promotion",
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.bold)),
                                      Text(
                                          controller
                                                      .boostedCrew
                                                      ?.userBoost
                                                      ?.user
                                                      ?.promotionApplied ==
                                                  true
                                              ? "Yes"
                                              : "No",
                                          style: Get.textTheme.bodyMedium)
                                    ]),
                                if (controller
                                        .boostedCrew?.userBoost?.user?.dob !=
                                    null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Date Of Birth",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        Text(
                                            controller.boostedCrew?.userBoost
                                                    ?.user?.dob ??
                                                "",
                                            style: Get.textTheme.bodyMedium)
                                      ]),
                                if (controller
                                        .boostedCrew?.userBoost?.user?.gender !=
                                    null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Gender",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        Text(
                                            genderMap[controller
                                                        .boostedCrew
                                                        ?.userBoost
                                                        ?.user
                                                        ?.gender ??
                                                    -1] ??
                                                "",
                                            style: Get.textTheme.bodyMedium)
                                      ]),
                                if (controller.boostedCrew?.userBoost?.user
                                        ?.maritalStatus !=
                                    null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Marital Status",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        Text(
                                            maritalStatuses[controller
                                                    .boostedCrew
                                                    ?.userBoost
                                                    ?.user
                                                    ?.maritalStatus] ??
                                                "",
                                            style: Get.textTheme.bodyMedium)
                                      ]),
                                if (controller.boostedCrew?.userBoost?.user
                                        ?.countryId !=
                                    null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Nationality",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        Text(
                                            controller.countries
                                                    .firstWhereOrNull(
                                                        (country) =>
                                                            country.id ==
                                                            controller
                                                                .boostedCrew
                                                                ?.userBoost
                                                                ?.user
                                                                ?.countryId)
                                                    ?.countryName ??
                                                "",
                                            style: Get.textTheme.bodyMedium)
                                      ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("Passport",
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.bold)),
                                      Text(
                                          controller
                                                  .boostedCrew
                                                  ?.userBoost
                                                  ?.passportIssuingAuthority
                                                  ?.customName ??
                                              controller
                                                  .boostedCrew
                                                  ?.userBoost
                                                  ?.passportIssuingAuthority
                                                  ?.issuingAuthority ??
                                              "",
                                          style: Get.textTheme.bodyMedium)
                                    ]),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text("STCW",
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(
                                                  color: Get.theme.primaryColor,
                                                  fontWeight: FontWeight.bold)),
                                      Text(
                                          controller.boostedCrew?.userBoost
                                                  ?.sTCWIssuingAuthority
                                                  ?.map((e) =>
                                                      e.issuingAuthority ??
                                                      e.customName)
                                                  .join(", ") ??
                                              "",
                                          style: Get.textTheme.bodyMedium)
                                    ]),
                                if (controller.boostedCrew?.userBoost
                                        ?.cdcIssuingAuthority !=
                                    null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("CDC",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        Text(
                                            controller
                                                    .boostedCrew
                                                    ?.userBoost
                                                    ?.cdcIssuingAuthority
                                                    ?.customName ??
                                                controller
                                                    .boostedCrew
                                                    ?.userBoost
                                                    ?.cdcIssuingAuthority
                                                    ?.issuingAuthority ??
                                                "",
                                            style: Get.textTheme.bodyMedium)
                                      ]),
                                if (controller.boostedCrew?.userBoost
                                        ?.validCOCIssuingAuthority
                                        ?.nullIfEmpty() !=
                                    null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("COC",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        Text(
                                            controller.boostedCrew?.userBoost
                                                    ?.validCOCIssuingAuthority
                                                    ?.map((e) =>
                                                        e.issuingAuthority ??
                                                        e.customName)
                                                    .join(", ") ??
                                                "",
                                            style: Get.textTheme.bodyMedium)
                                      ]),
                                if (controller.boostedCrew?.userBoost
                                        ?.validCOPIssuingAuthority
                                        ?.nullIfEmpty() !=
                                    null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("COP",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        Text(
                                            controller.boostedCrew?.userBoost
                                                    ?.validCOPIssuingAuthority
                                                    ?.map((e) =>
                                                        e.issuingAuthority ??
                                                        e.customName)
                                                    .join(", ") ??
                                                "",
                                            style: Get.textTheme.bodyMedium)
                                      ]),
                                if (controller.boostedCrew?.userBoost
                                        ?.validWatchKeepingIssuingAuthority
                                        ?.nullIfEmpty() !=
                                    null)
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Watch Keeping",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color:
                                                        Get.theme.primaryColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                        Text(
                                            controller.boostedCrew?.userBoost
                                                    ?.validWatchKeepingIssuingAuthority
                                                    ?.map((e) =>
                                                        e.issuingAuthority ??
                                                        e.customName)
                                                    .join(", ") ??
                                                "",
                                            style: Get.textTheme.bodyMedium)
                                      ]),
                              ]
                                  .map((e) => Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 16),
                                      child: e))
                                  .toList(),
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12))),
                                    onPressed: () {},
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 32),
                                      child: Row(
                                        children: [
                                          Icon(Icons.visibility_outlined),
                                          4.horizontalSpace,
                                          Text("View Profile")
                                        ],
                                      ),
                                    )),
                                InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 3,
                                              color: Get.theme.primaryColor)),
                                      child: Container(
                                          padding: EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                              color: Get.theme.primaryColor,
                                              shape: BoxShape.circle),
                                          child: Icon(Icons.arrow_forward,
                                              color: Colors.white)),
                                    ))
                              ],
                            ),
                            32.verticalSpace,
                          ],
                        ),
                      ),
                      duration: const Duration(seconds: kDebugMode ? 1 : 15),
                    )
                  ],
                );
        }));
  }
}
