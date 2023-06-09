import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/info_controller.dart';

class InfoView extends GetView<InfoController> {
  const InfoView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
          body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Spacer(),
              CarouselSlider(
                carouselController: controller.carouselController,
                items: [
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/info/info_1.png',
                        width: 263.w,
                        height: 245.h,
                      ),
                      Spacer(),
                      Text('Find your dream\n job with us',
                          textAlign: TextAlign.center,
                          style: Get.theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.sp,
                              color: Colors.black)),
                      20.verticalSpace,
                      Text(
                        "Discover and apply to your dream jobs and\n start to get in touch with your dream\n company",
                        textAlign: TextAlign.center,
                      ),
                      36.verticalSpace,
                    ],
                  ),
                  Column(
                    children: [
                      Image.asset(
                        'assets/images/info/info_2.png',
                        width: 263.w,
                        height: 245.h,
                      ),
                      Spacer(),
                      Text('It’s easy to find\n your employees\n here with us',
                          textAlign: TextAlign.center,
                          style: Get.theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 28.sp,
                              color: Colors.black)),
                      20.verticalSpace,
                      Text(
                        "Let’s Recruit",
                        textAlign: TextAlign.center,
                      ),
                      36.verticalSpace,
                    ],
                  )
                ],
                options: CarouselOptions(
                    autoPlay: true,
                    height: 500.h,
                    viewportFraction: 1,
                    autoPlayInterval: const Duration(seconds: 10),
                    onPageChanged: (index, reason) =>
                        controller.currentIndex.value = index),
              ),
              36.verticalSpace,
              Row(
                children: [
                  Spacer(),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.arrow_forward,
                          color: Colors.transparent, size: 32.sp),
                    ),
                  ),
                  ...Iterable.generate(
                      2,
                      (index) => Container(
                            margin: EdgeInsets.symmetric(horizontal: 8.w),
                            height: 6.h,
                            width: 27.w,
                            decoration: BoxDecoration(
                                color: index == controller.currentIndex.value
                                    ? Get.theme.primaryColor
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(64)),
                          )),
                  Spacer(),
                  InkWell(
                    onTap: controller.onNextPressed,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Get.theme.primaryColor,
                          shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Icon(Icons.arrow_forward,
                            color: Colors.white, size: 32.sp),
                      ),
                    ),
                  ),
                ],
              ),
              68.verticalSpace
            ],
          ),
        ),
      ));
    });
  }
}
