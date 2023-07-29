import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/employer_jobs/controllers/employer_job_posts_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator.dart';

class EmployerJobPostsView extends GetView<EmployerJobPostsController> {
  const EmployerJobPostsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('My Jobs',
            style: Get.theme.textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        leading: InkWell(
          onTap: Get.back,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Color(0xFFF3F3F3), shape: BoxShape.circle),
            child: const Icon(
              Icons.keyboard_backspace_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Obx(
        () => controller.resourceLoadingRemaining.value > 0
            ? const CircularProgressIndicatorWidget()
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: ListView.builder(
                    itemCount: controller.jobPosts.length,
                    itemBuilder: (context, index) => controller.jobPosts.isEmpty
                        ? const Center(child: Text("No jobs posted"))
                        : Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, top: 15),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Image.network(
                                          "https://th.bing.com/th/id/OIP.VOnsU2XuuWeDj_0qNe2lCwEREs?w=159&h=180&c=7&r=0&o=5&dpr=1.4&pid=1.7",
                                          // controller.currentEmployerUser.value!.profilePic!,
                                          height: 50,
                                          width: 50,
                                        ),
                                        10.horizontalSpace,
                                        Flexible(
                                          flex: 15,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${controller.currentEmployerUser.value!.firstName!} ${controller.currentEmployerUser.value!.lastName!}"
                                                    .toUpperCase(),
                                                overflow: TextOverflow.ellipsis,
                                                style: Get.textTheme.bodyMedium
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                              ),
                                              Text(
                                                  controller.currentEmployerUser
                                                      .value!.username!,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  // "Westline Ship Management Pvt. Ltd.",
                                                  style: Get.textTheme.bodySmall
                                                      ?.copyWith(
                                                          fontSize: 11,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                            ],
                                          ),
                                        ),
                                        const Spacer(),
                                        PopupMenuButton<String>(
                                          itemBuilder: (context) => [
                                            const PopupMenuItem(
                                              value: "edit",
                                              child: Text("Edit"),
                                            ),
                                            const PopupMenuItem(
                                              value: "share",
                                              child: Text("Share"),
                                            ),
                                            const PopupMenuItem(
                                              value: "delete",
                                              child: Text(
                                                "Delete",
                                                style: TextStyle(
                                                    color: Colors.red),
                                              ),
                                            ),
                                          ],
                                          onOpened: () {},
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text("Tentative Joining Date",
                                                style: Get.textTheme.bodyLarge),
                                            const Spacer(),
                                            Text(
                                              controller.jobPosts[index]
                                                  .tentativeJoiningDate!,
                                              style: Get.textTheme.bodyMedium
                                                  ?.copyWith(fontSize: 14),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("Vessel Type",
                                                style: Get.textTheme.bodyLarge),
                                            Text(controller.vesselTypes[
                                                controller.jobPosts[index]
                                                    .vesselType]!),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text("GRT",
                                                style: Get.textTheme.bodyLarge),
                                            Text(controller.jobPosts[index].grt!
                                                .toString())
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Column(
                                            children: List.generate(
                                                controller.jobPosts[index]
                                                    .rankList!.length,
                                                (index2) => Padding(
                                                      padding: const EdgeInsets
                                                              .symmetric(
                                                          vertical: 3),
                                                      child: Row(
                                                        children: [
                                                          const Icon(
                                                            Icons
                                                                .radio_button_checked,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    169,
                                                                    168,
                                                                    170),
                                                            size: 20,
                                                          ),
                                                          10.horizontalSpace,
                                                          Text(
                                                            controller
                                                                    .rankTypes[
                                                                controller
                                                                        .jobPosts[
                                                                            index]
                                                                        .rankList![
                                                                    index2]]!,
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        15),
                                                          )
                                                        ],
                                                      ),
                                                    )),
                                          ),
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "COC Requirements",
                                              style: Get.textTheme.bodyLarge,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: List.generate(
                                                controller.jobPosts[index]
                                                    .cocList!.length,
                                                (index2) => Text(controller
                                                        .cocTypes[
                                                    controller.jobPosts[index]
                                                        .cocList![index2]]!),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "COP Requirements",
                                              style: Get.textTheme.bodyLarge,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: List.generate(
                                                controller.jobPosts[index]
                                                    .copList!.length,
                                                (index2) => Text(controller
                                                        .copTypes[
                                                    controller.jobPosts[index]
                                                        .copList![index2]]!),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              "Watch-Keeping\nRequirements",
                                              style: Get.textTheme.bodyLarge,
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: List.generate(
                                                controller.jobPosts[index]
                                                    .watchKeepingList!.length,
                                                (index2) => Text(controller
                                                        .watchKeepingTypes[
                                                    controller.jobPosts[index]
                                                            .watchKeepingList![
                                                        index2]]!),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Email: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              controller.currentEmployerUser
                                                  .value!.email!,
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            const Text(
                                              "Mobile: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 12),
                                            ),
                                            Text(
                                              controller.currentEmployerUser
                                                      .value!.number ??
                                                  "9876543210",
                                              style:
                                                  const TextStyle(fontSize: 13),
                                            ),
                                          ],
                                        ),
                                        4.verticalSpace,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            17.horizontalSpace,
                                            TextButton.icon(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.thumb_up,
                                                  size: 18,
                                                  color: Colors.blue,
                                                ),
                                                style: TextButton.styleFrom(
                                                  splashFactory:
                                                      NoSplash.splashFactory,
                                                  padding: const EdgeInsets
                                                          .symmetric(
                                                      horizontal: 10),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15),
                                                      side: const BorderSide(
                                                          width: 1.8,
                                                          color: Colors.blue)),
                                                ),
                                                label: Text(
                                                  " Likes ${controller.jobPosts[index].likes}",
                                                  style: Get
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                          color: Colors.blue),
                                                )),
                                          ],
                                        ),
                                        5.verticalSpace,
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            TextButton.icon(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  Icons.send,
                                                  size: 18,
                                                ),
                                                label: const Text(
                                                  "Highlight",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                )),
                                            ElevatedButton(
                                                style: ElevatedButton.styleFrom(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 10),
                                                    shape:
                                                        RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        14))),
                                                onPressed: () => Get.toNamed(Routes
                                                    .EMPLOYER_JOB_APPLICATIONS),
                                                child: const Text(
                                                  "Applications",
                                                  style:
                                                      TextStyle(fontSize: 13),
                                                )),
                                            TextButton.icon(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons.diamond_outlined,
                                                size: 22,
                                                color: Colors.yellow,
                                              ),
                                              label: const Text(
                                                "Boost",
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.yellow),
                                              ),
                                            ),
                                          ],
                                        ),
                                        5.verticalSpace,
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  ),
                ),
              ),
      ),
    );
  }
}
