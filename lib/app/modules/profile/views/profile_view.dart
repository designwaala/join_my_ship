import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        appBar: AppBar(
          title: const Text('My Profile'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      28.verticalSpace,
                      Center(
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: controller.updateImage,
                              child: controller.pickedImage.value == null
                                  ? CachedNetworkImage(
                                      imageUrl: controller
                                                  .crewUser.value?.profilePic ==
                                              null
                                          ? ""
                                          : "$baseURL/${controller.crewUser.value?.profilePic}",
                                      height: 100.h,
                                      width: 100.h,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Get.theme.primaryColor),
                                          shape: BoxShape.circle,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover)),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                              image: Image.file(File(controller
                                                      .pickedImage.value!.path))
                                                  .image,
                                              fit: BoxFit.cover)),
                                    ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                    padding: EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                        color: Colors.grey.withOpacity(0.2),
                                        shape: BoxShape.circle),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20.sp,
                                    )))
                          ],
                        ),
                      ),
                      16.verticalSpace,
                      Center(
                        child: Text(
                            FirebaseAuth.instance.currentUser?.displayName ??
                                "",
                            style: Get.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700, fontSize: 18)),
                      ),
                      4.verticalSpace,
                      Center(
                        child: Text(controller.rank,
                            style: Get.textTheme.bodyMedium?.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.grey)),
                      ),
                      24.verticalSpace,
                      if (FirebaseAuth.instance.currentUser?.phoneNumber ==
                              null ||
                          FirebaseAuth
                                  .instance.currentUser?.phoneNumber?.isEmpty ==
                              true) ...[
                        InkWell(
                          onTap: () async {
                            await Get.toNamed(Routes.CREW_SIGN_IN_MOBILE);
                            controller.refresh();
                          },
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 4.w),
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            height: 48.h,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Get.theme.primaryColor),
                                borderRadius: BorderRadius.circular(16.r),
                                color: Color.fromRGBO(59, 61, 146, 0.15)),
                            child: Row(
                              children: [
                                16.horizontalSpace,
                                Icon(
                                  Icons.info,
                                  color: Get.theme.primaryColor,
                                ),
                                12.horizontalSpace,
                                Text("Please update your contact details first",
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                                Spacer(),
                                Icon(Icons.arrow_forward_sharp,
                                    color: Get.theme.primaryColor),
                                12.horizontalSpace
                              ],
                            ),
                          ),
                        ),
                        24.verticalSpace,
                      ],
                      InkWell(
                        onTap: () async {
                          FilePickerResult? result =
                              await FilePicker.platform.pickFiles();
                          if (result == null) {
                            return;
                          }
                          if (!["doc", "docx", "pdf"]
                              .contains(result.files.single.extension ?? "")) {
                            controller.fToast.showToast(
                                child: errorToast(
                                    "Please pick your resume in supported file format"));
                            return;
                          }

                          if (result.files.single.path != null) {
                            controller.pickedResume.value =
                                File(result.files.single.path!);
                            controller.updateResume();
                          } else {
                            controller.pickedResume.value = null;
                          }
                        },
                        child: Container(
                          height: 55.h,
                          margin: EdgeInsets.symmetric(horizontal: 22.w),
                          padding: EdgeInsets.symmetric(
                              horizontal: 18.w, vertical: 6.h),
                          decoration: BoxDecoration(
                            color: Get.theme.primaryColor,
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("My Resume",
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 14,
                                                color: Colors.white)),
                                    Text(
                                        controller.crewUser.value?.resume
                                                ?.split("/")
                                                .lastOrNull ??
                                            "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(color: Colors.white))
                                  ],
                                ),
                              ),
                              4.horizontalSpace,
                              Icon(Icons.file_open, color: Colors.white)
                            ],
                          ),
                        ),
                      ),
                      28.verticalSpace,
                      Text("Options",
                          style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18.sp)),
                      ...[
                        CardObject(
                            iconPath: "assets/images/profile/edit_profile.png",
                            text: "Edit Profile",
                            onTap: () {}),
                        CardObject(
                            iconPath: "assets/images/profile/wallet.png",
                            text: "Wallet",
                            onTap: () {}),
                        CardObject(
                            iconPath:
                                "assets/images/profile/my_subscription.png",
                            text: "My Subscriptions",
                            onTap: () {}),
                        CardObject(
                            iconPath:
                                "assets/images/profile/change_password.png",
                            text: "Change Password",
                            onTap: () {}),
                        CardObject(
                            iconPath: "assets/images/profile/help.png",
                            text: "Help & Feedback",
                            onTap: () {}),
                      ].map((e) => Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 16.h, horizontal: 14.h),
                            margin: EdgeInsets.symmetric(vertical: 8.h),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16.r)),
                            child: Row(
                              children: [
                                Image.asset(
                                  e.iconPath,
                                  height: 24.h,
                                  width: 24.h,
                                ),
                                18.horizontalSpace,
                                Text(e.text,
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14.sp,
                                    )),
                                Spacer(),
                                Icon(Icons.keyboard_arrow_right)
                              ],
                            ),
                          )),
                      InkWell(
                        onTap: () async {
                          await FirebaseAuth.instance.signOut();
                          await PreferencesHelper.instance.clearAll();
                          Get.offAllNamed(Routes.SPLASH);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16.h, horizontal: 14.h),
                          margin: EdgeInsets.symmetric(vertical: 8.h),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r)),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/profile/sign_out.png",
                                height: 24.h,
                                width: 24.h,
                              ),
                              18.horizontalSpace,
                              Text("Log Out",
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red)),
                              Spacer(),
                              Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                      36.verticalSpace,
                      Center(
                        child: Text("Terms and conditions",
                            style: Get.textTheme.bodyMedium?.copyWith(
                                fontSize: 8.sp, color: Get.theme.primaryColor)),
                      ),
                      6.verticalSpace,
                      Center(
                        child: Text("www.joinmyship.com",
                            style: Get.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                                fontSize: 10.sp,
                                fontWeight: FontWeight.w400)),
                      ),
                      28.verticalSpace
                    ],
                  ),
                );
        }));
  }
}

class CardObject {
  final String iconPath;
  final String text;
  final Function onTap;

  const CardObject(
      {required this.iconPath, required this.text, required this.onTap});
}
