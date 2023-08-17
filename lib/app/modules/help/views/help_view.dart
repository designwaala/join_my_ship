import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            60.verticalSpace,
            Center(
              child: SvgPicture.asset(
                'assets/images/logo.svg',
                height: 75.h,
                width: 60.w,
                color: const Color(0xFF407BFF),
                // colorFilter:
                //     ColorFilter.mode(Get.theme.primaryColor, BlendMode.srcIn),
              ),
            ),
            Center(
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
            ),
            40.verticalSpace,
            Text(
                "At joinmyship, we are committed to provide you best customer service experience. Also, we look forward to your suggestions and feedbacks.",
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  color: const Color(0xFF000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                )),
            40.verticalSpace,
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
                  const ImageIcon(AssetImage("assets/icons/linkedin.png"),
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
            Text(
              "www.linkedin.com/in/joinmyship",
              style: GoogleFonts.inter(
                color: const Color(0xFF000000),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            const Spacer(),
            const Divider(),
            20.verticalSpace,
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
            Row(
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
            50.verticalSpace
          ],
        ),
      ),
    );
  }
}
