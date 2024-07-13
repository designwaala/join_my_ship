import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/crew_user_model.dart';
import 'package:join_my_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_my_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_my_ship/app/modules/crew_sign_in_mobile/controllers/crew_sign_in_mobile_controller.dart';
import 'package:join_my_ship/app/modules/employer_create_user/controllers/employer_create_user_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/utils/remote_config.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';
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
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      28.verticalSpace,
                      Center(
                        child: Stack(
                          children: [
                            InkWell(
                              onTap: controller.crewUser.value?.isVerified == 1
                                  ? controller.updateImage
                                  : null,
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
                          onTap: controller.crewUser.value?.isVerified == 1
                              ? () async {
                                  Map<String, dynamic> result =
                                      await Get.toNamed(
                                          Routes.CREW_SIGN_IN_MOBILE,
                                          arguments: CrewSignInMobileArguments(
                                              isUpdateView: true,
                                              redirection:
                                                  (phoneNumber, dialCode) {
                                                Get.back(result: {
                                                  "phone_number": phoneNumber,
                                                  "dial_code": dialCode
                                                });
                                              }));
                                  if (result['dial_code'] != null &&
                                      result['phone_number'] != null) {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => AlertDialog(
                                              shape: alertDialogShape,
                                              title: Text(
                                                  "Please wait while we update your phone number"),
                                              content: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator()
                                                ],
                                              ),
                                            ));
                                    await getIt<CrewUserProvider>().updateCrewUser(
                                        crewId: controller.crewUser.value!.id!,
                                        crewUser: CrewUser(
                                            number:
                                                "${result['dial_code']}-${result['phone_number']}"));
                                    Get.back();
                                  }

                                  controller.refresh();
                                }
                              : null,
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 16),
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            height: 48,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Get.theme.primaryColor),
                                borderRadius: BorderRadius.circular(16.r),
                                color: const Color.fromRGBO(59, 61, 146, 0.15)),
                            child: Row(
                              children: [
                                const SizedBox(width: 8),
                                // const Spacer(),
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
                                // const Spacer()
                                const SizedBox(width: 8),
                              ],
                            ),
                          ),
                        ),
                        24.verticalSpace,
                      ],
                      if (controller.crewUser.value?.userTypeKey == 2) ...[
                        InkWell(
                          onTap: controller.crewUser.value?.isVerified == 1
                              ? () async {
                                  final path =
                                      await FlutterDocumentPicker.openDocument(
                                          params: FlutterDocumentPickerParams(
                                    allowedFileExtensions: [
                                      'pdf',
                                      'doc',
                                      'docx'
                                    ],
                                  ));
                                  if (path == null) {
                                    return;
                                  }
                                  controller.pickedResume.value = File(path);
                                  controller.updateResume();
                                }
                              : null,
                          child: Container(
                            height: 62,
                            margin: EdgeInsets.symmetric(horizontal: 22),
                            padding: EdgeInsets.symmetric(
                                horizontal: 18, vertical: 6),
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
                              fontWeight: FontWeight.bold, fontSize: 18)),
                      if (controller.crewUser.value?.userTypeKey == 5 &&
                          !controller.isFreeTrialActivated.value)
                        InkWell(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return Obx(() {
                                    return AlertDialog(
                                      shape: alertDialogShape,
                                      title: const Text("Job Post Plan"),
                                      content: const Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Post 1 Job Everyday"),
                                          SizedBox(height: 4),
                                          Text("Validity: 7 Days")
                                        ],
                                      ),
                                      actions: [
                                        controller.isStartingJobPostPlan.value
                                            ? const SizedBox(
                                                height: 16,
                                                width: 16,
                                                child:
                                                    CircularProgressIndicator())
                                            : FilledButton.tonal(
                                                onPressed:
                                                    controller.startJobPostPlan,
                                                child: const Text("Start Plan"))
                                      ],
                                    );
                                  });
                                });
                          },
                          child: AnimatedBuilder(
                              animation: controller.animationController,
                              builder: (context, _) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 16, horizontal: 14),
                                  margin: EdgeInsets.symmetric(vertical: 8),
                                  decoration: BoxDecoration(
                                      /* gradient: LinearGradient(
                                          transform: GradientRotation(3.14 / 4),
                                          colors: controller.gradientColors), */
                                      color: controller.colorTween.value,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.shade200,
                                            blurRadius: 1,
                                            spreadRadius: 1,
                                            offset: const Offset(1, 1))
                                      ],
                                      borderRadius:
                                          BorderRadius.circular(16.r)),
                                  child: Row(
                                    children: [
                                      Text("Avail 7 Days Free trial",
                                          style: Get.textTheme.titleMedium
                                              ?.copyWith(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold)),
                                      const Spacer(),
                                      const Icon(Icons.keyboard_arrow_right,
                                          color: Colors.white)
                                    ],
                                  ),
                                );
                              }),
                        ),
                      ...[
                        CardObject(
                            verificationRequired: true,
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
                            verificationRequired: true,
                            iconPath: "assets/images/profile/wallet.png",
                            text: "Wallet",
                            onTap: () {
                              Get.toNamed(Routes.WALLET);
                            }),
                        if ([3, 4].contains(controller.crewUser.value?.userTypeKey) &&
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
                            verificationRequired: true,
                            iconPath:
                                "assets/images/profile/my_subscription.png",
                            text: 
                            controller.crewUser.value?.userTypeKey == 2 ?
                            "My Subscriptions" : "Subscriptions",
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
                        /* CardObject(
                            icon: Icons.email_outlined,
                            text: "Change Email",
                            onTap: () {
                              Get.toNamed(Routes.UPDATE_EMAIL);
                            }), */
                        CardObject(
                            svgPath: "assets/icons/refer_and_earn.svg",
                            text: "Refer and Earn",
                            verificationRequired: true,
                            onTap: () {
                              Get.toNamed(Routes.REFER_AND_EARN);
                            }),
                        CardObject(
                          iconPath: "assets/images/profile/help.png",
                          text: "Help & Feedback",
                          onTap: () => Get.toNamed(Routes.HELP),
                        ),
                        if (controller.crewUser.value?.userTypeKey == 2)
                          CardObject(
                            verificationRequired: true,
                            svgPath: "assets/icons/send.svg",
                            text: "Highlight Profile",
                            onTap: controller.highlightCrew,
                          ),
                        if (controller.crewUser.value?.userTypeKey == 2)
                          CardObject(
                              verificationRequired: true,
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
                              if (controller.crewUser.value?.isVerified != 1 &&
                                  e.verificationRequired == true) {
                                controller.fToast.showToast(
                                    child: errorToast(RemoteConfigUtils.instance
                                            .accountUnderVerificationCopy ??
                                        ""));
                                return;
                              }
                              e.onTap();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 14),
                              margin: EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey.shade200,
                                        blurRadius: 1,
                                        spreadRadius: 1,
                                        offset: const Offset(1, 1))
                                  ],
                                  borderRadius: BorderRadius.circular(16.r)),
                              child: Row(
                                children: [
                                  e.icon != null
                                      ? Icon(e.icon!,
                                          color: Get.theme.primaryColor,
                                          size: 20)
                                      : e.svgPath != null
                                          ? SvgPicture.asset(e.svgPath!,
                                              height: e.height ?? 24,
                                              width: e.width ?? 24)
                                          : Image.asset(
                                              e.iconPath ?? "",
                                              height: e.height ?? 24,
                                              width: e.width ?? 24,
                                            ),
                                  18.horizontalSpace,
                                  Text(e.text,
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      )),
                                  const Spacer(),
                                  const Icon(Icons.keyboard_arrow_right)
                                ],
                              ),
                            ),
                          )),
                      if (RemoteConfigUtils.instance.showDeleteAccountButton)
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Obx(() {
                                  return AlertDialog(
                                    shape: alertDialogShape,
                                    title: Text("Delete Account"),
                                    content: Text(
                                        "Are you sure you want to delete your account?"),
                                    actions: [
                                      TextButton(
                                          onPressed: Get.back,
                                          child: Text("NO")),
                                      4.horizontalSpace,
                                      controller.isDeletingAccount.value
                                          ? SizedBox(
                                              height: 16,
                                              width: 16,
                                              child:
                                                  CircularProgressIndicator())
                                          : FilledButton(
                                              onPressed:
                                                  controller.deleteAccount,
                                              child: Text("YES"))
                                    ],
                                  );
                                });
                              });
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 14),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: const Offset(1, 1))
                              ],
                              borderRadius: BorderRadius.circular(16.r)),
                          child: Row(
                            children: [
                              Icon(Icons.delete_outline, color: Colors.red),
                              18.horizontalSpace,
                              Text("Delete Account",
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.red)),
                              const Spacer(),
                              const Icon(Icons.keyboard_arrow_right)
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () async {
                          UserStates.instance.reset();
                          await FirebaseAuth.instance.signOut();
                          await PreferencesHelper.instance.clearAll();
                          Get.offAllNamed(Routes.SPLASH);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 16, horizontal: 14),
                          margin: EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.shade200,
                                    blurRadius: 1,
                                    spreadRadius: 1,
                                    offset: const Offset(1, 1))
                              ],
                              borderRadius: BorderRadius.circular(16.r)),
                          child: Row(
                            children: [
                              Image.asset(
                                "assets/images/profile/sign_out.png",
                                height: 24,
                                width: 24,
                              ),
                              18.horizontalSpace,
                              Text("Log Out",
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                      fontSize: 14,
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
                                  mode: LaunchMode.inAppWebView);
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
                                mode: LaunchMode.inAppWebView);
                          },
                          child: Text("Terms and conditions",
                              style: Get.textTheme.bodyMedium?.copyWith(
                                  fontSize: 12,
                                  color: Get.theme.primaryColor)),
                        ),
                      ),
                      6.verticalSpace,
                      Center(
                        child: Text("www.joinmyship.com",
                            style: Get.textTheme.bodyMedium?.copyWith(
                                color: Colors.grey,
                                fontSize: 14,
                                fontWeight: FontWeight.w400)),
                      ),
                      if (controller.version != null &&
                          controller.buildNumber != null)
                        GestureDetector(
                          onTap: controller.crash,
                          child: Center(
                              child: Text(
                                  "${controller.version} (${controller.buildNumber ?? ""})",
                                  style: Get.textTheme.bodySmall
                                      ?.copyWith(color: Colors.grey))),
                        ),
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
  final bool? verificationRequired;

  const CardObject(
      {this.iconPath,
      this.icon,
      this.svgPath,
      this.height,
      this.width,
      this.verificationRequired,
      required this.text,
      required this.onTap});
}
