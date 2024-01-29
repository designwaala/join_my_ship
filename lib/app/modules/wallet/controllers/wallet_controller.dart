import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/credit_model.dart';
import 'package:join_my_ship/app/data/models/order_model.dart';
import 'package:join_my_ship/app/data/models/point_history_model.dart';
import 'package:join_my_ship/app/data/providers/credit_provider.dart';
import 'package:join_my_ship/app/data/providers/order_provider.dart';
import 'package:join_my_ship/app/data/providers/point_history_provider.dart';
import 'package:join_my_ship/main.dart';

class WalletController extends GetxController {
  Rxn<Credit> credit = Rxn();
  RxBool isLoadingCredits = false.obs;
  RxBool isLoading = false.obs;

  List<Order>? creditHistory;
  List<PointHistory>? debitHistory;

  Rx<WalletViewType> view = Rx(WalletViewType.credit);

  @override
  void onInit() {
    super.onInit();
    getCredits();
    getTransactions();
  }

  Future<void> getTransactions() async {
    isLoading.value = true;
    await Future.wait([
      getIt<OrderProvider>().getOrders().then((value) => creditHistory = value),
      getIt<PointHistoryProvider>()
          .getPointHistory()
          .then((value) => debitHistory = value),
    ]);
    isLoading.value = false;
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

enum WalletViewType {
  credit,
  debit;

  String get name {
    switch (this) {
      case WalletViewType.credit:
        return "Credit";
      case WalletViewType.debit:
        return "Debit";
    }
  }

  List<Widget> view(WalletController controller) {
    switch (this) {
      case WalletViewType.credit:
        return controller.creditHistory
                ?.map((credit) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 64),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/icons/coins.svg",
                            height: 18,
                            width: 18,
                          ),
                          8.horizontalSpace,
                          Text(credit.amount.toString())
                        ],
                      ),
                    ))
                .toList() ??
            [];
      case WalletViewType.debit:
        return [SizedBox()];
    }
  }
}
