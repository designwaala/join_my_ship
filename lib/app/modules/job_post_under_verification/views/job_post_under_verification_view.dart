import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/styles.dart';

import '../controllers/job_post_under_verification_controller.dart';

class JobPostUnderVerificationView
    extends GetView<JobPostUnderVerificationController> {
  const JobPostUnderVerificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const Spacer(),
          Image.asset(
            "assets/images/job_post_under_verification/job_post_under_verification.png",
            height: 200,
            width: 200,
          ),
          40.verticalSpace,
          Text("Job Post Under Verification",
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          20.verticalSpace,
          Text(
              "Your job post is under verification, and we will notify you as soon as the verification process is complete.",
              textAlign: TextAlign.center,
              style: Get.textTheme.bodyMedium),
          36.verticalSpace,
          Text("Note: Verification process may take up to 48 hours. ",
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 12)),
          36.verticalSpace,
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64))),
              onPressed: () {
                Get.offAllNamed(Routes.HOME);
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: const Text("Let’s Discover "),
              )),
          const Spacer()
        ],
      ),
    ));
  }
}
