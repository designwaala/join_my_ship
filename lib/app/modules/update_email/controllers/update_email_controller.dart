import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/crew_user_model.dart';
import 'package:join_my_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';

class UpdateEmailController extends GetxController {
  // TextEditingController currentEmailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  RxBool isUpdating = false.obs;

  final formKey = GlobalKey<FormState>();
  FToast fToast = FToast();
  final parentKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  Future<void> updateEmail() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    isUpdating.value = true;
    try {
      await _changeEmailFirebase();
      if (FirebaseAuth.instance.currentUser?.email == emailController.text) {
        await _changeEmailDjango();
      }
      await FirebaseAuth.instance.currentUser?.sendEmailVerification();
      fToast.showToast(child: successToast("Email Updated Successfully"));
      Get.offAllNamed(Routes.SPLASH);
    } on FirebaseException catch (e) {
      switch (e.code) {
        case "requires-recent-login":
          try {
            UserCredential? credential = await FirebaseAuth.instance.currentUser
                ?.reauthenticateWithCredential(EmailAuthProvider.credential(
                    email: FirebaseAuth.instance.currentUser?.email ?? "",
                    password: passwordController.text));
            if (credential != null) {
              _changeEmailFirebase();
              if (FirebaseAuth.instance.currentUser?.email ==
                  emailController.text) {
                _changeEmailDjango();
              }
            }
            await FirebaseAuth.instance.currentUser?.sendEmailVerification();
            fToast.showToast(child: successToast("Email Updated Successfully"));
            Get.offAllNamed(Routes.SPLASH);
          } on FirebaseException catch (e1) {
            switch (e1.code) {
              case 'user-not-found':
                fToast.safeShowToast(child: errorToast("User Not Found"));
                return;
              case "wrong-password":
                fToast.safeShowToast(child: errorToast("Password Incorrect"));
                return;
              case "email-already-in-use":
                fToast.safeShowToast(
                    child: errorToast("This email is already in use"));
                return;
              default:
                fToast.safeShowToast(
                    child: errorToast("Authentication Failed"));
                return;
            }
          }
          return;
        case "email-already-in-use":
          fToast.safeShowToast(
              child: errorToast("This email is already in use"));
      }
      print(e);
    } catch (e) {
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> _changeEmailFirebase() async {
    await FirebaseAuth.instance.currentUser?.updateEmail(emailController.text);
  }

  Future<void> _changeEmailDjango() async {
    final crewUser = await getIt<CrewUserProvider>().updateCrewUser(
        crewId: PreferencesHelper.instance.userId ?? -1,
        crewUser: CrewUser(email: emailController.text));
  }

  @override
  void onClose() {
    super.onClose();
  }
}
