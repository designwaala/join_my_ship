import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:join_mp_ship/app/modules/sign_up_email/controllers/sign_up_email_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';

import '../controllers/choose_employer_controller.dart';

class ChooseEmployerView extends GetView<ChooseEmployerController> {
  const ChooseEmployerView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(24.h),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/logo.svg',
                height: 143.h,
                width: 122.w,
                colorFilter:
                    ColorFilter.mode(Get.theme.primaryColor, BlendMode.srcIn),
              ),
              Text("Join My Ship",
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                      color: Get.theme.primaryColor,
                      fontSize: 38,
                      fontWeight: FontWeight.w400,
                      fontFamily: GoogleFonts.racingSansOne().fontFamily)),
              const Text("www.joinmyship.com"),
              72.verticalSpace,
              Center(
                child: Text("Continue as",
                    style: Get.textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ),
              24.verticalSpace,
              ...["ITF / Ownership", "Management Company", "Crewing Agent"]
                  .mapIndexed((index, e) => InkWell(
                        onTap: () {
                          PreferencesHelper.instance.setEmployerType(index + 3);
                          UserStates.instance.setEmployerTypeIndex(index + 3);
                          Get.offAllNamed(Routes.SPLASH);
                          /* if (FirebaseAuth.instance.currentUser?.phoneNumber ==
                          null) {
                        Get.toNamed(Routes.SIGN_UP_PHONE_NUMBER, arguments: {
                          "company_type": () {
                            switch (index + 3) {
                              case 3:
                                return SignUpType.employerITF;
                              case 4:
                                return SignUpType.employerManagementCompany;
                              case 5:
                                return SignUpType.employerCrewingAgent;
                            }
                          }()
                        });
                      } else if (FirebaseAuth.instance.currentUser?.email ==
                          null) {
                        Get.toNamed(Routes.SIGN_UP_EMAIL);
                      } else {
                        Get.offAllNamed(Routes.EMPLOYER_CREATE_USER);
                      } */
                        },
                        child: Container(
                          width: double.maxFinite,
                          margin: EdgeInsets.symmetric(vertical: 12.h),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(24.r),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(64, 24, 157, 0.15),
                                    blurRadius: 5,
                                    offset: Offset(-5, 5))
                              ]),
                          child: Text(e,
                              textAlign: TextAlign.center,
                              style: Get.theme.textTheme.bodyMedium?.copyWith(
                                  color: Get.theme.primaryColor,
                                  fontWeight: FontWeight.bold)),
                        ),
                      )),
              const Spacer(),
            ],
          ),
        ),
      ),
    ));
  }
}
