import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/follow_model.dart';
import 'package:join_mp_ship/app/modules/applicant_detail/controllers/applicant_detail_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:lottie/lottie.dart';
import 'package:collection/collection.dart';

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
          return controller.args?.viewType == FollowViewType.savedProfile
              ? Column(
                  children: [
                    Container(
                      margin:
                          const EdgeInsets.only(left: 24, right: 24, top: 16),
                      height: 46,
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          boxShadow: const [
                            BoxShadow(
                              color: Color.fromRGBO(60, 162, 255, 0.08),
                              spreadRadius: 2,
                              blurRadius: 4,
                              offset: Offset(0, 4),
                            ),
                          ],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(children: [
                        Expanded(
                            child: InkWell(
                          onTap: () =>
                              controller.showDownloadedResume.value = false,
                          child: Container(
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                                color: controller.showDownloadedResume.value
                                    ? null
                                    : Get.theme.primaryColor,
                                boxShadow: controller.showDownloadedResume.value
                                    ? null
                                    : [
                                        const BoxShadow(
                                            offset: Offset(0, 4),
                                            blurRadius: 6,
                                            color: Color.fromRGBO(
                                                60, 162, 255, 0.10))
                                      ],
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Saved Profiles",
                                    style: Get.textTheme.titleSmall?.copyWith(
                                        color: controller
                                                .showDownloadedResume.value
                                            ? null
                                            : Colors.white)),
                              ],
                            ),
                          ),
                        )),
                        Expanded(
                            child: InkWell(
                          onTap: () =>
                              controller.showDownloadedResume.value = true,
                          child: Container(
                            height: double.maxFinite,
                            decoration: BoxDecoration(
                                color: controller.showDownloadedResume.value
                                    ? Get.theme.primaryColor
                                    : null,
                                boxShadow: controller.showDownloadedResume.value
                                    ? [
                                        const BoxShadow(
                                            offset: Offset(0, 4),
                                            blurRadius: 6,
                                            color: Color.fromRGBO(
                                                60, 162, 255, 0.10))
                                      ]
                                    : null,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Resumes",
                                    style: Get.textTheme.titleSmall?.copyWith(
                                        color: controller
                                                .showDownloadedResume.value
                                            ? Colors.white
                                            : null)),
                              ],
                            ),
                          ),
                        ))
                      ]),
                    ),
                    controller.isLoading.value
                        ? const Expanded(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ))
                        : controller.follows.isEmpty
                            ? Center(
                                child: Lottie.asset(
                                  'assets/animations/no_results.json',
                                  repeat: false,
                                  height: 200,
                                  width: 200,
                                ),
                              )
                            : Expanded(
                                child: controller.showDownloadedResume.value
                                    ? _buildResume()
                                    : _buildBody())
                  ],
                )
              : controller.isLoading.value
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
                      : _buildBody();
        }));
  }

  Widget _buildResume() {
    return ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        itemBuilder: (context, index) {
          return controller.tasks?.elementAt(index) == null
              ? const SizedBox()
              : _resumeCard(controller.tasks![index]);
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
        itemCount: controller.tasks?.length ?? 0);
  }

  Widget _buildBody() {
    return Column(
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
                      ?.copyWith(color: const Color(0xFFFE9738)))
            ],
          ),
        ],
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            itemBuilder: (BuildContext context, int index) {
              Follow? e = controller.follows[index];
              if (e.userDetails == null) {
                return const SizedBox();
              }
              return _userCard(e.userDetails!, e.id);
            },
            itemCount: controller.follows.length,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider();
            },
          ),
        ),
      ],
    );
  }

  Widget _resumeCard(DownloadTask task) {
    List<String>? data = task.filename?.split("_");
    int? crewId = int.tryParse(data?.elementAtOrNull(0) ?? "");
    String? firstName = data?.elementAtOrNull(1);
    String? lastName = data?.elementAtOrNull(2);
    return InkWell(
      onTap: () {
        FlutterDownloader.open(taskId: task.taskId);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: Row(
          children: [
            Expanded(child: Text("${firstName ?? ""} ${lastName ?? ""}")),
            IconButton(
                onPressed: () {
                  Get.toNamed(Routes.APPLICANT_DETAIL,
                      arguments: ApplicantDetailArguments(
                          userId: crewId, viewType: ViewType.crewDetail));
                },
                icon: const Icon(Icons.account_circle_outlined))
          ],
        ),
      ),
    );
  }

  Widget _userCard(CrewUser user, int? followId) {
    return Obx(() {
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
    });
  }
}
