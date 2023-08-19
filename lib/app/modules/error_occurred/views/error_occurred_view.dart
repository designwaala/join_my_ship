import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/error_occurred_controller.dart';
import 'package:join_mp_ship/utils/extensions/string_extensions.dart';

class ErrorOccurredView extends GetView<ErrorOccurredController> {
  const ErrorOccurredView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print([
      FirebaseAuth.instance.currentUser != null,
      UserStates.instance.crewUser != null,
      UserStates.instance.isCrew == true,
      FirebaseAuth.instance.currentUser?.email?.nullIfEmpty() != null,
      FirebaseAuth.instance.currentUser?.emailVerified == true,
      FirebaseAuth.instance.currentUser?.phoneNumber != null
    ]);
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              40.verticalSpace,
              Lottie.asset("assets/animations/error.json",
                  height: 232.h, width: 286.w),
              24.verticalSpace,
              Text("Sorry, It Looks Like\nSomething Went\nWrong!",
                  textAlign: TextAlign.center,
                  style: Get.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.primaryColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold)),
              24.verticalSpace,
              SizedBox(
                  width: 230,
                  child: FilledButton(
                      onPressed: () async {
                        UserStates.instance.reset();
                        await FirebaseAuth.instance.signOut();
                        await PreferencesHelper.instance.clearAll();
                        Get.offAllNamed(Routes.SPLASH);
                      },
                      child: Text("Sign Out"))),
              const Spacer(),
              Text(
                "Our Best Men Are Fixing It,\nMeanwhile Would You Like To Write\nUs An Email ?",
                textAlign: TextAlign.center,
              ),
              24.verticalSpace,
              FilledButton.icon(
                  style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Get.theme.primaryColor,
                      elevation: 4),
                  onPressed: () {
                    launchUrl(Uri(
                      scheme: 'mailto',
                      path: 'joinmyship22@gmail.com',
                      query: '''subject=App Feedback&body=
Firebase User: ${FirebaseAuth.instance.currentUser != null}
Django User: ${UserStates.instance.crewUser != null},
Is Crew: ${UserStates.instance.isCrew}
Email: ${FirebaseAuth.instance.currentUser?.email?.nullIfEmpty() != null}
Email Verified: ${FirebaseAuth.instance.currentUser?.emailVerified}
Phone Number: ${FirebaseAuth.instance.currentUser?.phoneNumber?.nullIfEmpty() != null}
Version Number: ${packageInfo?.version}                     
Build Number: ${packageInfo?.buildNumber}
                          ''',
                    ));
                  },
                  icon: Icon(Icons.email),
                  label: Text("Contact Us")),
              40.verticalSpace
            ],
          ),
        ),
      ),
    ));
  }
}
