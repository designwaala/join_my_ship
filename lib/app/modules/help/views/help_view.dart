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
          foregroundColor: const Color(0xFF000000),
          title: Text(
            'Help',
            style: GoogleFonts.poppins(
                color: const Color(0xFF000000),
                fontWeight: FontWeight.w600,
                fontSize: 20.sp),
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: SvgPicture.asset(
                  'assets/images/logo.svg',
                  height: 81.h,
                  width: 69.w,
                  color: const Color(0xFF407BFF),
                  // colorFilter:
                  //     ColorFilter.mode(Get.theme.primaryColor, BlendMode.srcIn),
                ),
              ),
              Center(
                child: Text("Join My Ship",
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF407BFF),
                        fontSize: 38,
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
              90.verticalSpace,
              Text(
                  "At joinmyship, we are committed to provide you best customer service experience. Also, we look forward to your suggestions and feedbacks.",
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
                    const Icon(Icons.email_outlined,
                        color: const Color(0xFF407BFF)),
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
                    const Icon(Icons.email_outlined, color: Color(0xFF407BFF)),
                    7.horizontalSpace,
                    Text("Linkedin",
                        style: GoogleFonts.inter(
                          color: const Color(0xFF407BFF),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        )),
                  ]),
              12.verticalSpace,
              Text("www.linkedin.com/in/joinmyship",
                  style: GoogleFonts.inter(
                    color: const Color(0xFF000000),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  )),
            ],
          ),
        ));
  }
}
