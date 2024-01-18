import 'package:collection/collection.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/crew_referral/controllers/crew_referral_controller.dart';
import 'package:join_my_ship/app/modules/job_posted_successfully/controllers/job_posted_successfully_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/styles.dart';

class JobPreview extends GetView<CrewReferralController> {
  const JobPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Center(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  children: [
                    16.verticalSpace,
                    Text("Job Preview", style: Get.textTheme.formFieldHeading),
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              "${controller.user?.profilePic}"))),
                                ),
                                12.horizontalSpace,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                        "${controller.user?.firstName}"
                                            .toUpperCase(),
                                        style: Get.textTheme.s14w600),
                                    Text("Referred Job",
                                        style: Get.textTheme.bodySmall
                                            ?.copyWith(
                                                color: Colors.grey.shade700))
                                  ],
                                )
                              ],
                            ),
                            14.verticalSpace,
                            Row(
                              children: [
                                Text("Rank: ", style: Get.textTheme.s12w500),
                                Text(controller.selectedRank.value?.name ?? "",
                                    style: Get.textTheme.s12w400)
                              ],
                            ),
                            4.verticalSpace,
                            Row(
                              children: [
                                Text("Vessel IMO No: ",
                                    style: Get.textTheme.s12w500),
                                Text(controller.vesselIMONo.text,
                                    style: Get.textTheme.s12w400)
                              ],
                            ),
                            4.verticalSpace,
                            Row(
                              children: [
                                Text("Vessel Type: ",
                                    style: Get.textTheme.s12w500),
                                Text(
                                    controller.vesselList?.vessels
                                            ?.expand((e) => e.subVessels ?? [])
                                            .firstWhereOrNull((e) =>
                                                e.id ==
                                                controller
                                                    .recordVesselType.value)
                                            ?.name ??
                                        "",
                                    style: Get.textTheme.s12w400)
                              ],
                            ),
                            Row(
                              children: [
                                Text("Flag: ", style: Get.textTheme.s12w500),
                                Text(controller.flag.text,
                                    style: Get.textTheme.s12w400)
                              ],
                            ),
                            4.verticalSpace,
                            Row(
                              children: [
                                Text("Joining Port: ",
                                    style: Get.textTheme.s12w500),
                                Text(controller.joiningPort.text,
                                    style: Get.textTheme.s12w400)
                              ],
                            ),
                            4.verticalSpace,
                            Row(
                              children: [
                                Text("Tentative Joining Date: ",
                                    style: Get.textTheme.s12w500),
                                Text(controller.tentativeJoining.text,
                                    style: Get.textTheme.s12w400)
                              ],
                            ),
                            4.verticalSpace,
                            if (controller
                                .cocRequirementsSelected.isNotEmpty) ...[
                              8.verticalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("COC Requirements",
                                      style: Get.textTheme.s12w500),
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    children: [
                                      ...() {
                                        List<String?> texts = controller
                                            .cocRequirementsSelected
                                            .map((e) => [e.name, " | "])
                                            .expand((e) => e)
                                            .toList()
                                            .map((e) => e)
                                            .toList();
                                        texts.removeLast();
                                        return texts.map((e) => Text(e ?? "",
                                            style: Get.textTheme.s12w400));
                                      }()
                                    ],
                                  )
                                ],
                              ),
                            ],
                            if (controller
                                .copRequirementsSelected.isNotEmpty) ...[
                              8.verticalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("COP Requirements",
                                      style: Get.textTheme.s12w500),
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    children: [
                                      ...() {
                                        List<String?> texts = controller
                                            .copRequirementsSelected
                                            .map((e) => [e.name, " | "])
                                            .expand((e) => e)
                                            .toList()
                                            .map((e) => e)
                                            .toList();
                                        texts.removeLast();
                                        return texts.map((e) => Text(e ?? "",
                                            style: Get.textTheme.s12w400));
                                      }()
                                    ],
                                  )
                                ],
                              )
                            ],
                            if (controller.watchKeepingRequirementsSelected
                                .isNotEmpty) ...[
                              8.verticalSpace,
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Watch-Keeping Requirements",
                                      style: Get.textTheme.s12w500),
                                  Wrap(
                                    alignment: WrapAlignment.end,
                                    children: [
                                      ...() {
                                        List<String?> texts = controller
                                            .watchKeepingRequirementsSelected
                                            .map((e) => [e.name, " | "])
                                            .expand((e) => e)
                                            .toList()
                                            .map((e) => e)
                                            .toList();
                                        texts.removeLast();
                                        return texts.map((e) => Text(e ?? "",
                                            style: Get.textTheme.s12w400));
                                      }()
                                    ],
                                  )
                                ],
                              )
                            ],
                            8.verticalSpace,
                            InkWell(
                              onTap: () {
                                controller.previewJob.value = false;
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.edit,
                                      size: 16, color: Get.theme.primaryColor),
                                  4.horizontalSpace,
                                  Text("Edit",
                                      style: Get.textTheme.s14w500.copyWith(
                                          color: Get.theme.primaryColor))
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Checkbox(
                            value: controller.hasAgreed.value,
                            onChanged: (value) {
                              controller.hasAgreed.value = value ?? false;
                            }),
                        RichText(
                            text: TextSpan(children: [
                          TextSpan(
                              text: "I have read and agree to the ",
                              style: Get.textTheme.s12w400
                                  .copyWith(color: Colors.black)),
                          TextSpan(
                              text: "terms or service",
                              recognizer: TapGestureRecognizer()..onTap = () {},
                              style: Get.textTheme.s12w400
                                  .copyWith(color: Get.theme.primaryColor))
                        ])),
                      ],
                    ),
                    32.verticalSpace,
                    controller.isPostingJob.value
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [CircularProgressIndicator()],
                          )
                        : SizedBox(
                            width: 231,
                            height: 46,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10.h, horizontal: 45.w),
                                  backgroundColor: const Color(0xFF407BFF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(36.21),
                                  ),
                                ),
                                onPressed: controller.hasAgreed.value
                                    ? () async {
                                        await controller.postJob();
                                        controller.jobToEdit?.isActive == true
                                            ? Get.offAllNamed(Routes.HOME)
                                            : Get.offAllNamed(
                                                Routes
                                                    .JOB_POST_UNDER_VERIFICATION,
                                                arguments:
                                                    JobPostedSuccessfullyArguments(
                                                        message: controller
                                                                    .jobToEdit ==
                                                                null
                                                            ? null
                                                            : "JOB EDITED\nSUCCESSFULLY"));
                                      }
                                    : null,
                                child: Text("PUBLISH"))),
                    32.verticalSpace,
                  ],
                ))
          ],
        ),
      );
    });
  }
}
