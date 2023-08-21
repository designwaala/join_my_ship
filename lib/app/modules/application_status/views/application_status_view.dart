import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import '../controllers/application_status_controller.dart';

class ApplicationStatusView extends GetView<ApplicationStatusController> {
  const ApplicationStatusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Application Status'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              32.verticalSpace,
              IntrinsicHeight(
                  child: Row(
                children: [
                  controller.args?.application?.appliedStatus == true
                      ? _completedTimeline(1)
                      : _pendingTimeline(1),
                  16.horizontalSpace,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Job Applied",
                            style: Get.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        Text("You have successfully applied for your job",
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey)),
                        8.verticalSpace,
                      ],
                    ),
                  )
                ],
              )),
              IntrinsicHeight(
                  child: Row(
                children: [
                  controller.args?.application?.viewedStatus == true
                      ? _completedTimeline(2)
                      : _pendingTimeline(2),
                  16.horizontalSpace,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Profile Viewed",
                            style: Get.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        Text("Profile has been viewed by the employer",
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey)),
                        8.verticalSpace,
                      ],
                    ),
                  )
                ],
              )),
              IntrinsicHeight(
                  child: Row(
                children: [
                  controller.args?.application?.resumeStatus == true
                      ? _completedTimeline(3)
                      : _pendingTimeline(3),
                  16.horizontalSpace,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Resume Downloaded",
                            style: Get.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        Text("Resume has been downloaded by the employer",
                            style: Get.textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey)),
                        8.verticalSpace,
                      ],
                    ),
                  )
                ],
              )),
              IntrinsicHeight(
                  child: Row(
                children: [
                  controller.args?.application?.shortlistedStatus == true
                      ? _completedTimeline(4)
                      : _pendingTimeline(4),
                  16.horizontalSpace,
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Shortlisted",
                            style: Get.textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600)),
                        Text(
                          "Congratulations! Employer has shortlisted your profile",
                          style: Get.textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey),
                          maxLines: 3,
                        ),
                        8.verticalSpace,
                      ],
                    ),
                  )
                ],
              )),
            ],
          ),
        ));
  }

  _completedTimeline(int index) => Column(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
                color: Colors.green, borderRadius: BorderRadius.circular(4)),
            child: Icon(Icons.check, color: Colors.white, size: 18),
          ),
          if (index != 4)
            Expanded(
              child: Container(
                width: 2,
                decoration: BoxDecoration(color: Colors.green),
              ),
            )
        ],
      );

  _pendingTimeline(int index) => Column(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
                border: Border.all(color: Get.theme.primaryColor),
                borderRadius: BorderRadius.circular(4)),
            child: Center(child: Text(index.toString())),
          ),
          if (index != 4)
            Expanded(
              child: Container(
                width: 2,
                decoration: BoxDecoration(color: Get.theme.primaryColor),
              ),
            )
        ],
      );
}
