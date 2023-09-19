import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/utils/user_details.dart';

import '../controllers/followings_controller.dart';

class FollowingsView extends GetView<FollowingsController> {
  const FollowingsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: Text(controller.args?.viewType == FollowViewType.following
              ? 'Followings'
              : 'Followers'),
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
                  children: controller.follows
                      .map((e) => e.userDetails == null
                          ? const SizedBox()
                          : _userCard(e.userDetails!, e.id))
                      .toList());
        }));
  }

  Widget _userCard(CrewUser user, int? followId) {
    return Card(
      elevation: 3,
      shadowColor: const Color.fromARGB(255, 237, 233, 241),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(128),
              child: CachedNetworkImage(
                  imageUrl: user.profilePic ?? "",
                  height: 55,
                  fit: BoxFit.cover,
                  width: 55),
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
                      style: Get.textTheme.bodySmall)
                ],
              ),
            ),
            if (controller.args?.viewType == FollowViewType.following)
              controller.unfollowId.value == user.id
                  ? const CircularProgressIndicator()
                  : TextButton(
                      onPressed: () {
                        controller.unfollow(followId ?? -1);
                      },
                      child: const Text("Unfollow"))
          ],
        ),
      ),
    );
  }
}
