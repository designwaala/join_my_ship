import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/login_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/login_provider.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/secure_storage.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';

class CrewSignInController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool isVerifying = false.obs;
  RxBool shouldObscure = true.obs;

  FToast fToast = FToast();
  final parentKey = GlobalKey();

  CrewUser? crewUser;

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
      fToast.safeShowToast(child: successToast("Authentication Successful"));
      crewUser = await getIt<CrewUserProvider>().getCrewUser();
      UserStates.instance.crewUser = crewUser;
      if (crewUser?.userTypeKey == 3) {
        Get.offAllNamed(crewUser?.screenCheck == 1
            ? (crewUser?.isVerified == 1
                ? Routes.HOME
                : Routes.ACCOUNT_UNDER_VERIFICATION)
            : Routes.EMPLOYER_CREATE_USER);
      } else {
        if (crewUser?.screenCheck == 3) {
          if (crewUser?.isVerified == 1) {
            Get.offAllNamed(Routes.HOME);
          } else {
            Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
          }
        } else {
          Get.offAllNamed(Routes.CREW_ONBOARDING,
              arguments: CrewOnboardingArguments(
                  email: emailController.text,
                  password: passwordController.text));
        }
      }
      SecureStorage.instance.password = passwordController.text;
    } else if (emailVerified == false) {
      Get.toNamed(Routes.EMAIL_VERIFICATION_WAITING);
      fToast.safeShowToast(child: errorToast("Email Not Verified"));
    } else {
      fToast.safeShowToast(child: errorToast("Authentication Failed"));
    }
  }
}
