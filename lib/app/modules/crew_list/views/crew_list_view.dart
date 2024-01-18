import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/applicant_detail/controllers/applicant_detail_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:lottie/lottie.dart';

import '../controllers/crew_list_controller.dart';

class CrewListView extends GetView<CrewListController> {
  const CrewListView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Crews'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : controller.crewList?.isEmpty == true ||
                      controller.crewList == null
                  ? Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          16.verticalSpace,
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Chip(
                                  backgroundColor: Colors.blue[100],
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                          color: Get.theme.primaryColor)),
                                  label: Text(
                                      controller.selectedRank?.name ?? "")),
                            ),
                          ),
                          8.verticalSpace,
                          const Spacer(),
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
                          const Spacer(),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.verticalSpace,
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Chip(
                              backgroundColor: Colors.blue[100],
                              shape: StadiumBorder(
                                  side: BorderSide(
                                      color: Get.theme.primaryColor)),
                              label: Text(controller.selectedRank?.name ?? "")),
                        ),
                        8.verticalSpace,
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            itemCount: controller.crewList?.length,
                            itemBuilder: (context, index) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Card(
                                elevation: 3,
                                shadowColor:
                                    const Color.fromARGB(255, 237, 233, 241),
                                shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: controller.crewList?[index]
                                                    .isHighlighted ==
                                                true
                                            ? Get.theme.primaryColor
                                            : Colors.transparent),
                                    borderRadius: BorderRadius.circular(20)),
                                child: InkWell(
                                  onTap: () {
                                    Get.toNamed(Routes.APPLICANT_DETAIL,
                                        arguments: ApplicantDetailArguments(
                                            userId:
                                                controller.crewList?[index].id,
                                            viewType: ViewType.crewDetail));
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
                                                      .crewList?[index]
                                                      .profilePic ??
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
                                                controller.crewList?[index]
                                                        .firstName ??
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
                                                    UserStates.instance.ranks
                                                            ?.firstWhereOrNull(
                                                                (rank) =>
                                                                    rank.id ==
                                                                    controller
                                                                        .crewList?[
                                                                            index]
                                                                        .rankId)
                                                            ?.name ??
                                                        "",
                                                    style: Get
                                                        .textTheme.bodyMedium,
                                                  ),
                                                  SizedBox(width: 6),
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                        /* if(controller.crewList?[index].isHighlighted == true)
                                        Icon(Icons.star, color: Get.theme.primaryColor) */
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
        }));
  }
}
