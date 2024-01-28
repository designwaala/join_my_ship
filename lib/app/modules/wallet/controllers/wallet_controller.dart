import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/credit_model.dart';
import 'package:join_my_ship/app/data/providers/credit_provider.dart';
import 'package:join_my_ship/main.dart';

class WalletController extends GetxController {
  Rxn<Credit> credit = Rxn();
  RxBool isLoadingCredits = false.obs;

  @override
  void onInit() {
    super.onInit();
    getCredits();
  }

  @override
  void onReady() {
    super.onReady();
  }

  Future<void> getCredits({bool isSilent = false}) async {
    isLoadingCredits.value = true;
    credit.value = await getIt<CreditProvider>().getCredit();
    isLoadingCredits.value = false;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
