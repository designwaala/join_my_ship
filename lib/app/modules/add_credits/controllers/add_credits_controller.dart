import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/credits_model.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/remote_config.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:collection/collection.dart';

import 'package:firebase_core/firebase_core.dart';

class AddCreditsController extends GetxController {
  CreditsModel? creditsModel = RemoteConfigUtils.instance.creditsModel;
  Razorpay _razorpay = Razorpay();

  Rxn<CreditCurrency> selectedCurrency = Rxn<CreditCurrency>();

  RxnDouble selectedAmount = RxnDouble();
  TextEditingController amountController = TextEditingController();
  RxBool initiatingPayment = false.obs;

  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    selectedCurrency.value = creditsModel?.creditCurrencies?.firstOrNull;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    amountController.addListener(_updateAmount);
  }

  _updateAmount() {
    selectedAmount.value = double.tryParse(amountController.text);
  }

  @override
  void onClose() {
    amountController.removeListener(_updateAmount);
    super.onClose();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Get.snackbar("Payment Successfull", "Congratulations");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
        "Payment Failed",
        response.message ??
            response.error?.keys
                .map((e) => "$e:${response.error?[e]}")
                .join("\n") ??
            "");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
  }

  Future<void> initiatePayment() async {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    initiatingPayment.value = true;
    String orderId = await createOrder();

    var options = {
      'key': razorpayKey,
      'order_id': orderId,
      'name': "Join My Ship",
      'amount': 100,
      'description': "",
      'prefill': {
        if (FirebaseAuth.instance.currentUser?.phoneNumber != null)
          "contact": FirebaseAuth.instance.currentUser?.phoneNumber,
        if (FirebaseAuth.instance.currentUser?.email != null)
          "email": FirebaseAuth.instance.currentUser?.email
      },
      "method": {
        "netbanking": true,
        "card": true,
        "upi": true,
        "wallet": false,
        "emi": false,
        "paylater": false
      },
    };

    _razorpay.open(options);
    initiatingPayment.value = false;
  }

  createOrder() async {
    Map<String, dynamic> paymentData = {
      'amount': (selectedAmount.value ?? 0) *
          100, // amount in paise (e.g., 1000 paise = Rs. 10)
      'currency': 'INR',
      'receipt': 'order_receipt',
      'payment_capture': '1',
    };

    String apiSecret = "0ZZvwbynJGmLtpp56yUks5ve";

    String apiUrl = 'https://api.razorpay.com/v1/orders/';
    // Make the API request to create an order
    http.Response response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Basic ${base64Encode(utf8.encode('$razorpayKey:$apiSecret'))}',
      },
      body: jsonEncode(paymentData),
    );

    return jsonDecode(response.body)['id'];
  }
}
