import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/boosted_crew_profiles/controllers/boosted_crew_profiles_controller.dart';
import 'package:join_mp_ship/app/modules/boosting/controllers/boosting_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:collection/collection.dart';

class CrewProfileBoostingView extends GetView<BoostingController> {
  const CrewProfileBoostingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.getBoostings();
      },
      child: ListView(
          children: controller.crewBoostings.value?.results
                  ?.mapIndexed(
                    (index, profile) => InkWell(
                      onTap: () {
                        Get.toNamed(Routes.BOOSTED_CREW_PROFILES,
                            arguments: BoostedCrewProfilesArguments(
                                currentIndex: index,
                                boostedCrewList:
                                    controller.crewBoostings.value?.results));
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
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
                            CachedNetworkImage(
                              imageUrl:
                                  profile.userBoost?.user?.profilePic ?? "",
                              imageBuilder: (context, imageProvider) {
                                return Container(
                                  height: 50.h,
                                  width: 50.h,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover),
                                      shape: BoxShape.circle),
                                );
                              },
                            ),
                            20.horizontalSpace,
                            Flexible(
                              child: Column(
                                children: [
                                  Text(profile.userBoost?.user?.firstName ?? "",
                                      maxLines: 2,
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
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
                    ),
                  )
                  .toList() ??
              []),
    );
  }
}
