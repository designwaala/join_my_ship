import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/widgets/custom_elevated_button.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
import 'package:join_mp_ship/widgets/dropdown_decoration.dart';

import '../controllers/employer_manage_users_controller.dart';

class EmployerManageUsersView extends GetView<EmployerManageUsersController> {
  const EmployerManageUsersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 84,
          title: Text('Users',
              style: Get.theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          backgroundColor: Colors.white,
          elevation: 1,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(32))),
          leading: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Color(0xFFF3F3F3), shape: BoxShape.circle),
                child: const Icon(
                  Icons.keyboard_backspace_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const CircularProgressIndicator()
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      8.verticalSpace,
                      Text("Manage Users",
                          style: Get.textTheme.titleLarge
                              ?.copyWith(color: Get.theme.primaryColor)),
                      16.verticalSpace,
                      Text("Add or remove secondary users from your profile",
                          style: Get.textTheme.bodySmall),
                      32.verticalSpace,
                      ...controller.secondaryUsers.map((secondaryUser) =>
                          Container(
                            margin: const EdgeInsets.all(8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 64.h,
                                  width: 64.h,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              secondaryUser.profilePic ?? ""))),
                                ),
                                16.horizontalSpace,
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(secondaryUser.name ?? "",
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 18.sp)),
                                    Text(secondaryUser.email ?? "")
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
                                        secondaryUser.id
                                    ? CircularProgressIndicator()
                                    : PopupMenuButton(
                                        onSelected: (item) {},
                                        itemBuilder: (BuildContext context) =>
                                            <PopupMenuEntry>[
                                          PopupMenuItem(
                                            onTap: () {
                                              controller.deleteUser(
                                                  secondaryUser.id ?? -1);
                                            },
                                            child: Text("Remove"),
                                          ),
                                        ],
                                      ),
                                16.horizontalSpace
                              ],
                            ),
                          )),
                      8.verticalSpace,
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Obx(() {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(32)),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        32.verticalSpace,
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            IconButton(
                                                onPressed: () {},
                                                icon: Icon(Icons.close,
                                                    color: Colors.transparent)),
                                            Image.asset(
                                              "assets/images/employer_invite/employer_invite.png",
                                              height: 51,
                                              width: 51,
                                            ),
                                            IconButton(
                                                padding: EdgeInsets.zero,
                                                onPressed: Get.back,
                                                icon: Icon(Icons.close)),
                                          ],
                                        ),
                                        16.verticalSpace,
                                        Text("Invite New Members",
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18.sp)),
                                        8.verticalSpace,
                                        Text(
                                            "Send invitation links to team members",
                                            textAlign: TextAlign.center,
                                            style: Get.textTheme.titleSmall
                                                ?.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: Color.fromRGBO(
                                                        89, 89, 89, 1))),
                                        48.verticalSpace,
                                        CustomTextFormField(
                                          controller: controller.newUserEmail,
                                        ),
                                        16.verticalSpace,
                                        controller.isInvitingNewUser.value
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CircularProgressIndicator()
                                                ],
                                              )
                                            : CustomElevatedButon(
                                                onPressed:
                                                    controller.inviteNewUser,
                                                child: Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Text("Invite"),
                                                    8.horizontalSpace,
                                                    Icon(Icons.send, size: 18)
                                                  ],
                                                )),
                                        24.verticalSpace,
                                        Text(
                                            "You can send a maximum of 3 invitation links",
                                            textAlign: TextAlign.center,
                                            style: Get.textTheme.bodyMedium
                                                ?.copyWith(
                                                    color: Colors.grey[500]))
                                      ],
                                    ),
                                  );
                                });
                              });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Align(
                              alignment: Alignment.centerLeft,
                              child: Text("Add new member +",
                                  style: Get.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.sp))),
                        ),
                      ),
                      Spacer(),
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
                          onPressed: () {},
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
                                      ?.copyWith(color: Get.theme.primaryColor))
                            ],
                          )),
                      8.verticalSpace
                    ],
                  ),
                );
        }));
  }
}
