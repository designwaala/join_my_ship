import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../controllers/job_applied_successfully_controller.dart';

class JobAppliedSuccessfullyView
    extends GetView<JobAppliedSuccessfullyController> {
  const JobAppliedSuccessfullyView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 180,
                width: 180,
                child: Lottie.asset('assets/animations/blue_tick.json',
                    repeat: false),
              ),
              15.verticalSpace,
              const Text(
                "YOU HAVE APPLIED\nSUCCESSFULLY!",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              20.verticalSpace,
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 10,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text("Let's Discover"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
