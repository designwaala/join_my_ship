import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:join_my_ship/app/modules/sign_up_email/controllers/sign_up_email_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/user_details.dart';

import '../controllers/choose_user_controller.dart';

class ChooseUserView extends GetView<ChooseUserController> {
  const ChooseUserView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
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
            Align(
              alignment: Alignment.center,
              child: Text("Continue as",
                  style: Get.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold)),
            ),
            10.verticalSpace,
            const Text(
              "Choose one you’re looking the new jobs or\n new employee",
              textAlign: TextAlign.center,
            ),
            24.verticalSpace,
            ...[
              [
                "CREW",
                "Finding a job here never been easier than before",
                "assets/images/choose_user/crew.png"
              ],
              [
                "EMPLOYER",
                "Let’s recruit your great candidate faster here ",
                "assets/images/choose_user/employer.png"
              ]
            ].mapIndexed((index, e) => InkWell(
                  onTap: () {
                    PreferencesHelper.instance.setIsCrew(index == 0);
                    UserStates.instance.isCrew = index == 0;
                    if (index == 0) {
                      Get.offAllNamed(Routes.SPLASH);
                    } else {
                      Get.toNamed(Routes.CHOOSE_EMPLOYER);
                    }
                  },
                  child: Container(
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
                    child: Row(
                      children: [
                        Image.asset(
                          e[2],
                          height: 77.h,
                          width: 77.h,
                        ),
                        16.horizontalSpace,
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(e[0],
                                  style: Get.theme.textTheme.bodyMedium
                                      ?.copyWith(
                                          color: Get.theme.primaryColor,
                                          fontWeight: FontWeight.bold)),
                              8.verticalSpace,
                              Text(e[1])
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    ));
  }
}
