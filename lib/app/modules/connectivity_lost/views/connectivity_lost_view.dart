import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:lottie/lottie.dart';

import '../controllers/connectivity_lost_controller.dart';

class ConnectivityLostView extends GetView<ConnectivityLostController> {
  const ConnectivityLostView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Spacer(),
                LottieBuilder.asset("assets/animations/connectivity_lost.json"),
                Text("You are Offline",
                    style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Get.theme.primaryColor)),
                24.verticalSpace,
                Text(
                  "It Seems There Is A Problem With\nYour Connection. Please Check Your\nNetwork Status",
                  textAlign: TextAlign.center,
                ),
                40.verticalSpace,
                FirebaseAuth.instance.currentUser == null
                    ? FilledButton(
                        style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 32)),
                        onPressed: () {
                          if (Navigator.canPop(context)) {
                            Get.back();
                          } else {
                            Get.offAllNamed(Routes.SPLASH);
                          }
                        },
                        child: Text("Go Back"))
                    : FilledButton(
                        style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 32)),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          await PreferencesHelper.instance.clearAll();
                          UserStates.instance.reset();
                          Get.offAllNamed(Routes.SPLASH);
                        },
                        child: Text("Sign Out")),
                Spacer()
              ],
            ),
          ),
        ));
  }
}
