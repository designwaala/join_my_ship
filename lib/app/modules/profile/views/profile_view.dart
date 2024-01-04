import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/app/modules/employer_create_user/controllers/employer_create_user_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:url_launcher/url_launcher.dart';

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
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
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
                                              .crewUser.value?.profilePic ??
                                          "",
                                      height: 100.h,
                                      width: 100.h,
                                      imageBuilder: (context, imageProvider) =>
                                          Obx(() {
                                        return Container(
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
                                                    image: NetworkImage(
                                                      controller.crewUser.value
                                                              ?.profilePic ??
                                                          "",
                                                    ),
                                                    fit: BoxFit.cover)),
                                          ),
                                        );
                                      }),
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
                                    padding: const EdgeInsets.all(4),
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
                      if (controller.crewUser.value?.userTypeKey == 2) ...[
                        Center(
                          child: Text(controller.rank,
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey)),
                        ),
                        24.verticalSpace,
                      ] else if ((controller.crewUser.value?.userTypeKey ??
                              0) >=
                          3) ...[
                        Center(
                          child: Text(
                              controller.crewUser.value?.designation ?? "",
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey)),
                        ),
                        2.verticalSpace,
                        Center(
                          child: Text(
                              controller.crewUser.value?.companyName ?? "",
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.grey)),
                        ),
                        24.verticalSpace,
                      ],
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
                            margin: EdgeInsets.symmetric(horizontal: 16.w),
                            padding: EdgeInsets.symmetric(horizontal: 4.w),
                            height: 48.h,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Get.theme.primaryColor),
                                borderRadius: BorderRadius.circular(16.r),
                                color: const Color.fromRGBO(59, 61, 146, 0.15)),
                            child: Row(
                              children: [
                                const Spacer(),
                                Icon(
                                  Icons.info,
                                  color: Get.theme.primaryColor,
                                ),
                                const Spacer(),
                                Text("Please update your contact details first",
                                    style: Get.textTheme.bodyMedium?.copyWith(
                                        color: Get.theme.primaryColor,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12)),
                                const Spacer(),
                                Icon(Icons.arrow_forward_sharp,
                                    color: Get.theme.primaryColor),
                                const Spacer()
                              ],
                            ),
                          ),
                        ),
                        24.verticalSpace,
                      ],
                      if (controller.crewUser.value?.userTypeKey == 2) ...[
                        InkWell(
                          onTap: () async {
                            final path =
                                await FlutterDocumentPicker.openDocument(
                                    params: FlutterDocumentPickerParams(
                              allowedFileExtensions: ['pdf', 'doc', 'docx'],
                            ));
                            if (path == null) {
                              return;
                            }
                            controller.pickedResume.value = File(path);
                            controller.updateResume();
                          },
                          child: Container(
                            height: 62.h,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                const Icon(Icons.file_open, color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                        28.verticalSpace,
                      ],
                      Text("Options",
                          style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18.sp)),
                      ...[
                        CardObject(
                            iconPath: "assets/images/profile/edit_profile.png",
                            text: "Edit Profile",
                            onTap: () async {
                              if (controller.crewUser.value?.userTypeKey == 2) {
                                await Get.toNamed(Routes.CREW_ONBOARDING,
                                    arguments: const CrewOnboardingArguments(
                                        editMode: true));
                              } else {
                                await Get.toNamed(Routes.EMPLOYER_CREATE_USER,
                                    arguments:
                                        const EmployerCreateUserArguments(
                                            editMode: true));
                              }
                              controller.crewUser.value =
                                  UserStates.instance.crewUser;
                            }),
                        CardObject(
                            iconPath: "assets/images/profile/wallet.png",
                            text: "Wallet",
                            onTap: () {}),
                        if (controller.crewUser.value?.userTypeKey == 3 &&
                            controller.crewUser.value?.isPrimaryUser == true)
                          CardObject(
                              iconPath:
                                  "assets/images/profile/manage_users.png",
                              text: "Manage User",
                              onTap: () {
                                Get.toNamed(Routes.EMPLOYER_MANAGE_USERS);
                              }),
                        // if (controller.crewUser.value?.userTypeKey == 3)
                        CardObject(
                            iconPath:
                                "assets/images/profile/my_subscription.png",
                            text: "My Subscriptions",
                            onTap: () {
                              Get.toNamed(Routes.SUBSCRIPTIONS);
                            }),
                        CardObject(
                            iconPath:
                                "assets/images/profile/change_password.png",
                            text: "Change Password",
                            onTap: () {
                              Get.toNamed(Routes.CHANGE_PASSWORD);
                            }),
                        CardObject(
                          iconPath: "assets/images/profile/help.png",
                          text: "Help & Feedback",
                          onTap: () => Get.toNamed(Routes.HELP),
                        ),
                        if (controller.crewUser.value?.userTypeKey == 2)
                          CardObject(
                            svgPath: "assets/icons/send.svg",
                            text: "Highlight Profile",
                            onTap: controller.highlightCrew,
                          ),
                        if (controller.crewUser.value?.userTypeKey == 2)
                          CardObject(
                              iconPath:
                                  "assets/images/profile/my_subscription.png",
                              text: "Boost Profile",
                              onTap: controller.boostCrew),
                        /* if (controller.crewUser.value?.userTypeKey == 2)
                          CardObject(
                            iconPath: "assets/images/profile/help.png",
                            text: "Crew Referral",
                            onTap: () {
                              Get.toNamed(Routes.CREW_REFERRAL);
                            },
                          ), */
                      ].map((e) => InkWell(
                            onTap: () {
                              e.onTap();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16.h, horizontal: 14.h),
                              margin: EdgeInsets.symmetric(vertical: 8.h),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: Offset(1, 1))
                                  ],
                                  borderRadius: BorderRadius.circular(16.r)),
                              child: Row(
                                children: [
                                  e.icon != null
                                      ? Icon(e.icon!,
                                          color: Get.theme.primaryColor)
                                      : e.svgPath != null
                                          ? SvgPicture.asset(e.svgPath!,
                                              height: e.height ?? 24.h,
                                              width: e.width ?? 24.h)
                                          : Image.asset(
                                              e.iconPath ?? "",
                                              height: e.height ?? 24.h,
                                              width: e.width ?? 24.h,
                                            ),
                                  18.horizontalSpace,
                                  Text(e.text,
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                      )),
                                  const Spacer(),
                                  const Icon(Icons.keyboard_arrow_right)
                                ],
                              ),
                            ),
                          )),
                      InkWell(
                        onTap: () async {
                          UserStates.instance.reset();
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
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: Offset(1, 1))
                              ],
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
                              const Spacer(),
                              const Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                      36.verticalSpace,
                      Center(
                        child: InkWell(
                            onTap: () {
                              launchUrl(
                                  Uri.parse(
                                      "https://joinmyship.com/privacypolicy/"),
                                  mode: LaunchMode.externalApplication);
                            },
                            child: Text("Privacy Policy",
                                style: Get.textTheme.bodyMedium
                                    ?.copyWith(color: Get.theme.primaryColor))),
                      ),
                      8.verticalSpace,
                      Center(
                        child: InkWell(
                          onTap: () {
                            launchUrl(
                                Uri.parse(
                                    "https://joinmyship.com/termsandconditions/"),
                                mode: LaunchMode.externalApplication);
                          },
                          child: Text("Terms and conditions",
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  fontSize: 12.sp,
                                  color: Get.theme.primaryColor)),
                        ),
                      ),
                      6.verticalSpace,
                      Center(
                        child: Text("www.joinmyship.com",
                            style: Get.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400)),
                      ),
                      if (controller.version != null &&
                          controller.buildNumber != null)
                        Center(
                            child: Text(
                                "${controller.version} (${controller.buildNumber ?? ""})",
                                style: Get.textTheme.bodySmall
                                    ?.copyWith(color: Colors.grey))),
                      28.verticalSpace
                    ],
                  ),
                );
        }));
  }
}

class CardObject {
  final String? svgPath;
  final String? iconPath;
  final IconData? icon;
  final String text;
  final Function onTap;
  final double? height;
  final double? width;

  const CardObject(
      {this.iconPath,
      this.icon,
      this.svgPath,
      this.height,
      this.width,
      required this.text,
      required this.onTap});
}
