import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

class ChangePasswordController extends GetxController {
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  RxBool shouldObscurePassword = true.obs;
  RxBool shouldObscureConfirmPassword = true.obs;
  RxBool isLoading = false.obs;

  FToast fToast = FToast();
  final parentKey = GlobalKey();

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  Future<bool> changePassword(String newPassword) async {
    bool success = false;
    await FirebaseAuth.instance.currentUser
        ?.updatePassword(newPassword)
        .then((value) => success = true);
    return success;
  }
}
