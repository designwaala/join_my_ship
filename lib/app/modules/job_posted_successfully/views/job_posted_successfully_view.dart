import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/styles.dart';
import 'package:join_mp_ship/widgets/custom_elevated_button.dart';
import 'package:lottie/lottie.dart';

import '../controllers/job_posted_successfully_controller.dart';

class JobPostedSuccessfullyView
    extends GetView<JobPostedSuccessfullyController> {
  const JobPostedSuccessfullyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const Spacer(),
          SizedBox(
            height: 180,
            width: 180,
            child:
                Lottie.asset('assets/animations/blue_tick.json', repeat: true),
          ),
          26.verticalSpace,
          Text(controller.args?.message ?? "JOB PUBLISHED\nSUCCESSFULLY!",
              textAlign: TextAlign.center,
              style: Get.textTheme.s20w700
                  .copyWith(color: Get.theme.primaryColor)),
          20.verticalSpace,
          SizedBox(
            height: 48,
            width: 231,
            child: CustomElevatedButon(
                onPressed: () {
                  Get.offAllNamed(Routes.HOME);
                },
                child: Text("Let’s Discover ")),
          ),
          const Spacer()
        ],
      ),
    ));
  }
}
