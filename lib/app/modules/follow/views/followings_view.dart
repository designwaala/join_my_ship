import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/follow_model.dart';
import 'package:join_mp_ship/app/modules/applicant_detail/controllers/applicant_detail_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:lottie/lottie.dart';

import '../controllers/followings_controller.dart';

class FollowingsView extends GetView<FollowingsController> {
  const FollowingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Get.theme.primaryColor,
          foregroundColor: Colors.white,
          title: Text(controller.args?.viewType == FollowViewType.following
              ? 'Followings'
              : controller.args?.viewType == FollowViewType.followers
                  ? 'Followers'
                  : 'Saved Profiles'),
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.follows.isEmpty
                  ? Center(
                      child: Lottie.asset(
                        'assets/animations/no_results.json',
                        repeat: false,
                        height: 200,
                        width: 200,
                      ),
                    )
                  : Column(
                      children: [
                        if ([FollowViewType.followers, FollowViewType.following]
                            .contains(controller.args?.viewType)) ...[
                          20.verticalSpace,
                          Row(
                            children: [
                              24.horizontalSpace,
                              SvgPicture.asset("assets/icons/user_add.svg"),
                              8.horizontalSpace,
                              Text(
                                  "${controller.follows.length} ${controller.args?.viewType == FollowViewType.followers ? "Followers" : "Following"}",
                                  style: Get.textTheme.bodyMedium
                                      ?.copyWith(color: Color(0xFFFE9738)))
                            ],
                          ),
                        ],
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            itemBuilder: (BuildContext context, int index) {
                              Follow? e = controller.follows[index];
                              return _userCard(e.userDetails!, e.id);
                            },
                            itemCount: controller.follows.length,
                            separatorBuilder:
                                (BuildContext context, int index) {
                              return Divider();
                            },
                          ),
                        ),
                      ],
                    );
        }));
  }

  Widget _userCard(CrewUser user, int? followId) {
    return InkWell(
      onTap: () {
        Get.toNamed(Routes.APPLICANT_DETAIL,
            arguments: ApplicantDetailArguments(
                userId: user.id, viewType: ViewType.crewDetail));
      },
      child: SizedBox(
        /*  margin: const EdgeInsets.only(bottom: 12),
        elevation: 3,
        shadowColor: const Color.fromARGB(255, 237, 233, 241),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), */
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(128),
                child: CachedNetworkImage(
                    imageUrl: user.profilePic ?? "",
                    height: 40,
                    fit: BoxFit.cover,
                    width: 40),
              ),
              8.horizontalSpace,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${user.firstName ?? ""} ${user.lastName ?? ""}",
                      style: Get.textTheme.bodyLarge?.copyWith(fontSize: 16),
                    ),
                    2.verticalSpace,
                    Text(
                        controller.args?.viewType == FollowViewType.following
                            ? (user.companyName ?? "")
                            : (UserStates.instance.ranks
                                    ?.firstWhereOrNull(
                                        (rank) => rank.id == user.rankId)
                                    ?.name ??
                                ""),
                        style: Get.textTheme.bodySmall
                            ?.copyWith(fontWeight: FontWeight.bold))
                  ],
                ),
              ),
              if ([FollowViewType.following, FollowViewType.savedProfile]
                  .contains(controller.args?.viewType))
                controller.unfollowId.value == followId
                    ? const SizedBox(
                        height: 16,
                        width: 16,
                        child: CircularProgressIndicator())
                    : InkWell(
                        onTap: () {
                          controller.unfollow(followId ?? -1);
                        },
                        child: SvgPicture.asset("assets/icons/trash.svg")),
              16.horizontalSpace
            ],
          ),
        ),
      ),
    );
  }
}
