import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/boosting/views/widgets/crew_profile_view.dart';
import 'package:join_my_ship/app/modules/boosting/views/widgets/job_post_view.dart';

import '../controllers/boosting_controller.dart';

class BoostingView extends GetView<BoostingController> {
  const BoostingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Discover'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      16.verticalSpace,
                      Container(
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
                        child: Row(
                            children: BoostingViewType.values
                                .map((view) => Expanded(
                                        child: InkWell(
                                      onTap: () => controller.view.value = view,
                                      child: Container(
                                        height: double.maxFinite,
                                        decoration: BoxDecoration(
                                            color: controller.view.value == view
                                                ? Get.theme.primaryColor
                                                : null,
                                            boxShadow: controller.view.value ==
                                                    view
                                                ? [
                                                    const BoxShadow(
                                                        offset: Offset(0, 4),
                                                        blurRadius: 6,
                                                        color: Color.fromRGBO(
                                                            60, 162, 255, 0.10))
                                                  ]
                                                : null,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(view.name,
                                                style: Get.textTheme.titleSmall
                                                    ?.copyWith(
                                                        color: controller.view
                                                                    .value ==
                                                                view
                                                            ? Colors.white
                                                            : null)),
                                          ],
                                        ),
                                      ),
                                    )))
                                .toList()),
                      ),
                      16.verticalSpace,
                      Expanded(
                        child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: (controller.view.value ==
                                    BoostingViewType.jobPost
                                ? const JobPostBoostingView()
                                : const CrewProfileBoostingView())),
                      )
                    ],
                  ),
                );
        }));
  }
}
