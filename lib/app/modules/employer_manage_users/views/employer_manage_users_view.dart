import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/widgets/custom_elevated_button.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
import 'package:join_mp_ship/widgets/dropdown_decoration.dart';

import '../controllers/employer_manage_users_controller.dart';

class EmployerManageUsersView extends GetView<EmployerManageUsersController> {
  const EmployerManageUsersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        appBar: AppBar(
          title: const Text('Manage Users'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? Center(child: const CircularProgressIndicator())
              : CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            8.verticalSpace,
                            16.verticalSpace,
                            Text(
                                "Add or remove secondary users from your profile",
                                style: Get.textTheme.bodySmall),
                            32.verticalSpace,
                            ...controller.subUsers
                                .where((p0) =>
                                    p0.id != PreferencesHelper.instance.userId)
                                .map((subUser) => subUser.id ==
                                        controller.userBeingDeleted.value
                                    ? const CircularProgressIndicator()
                                    : Container(
                                        margin: const EdgeInsets.all(8),
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4, vertical: 16),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            if (subUser.profilePic != null)
                                              Container(
                                                height: 64.h,
                                                width: 64.h,
                                                decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: NetworkImage(
                                                            subUser.profilePic ??
                                                                ""))),
                                              ),
                                            16.horizontalSpace,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                if (subUser.firstName != null &&
                                                    subUser.lastName != null)
                                                  Text(
                                                      "${subUser.firstName ?? ""} ${subUser.lastName ?? ""}",
                                                      style: Get.textTheme
                                                          .titleSmall),
                                                Text(subUser.email ?? ""),
                                                if (subUser.addressLine1 ==
                                                    null)
                                                  Text("Onboarding Pending",
                                                      style: Get
                                                          .textTheme.bodySmall)
                                              ],
                                            ),
                                            const Spacer(),
                                            /*  DropdownButtonHideUnderline(
                                  child: DropdownButton2(
                                    buttonStyleData: ButtonStyleData(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8),
                                    ),
                                    hint: SizedBox(),
                                    isDense: true,
                                    iconStyleData: const IconStyleData(
                                        icon: Icon(Icons.more_vert)),
                                    items: [
                                      DropdownMenuItem(child: Text("Remove"))
                                    ],
                                  ),
                                ), */
                                            controller.userBeingDeleted.value ==
                                                    subUser.id
                                                ? const CircularProgressIndicator()
                                                : PopupMenuButton(
                                                    onSelected: (item) {},
                                                    itemBuilder: (BuildContext
                                                            context) =>
                                                        <PopupMenuEntry>[
                                                      PopupMenuItem(
                                                        onTap: () {
                                                          controller.deleteUser(
                                                              subUser.id ?? -1);
                                                        },
                                                        child: const Text(
                                                            "Remove"),
                                                      ),
                                                    ],
                                                  ),
                                            16.horizontalSpace
                                          ],
                                        ),
                                      )),
                            8.verticalSpace,
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: TextButton.icon(
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Obx(() {
                                            return AlertDialog(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          32)),
                                              content: SingleChildScrollView(
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    32.verticalSpace,
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        IconButton(
                                                            onPressed: () {},
                                                            icon: const Icon(
                                                                Icons.close,
                                                                color: Colors
                                                                    .transparent)),
                                                        Image.asset(
                                                          "assets/images/employer_invite/employer_invite.png",
                                                          height: 51,
                                                          width: 51,
                                                        ),
                                                        IconButton(
                                                            padding:
                                                                EdgeInsets.zero,
                                                            onPressed: Get.back,
                                                            icon: const Icon(
                                                                Icons.close)),
                                                      ],
                                                    ),
                                                    16.verticalSpace,
                                                    Text("Invite New Members",
                                                        style: Get.textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    18.sp)),
                                                    8.verticalSpace,
                                                    Text(
                                                        "Send invitation links to team members",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Get.textTheme
                                                            .titleSmall
                                                            ?.copyWith(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500,
                                                                color: const Color
                                                                        .fromRGBO(
                                                                    89,
                                                                    89,
                                                                    89,
                                                                    1))),
                                                    48.verticalSpace,
                                                    CustomTextFormField(
                                                      controller: controller
                                                          .newUserEmail,
                                                    ),
                                                    16.verticalSpace,
                                                    controller.isInvitingNewUser
                                                            .value
                                                        ? const Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              CircularProgressIndicator()
                                                            ],
                                                          )
                                                        : CustomElevatedButon(
                                                            onPressed: controller
                                                                .inviteNewUser,
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .min,
                                                              children: [
                                                                const Text(
                                                                    "Invite"),
                                                                8.horizontalSpace,
                                                                const Icon(
                                                                    Icons.send,
                                                                    size: 18)
                                                              ],
                                                            )),
                                                    24.verticalSpace,
                                                    Text(
                                                        "You can send a maximum of 3 invitation links",
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: Get.textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                                color: Colors
                                                                    .grey[500]))
                                                  ],
                                                ),
                                              ),
                                            );
                                          });
                                        });
                                  },
                                  icon: Icon(Icons.add),
                                  label: Text("Add new member"),
                                ),
                              ),
                            ),
                            const Spacer(),
                            Text("You can add a maximum of 3 users",
                                style: Get.textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey[600])),
                            8.verticalSpace,
                            CustomElevatedButon(
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(64),
                                    ),
                                    backgroundColor: Colors.white),
                                onPressed: () => Get.toNamed(Routes.HELP),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.mail,
                                      color: Get.theme.primaryColor,
                                    ),
                                    4.horizontalSpace,
                                    Text("Contact Us",
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(
                                                color: Get.theme.primaryColor))
                                  ],
                                )),
                            8.verticalSpace
                          ]),
                    )
                  ],
                );
        }));
  }
}
