import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class CrewSignInController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isVerifying = false.obs;
  RxBool shouldObscure = true.obs;

  FToast fToast = FToast();
  final parentKey = GlobalKey();

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  verify() async {
    isVerifying.value = true;
    try {
      // await FirebaseAuth.instance.signOut();
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    isVerifying.value = false;
    bool? emailVerified = FirebaseAuth.instance.currentUser?.emailVerified;
    if (emailVerified == true) {
      fToast.showToast(child: successToast("Authentication Successful"));
      Get.offAllNamed(Routes.HOME);
    } else if (emailVerified == false) {
      await FirebaseAuth.instance.signOut();
      fToast.showToast(child: errorToast("Email Not Verified"));
    } else {
      fToast.showToast(child: errorToast("Authentication Failed"));
    }
  }
}
