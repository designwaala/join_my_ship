import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/login_model.dart';
import 'package:join_mp_ship/app/data/providers/login_provider.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/secure_storage.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
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
    Login? login;
    isVerifying.value = true;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      try {
        login = await getIt<LoginProvider>().login();
        await PreferencesHelper.instance.setUserCreated(true);
      } catch (e) {
        await PreferencesHelper.instance.setUserCreated(false);
        print("$e");
      }
      print(await FirebaseAuth.instance.currentUser?.getIdToken());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong passYword provided for that user.');
      }
    }
    isVerifying.value = false;
    bool? emailVerified = FirebaseAuth.instance.currentUser?.emailVerified;
    if (emailVerified == true) {
      fToast.showToast(child: successToast("Authentication Successful"));
      Get.offAllNamed(Routes.CREW_ONBOARDING,
          arguments: CrewOnboardingArguments(
              email: emailController.text, password: passwordController.text));
      // if (login?.data?.access == null || login?.data?.refresh == null) {
      //   Get.offAllNamed(Routes.CREW_ONBOARDING,
      //       arguments: CrewOnboardingArguments(
      //           email: emailController.text,
      //           password: passwordController.text));
      // } else {
      //   Get.offAllNamed(Routes.HOME);
      // }
      SecureStorage.instance.password = passwordController.text;
    } else if (emailVerified == false) {
      // await FirebaseAuth.instance.signOut();
      Get.toNamed(Routes.EMAIL_VERIFICATION_WAITING);
      fToast.showToast(child: errorToast("Email Not Verified"));
    } else {
      fToast.showToast(child: errorToast("Authentication Failed"));
    }
  }
}
