import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wallet_controller.dart';

class WalletView extends GetView<WalletController> {
  const WalletView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WalletView'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FilledButton(onPressed: (){
            controller.checkoutPro.openCheckoutScreen(
                payUPaymentParams: PayUParams.createPayUPaymentParams(),
                payUCheckoutProConfig: PayUParams.createPayUConfigParams(),
              );
          }, child: Text("checkout"))
        ],
      )
    );
  }
}
