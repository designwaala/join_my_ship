import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/modules/choose_user/controllers/choose_user_controller.dart';
import 'package:join_mp_ship/app/modules/email_verification_waiting/controllers/email_verification_waiting_controller.dart';
import 'package:join_mp_ship/app/modules/sign_up_email/controllers/sign_up_email_controller.dart';

import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/extensions/string_extensions.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class SplashController extends GetxController
    with GetTickerProviderStateMixin, RedirectionMixin {
  late AnimationController animationController;
  final parentKey = GlobalKey();

  @override
  void onInit() {
    animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    super.onInit();
    animationController.forward(from: 0);
    redirection();
  }

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }

  @override
  void dispose() {
    super.dispose();
  }
}

mixin RedirectionMixin {
  FToast fToast = FToast();
  CrewUser? user;
  Future<void> redirection({Function? customRedirection}) async {
    try {
      await Future.wait([
        FirebaseAuth.instance.currentUser == null
            ? Future.value(null)
            : getIt<CrewUserProvider>()
                .getCrewUser()
                .then((value) => user = value),
        Future.delayed(const Duration(seconds: 3))
      ]);
    } catch (e) {
      print("$e");
    }
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.signOut();
      await PreferencesHelper.instance.clearAll();
      Get.offAllNamed(Routes.INFO);
      return;
    }
    if (PreferencesHelper.instance.employerType == null &&
        user?.userTypeKey != null) {
      await PreferencesHelper.instance.setEmployerType(user!.userTypeKey!);
    }

    //USER WAS NOT CREATED ON DJANGO
    if (user == null) {
      if (FirebaseAuth.instance.currentUser?.email == null) {
        if (PreferencesHelper.instance.isCrew == null) {
          Get.offAllNamed(Routes.CHOOSE_USER);
        } else if (PreferencesHelper.instance.isCrew == true ||
            PreferencesHelper.instance.employerType != null) {
          Get.offAllNamed(Routes.SIGN_UP_EMAIL);
        } else {
          Get.offAllNamed(Routes.CHOOSE_EMPLOYER);
        }
        return;
      }

      if (FirebaseAuth.instance.currentUser?.emailVerified == true) {
        if (PreferencesHelper.instance.isCrew == null) {
          Get.offAllNamed(Routes.CHOOSE_USER,
              arguments: ChooseUserArguments(redirection: () {
            if (PreferencesHelper.instance.isCrew == true) {
              Get.offAllNamed(Routes.CREW_ONBOARDING);
            } else if (PreferencesHelper.instance.employerType == null) {
              Get.offAllNamed(Routes.CHOOSE_EMPLOYER);
            } else {
              Get.offAllNamed(Routes.EMPLOYER_CREATE_USER);
            }
          }));
        } else if (PreferencesHelper.instance.isCrew == true) {
          Get.offAllNamed(Routes.CREW_ONBOARDING);
        } else if (PreferencesHelper.instance.employerType == null) {
          Get.offAllNamed(Routes.CHOOSE_EMPLOYER);
        } else {
          Get.offAllNamed(Routes.EMPLOYER_CREATE_USER);
        }
      } else {
        fToast.safeShowToast(child: errorToast("Email Not Verified"));
        Get.offAllNamed(Routes.EMAIL_VERIFICATION_WAITING,
            arguments: EmailVerificationArguments(redirection: () {
          Get.offAllNamed(Routes.SPLASH);
        }));
      }

      return;
    }
    if (customRedirection != null) {
      customRedirection.call();
      return;
    }
    //CREW FLOW
    if (PreferencesHelper.instance.isCrew == true || user?.userTypeKey == 2) {
      if (FirebaseAuth.instance.currentUser?.emailVerified != true) {
        fToast.safeShowToast(child: errorToast("Email Not Verified"));
        Get.offAllNamed(Routes.EMAIL_VERIFICATION_WAITING,
            arguments: const EmailVerificationArguments(isCrew: true));
      } else if (user?.screenCheck == 3) {
        if (user?.isVerified == 1) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
        }
      } else {
        Get.offAllNamed(Routes.CREW_ONBOARDING);
      }
      return;
    }
    //EMPLOYER FLOW
    else {
      if (PreferencesHelper.instance.employerType == null ||
          FirebaseAuth.instance.currentUser?.phoneNumber == null) {
        Get.offAllNamed(Routes.CHOOSE_EMPLOYER);
      } else if (FirebaseAuth.instance.currentUser?.email?.nullIfEmpty() ==
          null) {
        Get.offAllNamed(Routes.SIGN_UP_EMAIL);
      } else if (FirebaseAuth.instance.currentUser?.emailVerified != true) {
        fToast.safeShowToast(child: errorToast("Email Not Verified"));
        Get.offAllNamed(Routes.EMAIL_VERIFICATION_WAITING,
            arguments: const EmailVerificationArguments(isCrew: false));
      } else if (user?.screenCheck == 1) {
        if (user?.isVerified == 1) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
        }
      } else {
        Get.offAllNamed(Routes.EMPLOYER_CREATE_USER);
      }
      return;
    }
  }
}
