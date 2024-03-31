import 'dart:io';
import 'dart:isolate';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/credit_model.dart';
import 'package:join_my_ship/app/data/models/credits_model.dart';
import 'package:join_my_ship/app/data/models/i_o_s_products_model.dart';
import 'package:join_my_ship/app/data/models/ios_transaction_model.dart';
import 'package:join_my_ship/app/data/models/order_model.dart';
import 'package:join_my_ship/app/data/providers/credit_provider.dart';
import 'package:join_my_ship/app/data/providers/order_provider.dart';
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

  final orderProvider = getIt<OrderProvider>();

  Order? newOrder;
  Rxn<Credit> credit = Rxn();
  RxBool isLoading = false.obs;

  static const platformChannel = MethodChannel('com.joinmyship.ios/iOS');
  static const purchaseChannel = const EventChannel("com.joinmyship.ios/event");
  List<IOSProducts> iosProducts = [];
  RxnString selectedIOSProduct = RxnString();

  @override
  void onInit() {
    selectedCurrency.value = creditsModel?.creditCurrencies?.firstOrNull;
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.onInit();
    instantiate();
  }

  Future<void> instantiate() async {
    isLoading.value = true;
    await getCredits(isSilent: true);
    if (Platform.isIOS) {
      await _getIOSProducts();
    }
    isLoading.value = false;
    purchaseChannel.receiveBroadcastStream().listen((transactionevent) async {
      if (transactionevent is Map) {
        final transaction = IOSTransaction.fromJson({
          ...transactionevent
              .map((key, value) => MapEntry<String, dynamic>(key, value))
        });
        if (transaction.productId != null && transaction.id != null) {
          showDialog(
              // barrierDismissible: false,
              context: Get.context!,
              builder: (context) {
                return AlertDialog(
                  shape: alertDialogShape,
                  title: const Text("Found a Transaction, please wait..."),
                  content: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                );
              });
          await _addCreditsIOS(transaction.productId!);
          await _finishTransaction(transaction.id!, transaction.productId!);
          // Get.back();
        }
      }
    });
  }

  Future<void> getCredits({bool isSilent = false}) async {
    if (!isSilent) {
      isLoading.value = true;
    }
    credit.value = await getIt<CreditProvider>().getCredit();
    if (!isSilent) {
      isLoading.value = false;
    }
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

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    if (response.orderId == null ||
        response.paymentId == null ||
        newOrder?.id == null) {
      initiatingPayment.value = false;
      return;
    }
    final order = await orderProvider.captureOrder(
        razorpayOrderId: response.orderId!,
        djangoOrderId: newOrder!.id!,
        paymentId: response.paymentId!);
    if (order?.paymentSuccessful == true) {
      getCredits(isSilent: true);
      Get.snackbar("Payment Successfull", "Congratulations");
    }

    initiatingPayment.value = false;
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Get.snackbar(
        "Payment Failed",
        response.message ??
            response.error?.keys
                .map((e) => "$e:${response.error?[e]}")
                .join("\n") ??
            "");
    initiatingPayment.value = false;
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet was selected
    initiatingPayment.value = false;
  }

  Future<void> _finishTransaction(int transactionId, String productId) async {
    final status = await platformChannel.invokeMethod("finishTransaction",
        {"transaction_id": transactionId, "product_id": productId});
    if (status == true) {
      Get.back();
      showDialog(
          context: Get.context!,
          builder: (context) => AlertDialog(
                title: const Text("Transaction Completed"),
                actions: [
                  FilledButton(onPressed: Get.back, child: const Text("OK"))
                ],
              ));
    }
    return;
  }

  Future<void> _addCreditsIOS(String productId) async {
    await Future.delayed(const Duration(seconds: 1));
    final product =
        iosProducts.firstWhereOrNull((product) => product.id == productId);
    credit.value = await getIt<CreditProvider>()
        .addCredits(currency: product!.currency!, amount: product.price!);

    print("Credits added");
  }

  Future<void> initiatePayment() async {
    if (Platform.isIOS) {
      showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (context) {
            return const AlertDialog(
              title: Text("Transaction Initiated"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            );
          });
      final transaction = await platformChannel.invokeMethod(
          "purchase", selectedIOSProduct.value);
      print(transaction);
      if (transaction is Map) {
        final transactionParsed = IOSTransaction.fromJson({
          ...transaction
              .map((key, value) => MapEntry<String, dynamic>(key, value))
        });
        await _addCreditsIOS(transactionParsed.productId!);
        await _finishTransaction(
            transactionParsed.id!, transactionParsed.productId!);
      } else if (transaction == "user_cancelled") {
        Get.back();
        showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: const Text("Last Transaction was cancelled"),
                actions: [FilledButton(onPressed: Get.back, child: const Text("OK"))],
              );
            });
      } else if (transaction == "pending") {
        Get.back();
        showDialog(
            context: Get.context!,
            builder: (context) {
              return AlertDialog(
                title: const Text("Last Transaction is pending"),
                actions: [FilledButton(onPressed: Get.back, child: const Text("OK"))],
              );
            });
      } else {
        Get.back();
      }
    } else {
      if (formKey.currentState?.validate() != true ||
          selectedCurrency.value?.code == null ||
          selectedAmount.value == null) {
        return;
      }
      initiatingPayment.value = true;
      newOrder = await orderProvider.createOrder(
          currency: selectedCurrency.value!.code!,
          amount: selectedAmount.value!);
      if (newOrder?.razorpayOrderId == null) {
        initiatingPayment.value = false;
        return;
      }
      var options = {
        'key': razorpayKey,
        'order_id': newOrder?.razorpayOrderId,
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
    }
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

  Future<void> _getIOSProducts() async {
    try {
      String encodedProducts =
          await platformChannel.invokeMethod("getProducts");
      iosProducts = List<IOSProducts>.from(
          jsonDecode(encodedProducts).map((e) => IOSProducts.fromJson(e)));
      iosProducts.sort((x, y) => ((double.tryParse(x.price ?? "") ?? 0) -
              (double.tryParse(y.price ?? "") ?? 0))
          .toInt());
    } catch (e) {}
  }
}
