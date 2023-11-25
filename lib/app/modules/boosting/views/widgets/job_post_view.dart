import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:join_mp_ship/app/data/models/boosting_model.dart';
import 'package:join_mp_ship/app/modules/boosted_jobs/controllers/boosted_jobs_controller.dart';
import 'package:join_mp_ship/app/modules/boosting/controllers/boosting_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/widgets/status_border.dart';
import 'package:collection/collection.dart';

class JobPostBoostingView extends GetView<BoostingController> {
  const JobPostBoostingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        controller.jobPagingController.refresh();
      },
      child: PagedListView<int, Map<String, List<Employer>>>(
        pagingController: controller.jobPagingController,
        builderDelegate: PagedChildBuilderDelegate(
          itemBuilder: (context, jobsGrouped, index) {
            return InkWell(
              onTap: () {
                Get.toNamed(Routes.BOOSTED_JOBS,
                    arguments: BoostedJobsArguments(
                        jobGrouped: controller.jobPagingController.itemList,
                        currentIndex: index));
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CachedNetworkImage(
                      imageUrl: jobsGrouped.values.firstOrNull?.firstOrNull
                              ?.userBoost?.profilePic ??
                          "",
                      imageBuilder: (context, imageProvider) {
                        return CustomPaint(
                          painter: DottedBorder(
                            numberOfStories:
                                jobsGrouped.values.firstOrNull?.length ?? 0,
                            // seenStoriesIndicies: [0, 1, 2],
                          ),
                          child: Container(
                            height: 50.h,
                            width: 50.h,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.cover),
                                shape: BoxShape.circle),
                          ),
                        );
                      },
                    ),
                    20.horizontalSpace,
                    Flexible(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              jobsGrouped.values.firstOrNull?.firstOrNull
                                      ?.userBoost?.companyName ??
                                  "",
                              maxLines: 2,
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
