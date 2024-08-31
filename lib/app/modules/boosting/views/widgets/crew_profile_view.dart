import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:join_my_ship/app/data/models/boosting_model.dart';
import 'package:join_my_ship/app/modules/boosted_crew_profiles/controllers/boosted_crew_profiles_controller.dart';
import 'package:join_my_ship/app/modules/boosting/controllers/boosting_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:collection/collection.dart';
import 'package:lottie/lottie.dart';

class CrewProfileBoostingView extends GetView<BoostingController> {
  const CrewProfileBoostingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.crewPagingController.refresh();
      },
      child: PagedListView<int, Crew>(
        pagingController: controller.crewPagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, profile, index) {
            return InkWell(
              onTap: () {
                Get.toNamed(Routes.BOOSTED_CREW_PROFILES,
                    arguments: BoostedCrewProfilesArguments(
                        currentIndex: index,
                        boostedCrewList:
                            controller.crewPagingController.itemList));
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16.r),
                    color: Colors.white,
                    boxShadow: const [
                      BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.1),
                          blurRadius: 4,
                          spreadRadius: 1)
                    ]),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (profile.userBoost?.user?.profilePic != null)
                    CachedNetworkImage(
                      imageUrl: profile.userBoost?.user?.profilePic ?? "",
                      imageBuilder: (context, imageProvider) {
                        return Container(
                          height: 50.h,
                          width: 50.h,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: imageProvider, fit: BoxFit.cover),
                              shape: BoxShape.circle),
                        );
                      },
                    ),
                    20.horizontalSpace,
                    Flexible(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(profile.userBoost?.user?.firstName ?? "",
                              maxLines: 2,
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(controller.ranks
                                  .firstWhereOrNull((rank) =>
                                      rank.id ==
                                      profile.userBoost?.user?.rankId)
                                  ?.name ??
                              "")
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
          noItemsFoundIndicatorBuilder: (context) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/animations/no_results.json',
                  repeat: false,
                  height: 200,
                  width: 200,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
