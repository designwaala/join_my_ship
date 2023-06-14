import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/profile/views/profile_view.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Scaffold(
        body: () {
          switch (controller.currentIndex.value) {
            case 1:
              return _buildBody();
            case 2:
              return SizedBox();
            case 3:
              return SizedBox();
            case 4:
              return SizedBox();
            case 5:
              return ProfileView();
            default:
              return SizedBox();
          }
        }(),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: CurvedNavigationBar(
          height: 64,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.white ?? Get.theme.primaryColor,
          items: bottomIcons.map((e) => e.icon).toList(),
          onTap: (index) {
            controller.currentIndex.value = index + 1;
            //Handle button tap
          },
        ),
      );
    });
  }
}

_buildBody() {
  return Column(
    children: [
      Stack(
        children: [
          ClipPath(
            clipper:
                CustomShape(), // this is my own class which extendsCustomClipper
            child: Container(
              height: 240,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromRGBO(1, 66, 211, 1),
                Color.fromRGBO(64, 123, 255, 1)
              ])),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  (Get.statusBarHeight).verticalSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.horizontalSpace,
                      const Icon(Icons.menu_sharp, color: Colors.white),
                      16.horizontalSpace,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Welcome",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white)),
                          Text("Ashutosh Mehta",
                              style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white))
                        ],
                      ),
                      const Spacer(),
                      const Icon(Icons.notifications, color: Colors.white),
                      16.horizontalSpace
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 28,
            right: 28,
            child: TextFormField(
              decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  hintText: "Search job here...",
                  prefixIcon: Icon(Icons.search, color: Get.theme.primaryColor),
                  border: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(64))),
            ),
          ),
        ],
      ),
      Expanded(
          child: ListView(
        children: [
          32.verticalSpace,
          Stack(
            children: [
              Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                height: 95.h,
                width: double.maxFinite,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22.r),
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(1, 66, 211, 1),
                      Color.fromRGBO(92, 197, 255, 1)
                    ])),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    10.verticalSpace,
                    Text("Recommended Jobs",
                        style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white)),
                    6.verticalSpace,
                    Text(
                        "See our recommended jobs for \nyou based on your rank",
                        style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white))
                  ],
                ),
              ),
              Positioned(
                right: 32,
                top: 0,
                child: Image.asset(
                  "assets/images/dashboard/recommended_jobs.png",
                  height: 94.h,
                  width: 99.w,
                ),
              )
            ],
          ),
          16.verticalSpace,
          Row(
            children: [
              28.horizontalSpace,
              Text("Top Listed Companies",
                  style: Get.textTheme.bodyMedium
                      ?.copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text("More",
                  style: Get.textTheme.bodyMedium
                      ?.copyWith(color: Get.theme.primaryColor)),
              28.horizontalSpace
            ],
          ),
          16.verticalSpace,
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 8,
                      spreadRadius: 2)
                ]),
            child: Row(
              children: [
                Container(
                  height: 50.h,
                  width: 50.h,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(86, 175, 246, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                      child: Text("W",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white))),
                ),
                20.horizontalSpace,
                Flexible(
                  child: Text("Westline Ship Management Pvt. Ltd.",
                      maxLines: 2,
                      style: Get.textTheme.bodyMedium?.copyWith(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 8,
                      spreadRadius: 2)
                ]),
            child: Row(
              children: [
                Container(
                  height: 50.h,
                  width: 50.h,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(254, 151, 56, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                      child: Text("D",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white))),
                ),
                20.horizontalSpace,
                Flexible(
                  child: Text("DW Maritime Pvt. Ltd.",
                      maxLines: 2,
                      style: Get.textTheme.bodyMedium?.copyWith(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 8,
                      spreadRadius: 2)
                ]),
            child: Row(
              children: [
                Container(
                  height: 50.h,
                  width: 50.h,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(14, 164, 199, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                      child: Text("B",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white))),
                ),
                20.horizontalSpace,
                Flexible(
                  child: Text("Bridge Ship Management",
                      maxLines: 2,
                      style: Get.textTheme.bodyMedium?.copyWith(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.r),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.1),
                      blurRadius: 8,
                      spreadRadius: 2)
                ]),
            child: Row(
              children: [
                Container(
                  height: 50.h,
                  width: 50.h,
                  decoration: BoxDecoration(
                      color: const Color.fromRGBO(255, 111, 127, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: const Center(
                      child: Text("R",
                          style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w500,
                              color: Colors.white))),
                ),
                20.horizontalSpace,
                Flexible(
                  child: Text("Rk Shipping Consultants",
                      maxLines: 2,
                      style: Get.textTheme.bodyMedium?.copyWith(
                          fontSize: 16, fontWeight: FontWeight.bold)),
                )
              ],
            ),
          ),
          16.verticalSpace
        ],
      )),
      // 65.verticalSpace
    ],
  );
}

class BottomIcon {
  final Widget icon;
  final String text;

  const BottomIcon({required this.icon, required this.text});
}

List<BottomIcon> bottomIcons = [
  BottomIcon(
      icon: Image.asset(
        "assets/images/dashboard/home.png",
        height: 20,
        width: 20,
      ),
      text: "Home"),
  BottomIcon(
      icon: Image.asset(
        "assets/images/dashboard/discover.png",
        height: 20,
        width: 20,
      ),
      text: "Discover"),
  const BottomIcon(
      icon: Icon(
        Icons.add,
        color: Colors.grey,
      ),
      text: "Add"),
  BottomIcon(
      icon: Image.asset(
        "assets/images/dashboard/jobs.png",
        height: 20,
        width: 20,
      ),
      text: "Jobs"),
  BottomIcon(
      icon: Image.asset(
        "assets/images/dashboard/profile.png",
        height: 20,
        width: 20,
      ),
      text: "Profile"),
];

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
