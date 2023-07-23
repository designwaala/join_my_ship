import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/reset_password/controllers/reset_password_controller.dart';

class ResetPasswordEmailVerificationView
    extends GetView<ResetPasswordController> {
  const ResetPasswordEmailVerificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Reset Password',
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
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/email_verification/arrow.png',
                height: 80,
              ),
              50.verticalSpace,
              Text(
                'Check Your Email Address',
                style: TextStyle(
                    fontSize: 20,
                    color: Get.theme.colorScheme.primary,
                    fontWeight: FontWeight.w600),
              ),
              18.verticalSpace,
              const Text(
                'This action requires email verification.'
                ' Please check your inbox and follow the instructions.',
                textAlign: TextAlign.center,
              ),
              50.verticalSpace,
              MaterialButton(
                minWidth: 250,
                height: 50,
                color: Colors.blue,
                textColor: Colors.white,
                shape: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(30),
                ),
                onPressed: Get.back,
                child: const Text(
                  "OK",
                  style: TextStyle(fontSize: 16),
                ),
              ),
              150.verticalSpace
            ],
          ),
        ),
      ),
    );
  }
}
