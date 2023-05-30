import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/account_under_verification_controller.dart';

class AccountUnderVerificationView
    extends GetView<AccountUnderVerificationController> {
  const AccountUnderVerificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/account_under_verification/account_under_verification.png",
            width: 256.w,
            height: 190.h,
          ),
          42.verticalSpace,
          Text("Account Under Verification",
              style: Get.textTheme.bodyMedium?.copyWith(
                  color: Get.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
          16.verticalSpace,
          Text(
              """
Your account is under 
verification, and we will notify 
you as soon as the verification 
process is complete.
""",
              textAlign: TextAlign.center, style: Get.textTheme.bodyMedium),
          38.verticalSpace,
          Text("Note: Verification process may take up to 48 hours.",
              style: Get.textTheme.bodyMedium?.copyWith(fontSize: 12)),
          38.verticalSpace,
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(64))),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text("Let\'s Discover"),
            ),
          ),
        ],
      ),
    ));
  }
}
