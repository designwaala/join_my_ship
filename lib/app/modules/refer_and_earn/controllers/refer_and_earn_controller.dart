import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/providers/applied_refer_code_provider.dart';
import 'package:join_my_ship/app/data/providers/user_code_provider.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';

class ReferAndEarnController extends GetxController {
  String? referralCode;
  RxBool isLoading = false.obs;

  RxBool isApplyingCode = false.obs;

  TextEditingController codeController = TextEditingController();

  FToast fToast = FToast();
  final parentKey = GlobalKey();

  @override
  void onInit() {
    super.onInit();
    getReferralCode();
  }

  Future<void> getReferralCode() async {
    isLoading.value = true;
    referralCode = (await getIt<UserCodeProvider>().getUserCode())?.userCode;
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
    assert(parentKey.currentContext != null);
    fToast.init(parentKey.currentContext!);
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> applyCode() async {
    if (codeController.text.isEmpty) {
      return;
    }
    isApplyingCode.value = true;
    final response =
        await getIt<AppliedReferCodeProvider>().applyCode(codeController.text);
    if (response?.id != null) {
      fToast.safeShowToast(child: successToast("Referral Code Applied!"));
    }
    isApplyingCode.value = false;
  }
}
