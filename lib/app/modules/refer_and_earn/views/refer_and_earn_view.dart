import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/widgets/custom_text_form_field.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';
import 'package:share_plus/share_plus.dart';

import '../controllers/refer_and_earn_controller.dart';

class ReferAndEarnView extends GetView<ReferAndEarnController> {
  const ReferAndEarnView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        appBar: AppBar(
          title: const Text('Refer & Earn'),
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  children: [
                    Stack(
                      children: [
                        Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(vertical: 24),
                              decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      bottom: Radius.circular(48)),
                                  gradient: LinearGradient(colors: [
                                    Color(0xFF3CA2FF),
                                    Color(0xFF2771E5),
                                    Color(0xFF0F63EA),
                                  ])),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  24.horizontalSpace,
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Refer & Earn",
                                          style: Get.textTheme.headlineSmall
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white)),
                                      RichText(
                                          text: TextSpan(children: [
                                        TextSpan(
                                            text: "Upto ",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: Colors.white)),
                                        TextSpan(
                                            text: "100 Credit Points",
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ])),
                                      const Divider(
                                        color: Colors.white,
                                        thickness: 1,
                                      ),
                                      Text(
                                          "Invite your friends to use Join My Ship App & get 100 credit points when your friend uses your referral code after signup.",
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(color: Colors.white))
                                    ],
                                  )),
                                  Expanded(
                                      child: Image.asset(
                                    "assets/images/refer_and_earn_illustration.png",
                                    height: 208,
                                  )),
                                  24.horizontalSpace
                                ],
                              ),
                            ),
                            32.verticalSpace,
                          ],
                        ),
                        Positioned(
                            left: 48,
                            right: 48,
                            bottom: 6,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    textStyle: Get.textTheme.titleMedium
                                        ?.copyWith(fontWeight: FontWeight.bold),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    backgroundColor: const Color(0xFF2B2E35)),
                                onPressed: () {
                                  Share.share("""
Hey ! 👋

Guess what? I'm loving Join My Ship - it's awesome for finding Jobs on vessels. 😍

You've got to try it too! Use my referral code ${controller.referralCode ?? ""} when you sign up, and we both get sweet rewards! 🎁

Download Join My Ship now:

Let's level up together! 🌈✨
""");
                                },
                                child: const Text("Refer Now")))
                      ],
                    ),
                    24.verticalSpace,
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Column(
                        children: [
                          ...<Map<String, dynamic>>[
                            {
                              "icon": "assets/icons/messsage.svg",
                              "text": "Invite your friends to Join My Ship",
                              "height": 28,
                              "width": 28
                            },
                            {
                              "icon": "assets/icons/book_check.svg",
                              "text": "Your friend uses your referral code"
                            },
                            {
                              "icon": "assets/icons/refer_and_earn.svg",
                              "text":
                                  "You get 100 credit points in your wallet",
                              "height": 16,
                              "width": 16
                            },
                          ].map((e) => Row(
                                children: [
                                  Container(
                                      height: 32,
                                      width: 32,
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8),
                                      // padding: EdgeInsets.all(),
                                      decoration: const BoxDecoration(
                                          color: Color(0xffE2EBFF),
                                          shape: BoxShape.circle),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          SvgPicture.asset(
                                            e["icon"] ?? "",
                                            height:
                                                e["height"]?.toDouble() ?? 20,
                                            width: e["width"]?.toDouble() ?? 20,
                                          ),
                                        ],
                                      )),
                                  16.horizontalSpace,
                                  Text(e["text"] ?? "",
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                          fontWeight: FontWeight.normal,
                                          fontSize: 14))
                                ],
                              )),
                          16.verticalSpace,
                          DottedBorder(
                              radius: const Radius.circular(16),
                              dashPattern: [3, 3],
                              strokeCap: StrokeCap.round,
                              color: Get.theme.primaryColor,
                              borderType: BorderType.RRect,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: IntrinsicHeight(
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Your referral code"),
                                              Text(
                                                  controller.referralCode ?? "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: Get
                                                      .textTheme.bodyMedium
                                                      ?.copyWith(
                                                          fontSize: 35,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Get.theme
                                                              .primaryColor))
                                            ],
                                          )),
                                      8.horizontalSpace,
                                      const VerticalDivider(
                                        thickness: 2,
                                        color: Colors.black,
                                      ),
                                      8.horizontalSpace,
                                      InkWell(
                                        onTap: () async {
                                          await Clipboard.setData(
                                              const ClipboardData(
                                                  text: "your text"));
                                          controller.fToast.showToast(
                                              child:
                                                  successToast("Code Copied!"));
                                        },
                                        child: Text("Copy\nCode",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                ),
                              )),
                          16.verticalSpace,
                          if (controller.allowRefer.value)
                          TextButton(
                              onPressed: () {
                                showModalBottomSheet(
                                    context: context,
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(20))),
                                    showDragHandle: true,
                                    isScrollControlled: true,
                                    builder: (context) {
                                      return Obx(() {
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 24),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text("Enter Referral Code",
                                                  style: Get
                                                      .textTheme.headlineSmall
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold)),
                                              32.verticalSpace,
                                              CustomTextFormField(
                                                  controller: controller
                                                      .codeController),
                                              64.verticalSpace,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  TextButton(
                                                      onPressed: Get.back,
                                                      child:
                                                          const Text("Cancel")),
                                                  16.horizontalSpace,
                                                  controller
                                                          .isApplyingCode.value
                                                      ? const CircularProgressIndicator()
                                                      : FilledButton(
                                                          onPressed: controller
                                                              .applyCode,
                                                          child: const Text(
                                                              "Save"))
                                                ],
                                              ),
                                              32.verticalSpace,
                                              MediaQuery.of(context)
                                                  .viewInsets
                                                  .bottom
                                                  .verticalSpace
                                            ],
                                          ),
                                        );
                                      });
                                    });
                              },
                              child: const Text("Have a referral code?"))
                        ],
                      ),
                    ),
                    24.verticalSpace,
                  ],
                );
        }));
  }
}
