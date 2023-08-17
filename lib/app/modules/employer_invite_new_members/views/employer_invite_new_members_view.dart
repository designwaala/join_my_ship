import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/widgets/custom_elevated_button.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';

import '../controllers/employer_invite_new_members_controller.dart';

class EmployerInviteNewMembersView
    extends GetView<EmployerInviteNewMembersController> {
  const EmployerInviteNewMembersView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('EMPLOYER'),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/images/employer_invite/employer_invite.png",
                        height: 51,
                        width: 51,
                      ),
                      32.verticalSpace,
                      Text("Invite New Members",
                          style: Get.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 18.sp)),
                      8.verticalSpace,
                      Text("Send invitation links to team members",
                          style: Get.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Color.fromRGBO(89, 89, 89, 1))),
                      64.verticalSpace,
                      Row(
                        children: [
                          Expanded(child: CustomTextFormField()),
                          32.horizontalSpace,
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ))
                        ],
                      ),
                      16.verticalSpace,
                      Row(
                        children: [
                          Expanded(child: CustomTextFormField()),
                          32.horizontalSpace,
                          Container(
                              decoration: BoxDecoration(
                                  color: Colors.grey[700],
                                  shape: BoxShape.circle),
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 18,
                              ))
                        ],
                      ),
                      64.verticalSpace,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Add new member +",
                              style: Get.textTheme.bodyMedium?.copyWith()),
                          CustomElevatedButon(
                              onPressed: () {},
                              child: Row(
                                children: [
                                  Text("Invite"),
                                  4.horizontalSpace,
                                  Icon(Icons.send_sharp)
                                ],
                              ))
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
