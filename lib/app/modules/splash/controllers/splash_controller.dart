import 'package:collection/collection.dart';
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
import 'package:join_mp_ship/utils/user_details.dart';
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
  Function eq = const ListEquality().equals;

  Future<void> getUser() async {
    if (FirebaseAuth.instance.currentUser == null) {
      return;
    } else if (UserStates.instance.crewUser != null) {
      user = UserStates.instance.crewUser;
    } else {
      user = await getIt<CrewUserProvider>().getCrewUser();
      UserStates.instance.crewUser = user;
    }
  }

  Future<void> intentionalDelay() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await Future.delayed(const Duration(seconds: 1));
    } else if (UserStates.instance.crewUser != null) {
      await Future.delayed(const Duration(seconds: 1));
    } else {
      await Future.delayed(const Duration(seconds: 3));
    }
  }

  Future<void> redirection({Function? customRedirection}) async {
    try {
      await Future.wait([getUser(), intentionalDelay()]);
    } catch (e) {
      print("$e");
    }
    if (customRedirection != null) {
      customRedirection.call();
      return;
    }
    if (FirebaseAuth.instance.currentUser == null &&
        user == null &&
        (UserStates.instance.isCrew == null)) {
      return Get.offAllNamed(Routes.INFO);
    }
    if (FirebaseAuth.instance.currentUser != null &&
        user == null &&
        (UserStates.instance.isCrew == null ||
            UserStates.instance.employerType == null)) {
      //ENFORCE CHOOSE USER FLOW
      Get.offAllNamed(Routes.CHOOSE_USER);
      return;
    }

    if (user != null) {
      UserStates.instance.isCrew = user?.userTypeKey == 2;
    }

    List<bool> truths = [
      FirebaseAuth.instance.currentUser != null,
      user != null,
      UserStates.instance.isCrew == true,
      FirebaseAuth.instance.currentUser?.email?.nullIfEmpty() != null,
      FirebaseAuth.instance.currentUser?.emailVerified == true,
      FirebaseAuth.instance.currentUser?.phoneNumber != null
    ];

    if (eq(truths, [false, false, false, false, false, false])) {
      Get.offAllNamed(Routes.SIGN_UP_PHONE_NUMBER);
      return;
    } else if (eq(truths, [false, false, false, false, false, true])) {
      return;
    } else if (eq(truths, [false, false, false, false, true, false])) {
      return;
    } else if (eq(truths, [false, false, false, false, true, true])) {
      return;
    } else if (eq(truths, [false, false, false, true, false, false])) {
      return;
    } else if (eq(truths, [false, false, false, true, false, true])) {
      return;
    } else if (eq(truths, [false, false, false, true, true, false])) {
      return;
    } else if (eq(truths, [false, false, false, true, true, true])) {
      return;
    } else if (eq(truths, [false, false, true, false, false, false])) {
      return Get.offAllNamed(Routes.SIGN_UP_EMAIL);
    } else if (eq(truths, [false, false, true, false, false, true])) {
      return;
    } else if (eq(truths, [false, false, true, false, true, false])) {
      return;
    } else if (eq(truths, [false, false, true, false, true, true])) {
      return;
    } else if (eq(truths, [false, false, true, true, false, false])) {
      return;
    } else if (eq(truths, [false, false, true, true, false, true])) {
      return;
    } else if (eq(truths, [false, false, true, true, true, false])) {
      return;
    } else if (eq(truths, [false, false, true, true, true, true])) {
      return;
    } else if (eq(truths, [false, true, false, false, false, false])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [false, true, false, false, false, true])) {
      return;
    } else if (eq(truths, [false, true, false, false, true, false])) {
      return;
    } else if (eq(truths, [false, true, false, false, true, true])) {
      return;
    } else if (eq(truths, [false, true, false, true, false, false])) {
      return;
    } else if (eq(truths, [false, true, false, true, false, true])) {
      return;
    } else if (eq(truths, [false, true, false, true, true, false])) {
      return;
    } else if (eq(truths, [false, true, false, true, true, true])) {
      return;
    } else if (eq(truths, [false, true, true, false, false, false])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [false, true, true, false, false, true])) {
      return;
    } else if (eq(truths, [false, true, true, false, true, false])) {
      return;
    } else if (eq(truths, [false, true, true, false, true, true])) {
      return;
    } else if (eq(truths, [false, true, true, true, false, false])) {
      return;
    } else if (eq(truths, [false, true, true, true, false, true])) {
      return;
    } else if (eq(truths, [false, true, true, true, true, false])) {
      return;
    } else if (eq(truths, [false, true, true, true, true, true])) {
      return;
    } else if (eq(truths, [true, false, false, false, false, false])) {
      return;
    } else if (eq(truths, [true, false, false, false, false, true])) {
      return Get.offAllNamed(Routes.SIGN_UP_EMAIL);
    } else if (eq(truths, [true, false, false, false, true, false])) {
      return;
    } else if (eq(truths, [true, false, false, false, true, true])) {
      return;
    } else if (eq(truths, [true, false, false, true, false, false])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [true, false, false, true, false, true])) {
      return Get.offAllNamed(Routes.EMAIL_VERIFICATION_WAITING);
    } else if (eq(truths, [true, false, false, true, true, false])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [true, false, false, true, true, true])) {
      return Get.offAllNamed(Routes.EMPLOYER_CREATE_USER);
    } else if (eq(truths, [true, false, true, false, false, false])) {
      return Get.offAllNamed(Routes.SIGN_UP_EMAIL);
    } else if (eq(truths, [true, false, true, false, false, true])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [true, false, true, false, true, false])) {
      return;
    } else if (eq(truths, [true, false, true, false, true, true])) {
      return;
    } else if (eq(truths, [true, false, true, true, false, false])) {
      return Get.offAllNamed(Routes.EMAIL_VERIFICATION_WAITING);
    } else if (eq(truths, [true, false, true, true, false, true])) {
      return Get.offAllNamed(Routes.EMAIL_VERIFICATION_WAITING);
    } else if (eq(truths, [true, false, true, true, true, false])) {
      return Get.offAllNamed(Routes.CREW_ONBOARDING);
    } else if (eq(truths, [true, false, true, true, true, true])) {
      return Get.offAllNamed(Routes.CREW_ONBOARDING);
    } else if (eq(truths, [true, true, false, false, false, false])) {
      return;
    } else if (eq(truths, [true, true, false, false, false, true])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [true, true, false, false, true, false])) {
      return;
    } else if (eq(truths, [true, true, false, false, true, true])) {
      return;
    } else if (eq(truths, [true, true, false, true, false, false])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [true, true, false, true, false, true])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [true, true, false, true, true, false])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [true, true, false, true, true, true])) {
      return Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
    } else if (eq(truths, [true, true, true, false, false, false])) {
      return;
    } else if (eq(truths, [true, true, true, false, false, true])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [true, true, true, false, true, false])) {
      return;
    } else if (eq(truths, [true, true, true, false, true, true])) {
      return;
    } else if (eq(truths, [true, true, true, true, false, false])) {
      return Get.offAllNamed(Routes.EMAIL_VERIFICATION_WAITING);
    } else if (eq(truths, [true, true, true, true, false, true])) {
      return Get.offAllNamed(Routes.ERROR_OCCURRED);
    } else if (eq(truths, [true, true, true, true, true, false])) {
      if (user?.userTypeKey == 3) {
        Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
      } else {
        Get.offAllNamed(Routes.CREW_ONBOARDING);
      }
    } else if (eq(truths, [true, true, true, true, true, true])) {
      if (user?.userTypeKey == 3) {
        Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
      } else {
        Get.offAllNamed(Routes.CREW_ONBOARDING);
      }
    }
  }
}
