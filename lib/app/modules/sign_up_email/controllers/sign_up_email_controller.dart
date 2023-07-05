import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';

class SignUpEmailController extends GetxController {
  SignUpEmailArguments? args;
  SignUpType? signUpType = SignUpType.crew;

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
    if (Get.arguments is SignUpEmailArguments) {
      args = (Get.arguments as SignUpEmailArguments);
      signUpType = args?.signUpType;
    }

    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  addEmail() async {
    // Get.toNamed(Routes.EMAIL_VERIFICATION_WAITING);

    print(
        '__value ${emailController.text.split("@")[1]}  ${websiteController.text}');

    if (formKey.currentState?.validate() != true) {
      return;
    }
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
      } else {
        await FirebaseAuth.instance.currentUser?.linkWithCredential(
            EmailAuthProvider.credential(
                email: emailController.text,
                password: passwordController.text));
      }

      await FirebaseAuth.instance.currentUser?.sendEmailVerification();

      Get.toNamed(Routes.EMAIL_VERIFICATION_WAITING);
      /* showDialog(
          context: Get.context!,
          builder: (context) {
            return Dialog(
                shadowColor: const Color.fromRGBO(64, 24, 157, 0.15),
                backgroundColor: Colors.white,
                elevation: 8,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    32.verticalSpace,
                    Text("Verification email sent!",
                        style: Get.textTheme.bodyMedium?.copyWith(
                            color: Get.theme.primaryColor,
                            fontSize: 20,
                            fontWeight: FontWeight.w500)),
                    24.verticalSpace,
                    const Text(
                      "This action requires email verification. Please check your inbox and follow the instructions.",
                      textAlign: TextAlign.center,
                    ),
                    32.verticalSpace,
                    SizedBox(
                      width: 190.w,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(64))),
                          onPressed: Get.back,
                          child: const Text("OK")),
                    ),
                    32.verticalSpace
                  ],
                ));
          }); */
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        fToast.safeShowToast(child: errorToast("Password is too weak"));
      } else if (e.code == 'email-already-in-use') {
        await FirebaseAuth.instance.signOut();
        Get.toNamed(Routes.CREW_SIGN_IN_EMAIL);
        fToast.safeShowToast(
            child: errorToast(
                "An account already exists for that email. Please Login"));
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
  employerCrewingAgent
}

class SignUpEmailArguments {
  final String? verificationId;
  final String? smsCode;
  final SignUpType signUpType;
  const SignUpEmailArguments(
      {this.smsCode, this.verificationId, required this.signUpType});
}
