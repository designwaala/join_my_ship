import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/widgets/custom_text_form_field.dart';

import '../controllers/update_email_controller.dart';

class UpdateEmailView extends GetView<UpdateEmailController> {
  const UpdateEmailView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        appBar: AppBar(
          title: const Text('Update Email'),
          centerTitle: true,
        ),
        body: Obx(() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
                key: controller.formKey,
                child: CustomScrollView(
                  slivers: [
                    SliverFillRemaining(
                      hasScrollBody: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          32.verticalSpace,
                          Text("Please enter your new email",
                              style: Get.textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                          32.verticalSpace,
                          TextFormField(
                            readOnly: true,
                            enabled: false,
                            initialValue:
                                FirebaseAuth.instance.currentUser?.email,
                            decoration: InputDecoration(
                                fillColor: Colors.white,
                                filled: true,
                                hintText: "Password",
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(64))),
                          ),
                          16.verticalSpace,
                          TextFormField(
                              obscureText: true,
                              validator: (value) {
                                return value == null || value.isEmpty == true
                                    ? "Please enter your password"
                                    : null;
                              },
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Password",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(64))),
                              controller: controller.passwordController),
                          32.verticalSpace,
                          TextFormField(
                              decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Your new Email",
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide.none,
                                      borderRadius: BorderRadius.circular(64))),
                              validator: (value) {
                                return RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(value ?? "")
                                    ? null
                                    : "Please enter a valid email";
                              },
                              controller: controller.emailController),
                          32.verticalSpace,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              controller.isUpdating.value
                                  ? const CircularProgressIndicator()
                                  : Expanded(
                                      child: FilledButton(
                                          onPressed: controller.updateEmail,
                                          child: const Text("Update"))),
                            ],
                          ),
                          const Spacer(flex: 1)
                        ],
                      ),
                    )
                  ],
                )),
          );
        }));
  }
}
