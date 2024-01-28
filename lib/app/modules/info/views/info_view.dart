import 'package:cached_network_image/cached_network_image.dart';
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
              const Spacer(),
              CarouselSlider(
                carouselController: controller.carouselController,
                items: controller.infoModel
                    ?.map((e) => Column(
                          children: [
                            CachedNetworkImage(
                              imageUrl: e.imagePath ?? "",
                              width: e.width?.w,
                              height: e.height?.h,
                            ),
                            const Spacer(),
                            Text(e.heading ?? "",
                                textAlign: TextAlign.center,
                                style: Get.theme.textTheme.headlineMedium
                                    ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 28.sp,
                                        color: Colors.black)),
                            20.verticalSpace,
                            Text(
                              e.body ?? "",
                              textAlign: TextAlign.center,
                            ),
                            36.verticalSpace,
                          ],
                        ))
                    .toList(),
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
                  const Spacer(),
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Icon(Icons.arrow_forward,
                          color: Colors.transparent, size: 32.sp),
                    ),
                  ),
                  ...Iterable.generate(
                      controller.infoModel?.length ?? 0,
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
                  const Spacer(),
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
