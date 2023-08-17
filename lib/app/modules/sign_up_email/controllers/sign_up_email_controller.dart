import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/change_password/controllers/change_password_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';

class SignUpEmailController extends GetxController with RequiresRecentLogin {
  // SignUpEmailArguments? args;
  SignUpType? signUpType = UserStates.instance.isCrew == true
      ? SignUpType.crew
      : UserStates.instance.employerType;

  final parentKey = GlobalKey();

  TextEditingController fullNameController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool shouldObscure = true.obs;
  RxBool isAdding = false.obs;

  FToast fToast = FToast();

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    /* if (Get.arguments is SignUpEmailArguments) {
      args = (Get.arguments as SignUpEmailArguments);
      signUpType = args?.signUpType;
    } */

    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  Future<void>? storeData() async {
    await Future.wait<void>([
      PreferencesHelper.instance.setCompanyName(fullNameController.text) ??
          Future.value(),
      PreferencesHelper.instance.setWebsite(websiteController.text) ??
          Future.value()
    ]);
  }

  Future<void> addEmailCore() async {
    isAdding.value = true;
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName(fullNameController.text);
        FirebaseAuth.instance.currentUser;
      } else {
        await FirebaseAuth.instance.currentUser?.linkWithCredential(
            EmailAuthProvider.credential(
                email: emailController.text,
                password: passwordController.text));
      }

      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      Get.toNamed(Routes.EMAIL_VERIFICATION_WAITING);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        fToast.safeShowToast(child: errorToast("Password is too weak"));
      } else if (e.code == 'email-already-in-use') {
        await FirebaseAuth.instance.signOut();
        Get.toNamed(Routes.CREW_SIGN_IN_EMAIL);
        fToast.safeShowToast(
            child: errorToast(
                "An account already exists for that email. Please Login"));
      } else if (e.code == "requires-recent-login") {
        taskAfterReAuthentication = addEmailCore;
        await reAuthenticateOTPDecision();
      } else {
        fToast.safeShowToast(child: errorToast(e.message ?? ""));
      }
    } catch (e) {
      fToast.safeShowToast(
          child: errorToast("Unable to process your request."));
    }
    isAdding.value = false;
  }

  addEmail() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    isAdding.value = true;
    await storeData();
    try {
      if (FirebaseAuth.instance.currentUser == null) {
        final credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
        await FirebaseAuth.instance.currentUser
            ?.updateDisplayName(fullNameController.text);
        FirebaseAuth.instance.currentUser;
      } else {
        await FirebaseAuth.instance.currentUser?.linkWithCredential(
            EmailAuthProvider.credential(
                email: emailController.text,
                password: passwordController.text));
      }

      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      Get.toNamed(Routes.EMAIL_VERIFICATION_WAITING);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        fToast.safeShowToast(child: errorToast("Password is too weak"));
      } else if (e.code == 'email-already-in-use') {
        await FirebaseAuth.instance.signOut();
        Get.toNamed(Routes.CREW_SIGN_IN_EMAIL);
        fToast.safeShowToast(
            child: errorToast(
                "An account already exists for that email. Please Login"));
      } else if (e.code == "requires-recent-login") {
        taskAfterReAuthentication = addEmailCore;
        await reAuthenticateOTPDecision();
      } else {
        fToast.safeShowToast(child: errorToast(e.message ?? ""));
      }
    } catch (e) {
      fToast.safeShowToast(
          child: errorToast("Unable to process your request."));
    }
    isAdding.value = false;
  }
}

enum SignUpType {
  crew,
  employerITF,
  employerManagementCompany,
  employerCrewingAgent;

  int get backendIndex {
    switch (this) {
      case SignUpType.crew:
        return 2;
      case SignUpType.employerITF:
        return 3;
      case SignUpType.employerManagementCompany:
        return 4;
      case SignUpType.employerCrewingAgent:
        return 5;
    }
  }
}

class SignUpEmailArguments {
  final String? verificationId;
  final String? smsCode;
  final SignUpType signUpType;
  const SignUpEmailArguments(
      {this.smsCode, this.verificationId, required this.signUpType});
}
