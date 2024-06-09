import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:join_my_ship/utils/remote_config.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:open_store/open_store.dart';
import 'package:url_launcher/url_launcher.dart';

import '../controllers/help_controller.dart';

class HelpView extends GetView<HelpController> {
  const HelpView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        title: const Text('Help & Feedback'),
      ),
      body: Obx(() {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    60.verticalSpace,
                    Center(
                      child: SvgPicture.asset(
                        'assets/images/customer_support.svg',
                        height: 200.h,
                        width: 200.w,
                      ),
                    ),
                    /* Center(
                child: Text("Join My Ship",
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF407BFF),
                        fontSize: 22,
                        fontWeight: FontWeight.w400,
                        fontFamily: GoogleFonts.racingSansOne().fontFamily)),
              ),
              Center(
                child: Text("www.joinmyship.com",
                    style: GoogleFonts.poppins(
                      color: const Color(0xFF000000),
                      fontSize: 7,
                      fontWeight: FontWeight.w400,
                    )),
              ), */
                    const Spacer(flex: 1),
                    Text(
                        "At joinmyship, we are committed to provide you best customer service experience. Also, we look forward to your suggestions and feedbacks.",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.inter(
                          color: const Color(0xFF000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )),
                    const Spacer(flex: 2),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const ImageIcon(AssetImage("assets/icons/email.png"),
                              color: Color(0xFF407BFF)),
                          7.horizontalSpace,
                          Text("Email",
                              style: GoogleFonts.inter(
                                color: const Color(0xFF407BFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ]),
                    12.verticalSpace,
                    Text("Support: support@joinmyship.com",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )),
                    22.verticalSpace,
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const ImageIcon(
                              AssetImage("assets/icons/linkedin.png"),
                              color: Color(0xFF407BFF)),
                          7.horizontalSpace,
                          Text("Linkedin",
                              style: GoogleFonts.inter(
                                color: const Color(0xFF407BFF),
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              )),
                        ]),
                    12.verticalSpace,
                    InkWell(
                      onTap: () {
                        launchUrl(Uri.parse(
                            "https://www.linkedin.com/company/joinmyship"));
                      },
                      child: Text(
                        "www.linkedin.com/company/joinmyship",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF000000),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    const Spacer(),
                    const Divider(),
                    20.verticalSpace,
                    if (!controller.isRatingGiven.value) ...[
                      const Center(
                        child: Text(
                          "Enjoying the app?",
                          style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 12),
                        ),
                      ),
                      5.verticalSpace,
                      const Center(
                        child: Text(
                          "Would you mind rating us?",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      10.verticalSpace,
                      InkWell(
                        onTap: () async {
                          if (RemoteConfigUtils
                                  .instance.enableInAppReviewAndroid &&
                              Platform.isAndroid) {
                            final InAppReview inAppReview =
                                InAppReview.instance;
                            if (await inAppReview.isAvailable()) {
                              inAppReview.requestReview();
                              PreferencesHelper.instance.setratingGiven(true);
                              controller.isRatingGiven.value = true;
                            }
                          } else {
                            OpenStore.instance.open(
                                appStoreId: "",
                                androidAppBundleId: "com.joinmyship.android");
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            5,
                            (index) => const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              child: ImageIcon(
                                AssetImage("assets/icons/star.png"),
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                    50.verticalSpace
                  ],
                ),
              )
            ],
          ),
        );
      }),
    );
  }
}
