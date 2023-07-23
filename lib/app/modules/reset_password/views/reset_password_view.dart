import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:text_form_field_validator/text_form_field_validator.dart';

import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends GetView<ResetPasswordController> {
  const ResetPasswordView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.parentKey,
      backgroundColor: const Color(0xFFFbF6FF),
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Reset Password',
            style: Get.theme.textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        leading: InkWell(
          onTap: Get.back,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Color(0xFFF3F3F3), shape: BoxShape.circle),
            child: const Icon(
              Icons.keyboard_backspace_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    14.verticalSpace,
                    Text(
                      "Forgot Password",
                      style: Get.theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    10.verticalSpace,
                    const Text("Please enter your registered email address"),
                    22.verticalSpace,
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Required";
                        }
                        return FormValidator.validate(value,
                            stringFormat: StringFormat.email,
                            stringFormatMessage: "Enter a valid email address");
                      },
                      controller: controller.emailController,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        hintText: "Your email address",
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 20),
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Get.theme.colorScheme.primary,
                                width: 1.5),
                            borderRadius: BorderRadius.circular(64)),
                      ),
                    ),
                    40.verticalSpace,
                    MaterialButton(
                      minWidth: double.infinity,
                      height: 60,
                      color: Colors.blue,
                      textColor: Colors.white,
                      shape: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      onPressed: () {
                        controller.resetPassword();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                      child: const Text(
                        "SUBMIT",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    38.verticalSpace,
                    const Spacer(),
                    const Center(child: Text("New User?")),
                    const Divider(),
                    16.verticalSpace,
                    SizedBox(
                      width: double.maxFinite,
                      height: 64.h,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64))),
                          onPressed: () {
                            Get.offAndToNamed(Routes.CHOOSE_USER);
                          },
                          child: const Text("CREATE ACCOUNT")),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
