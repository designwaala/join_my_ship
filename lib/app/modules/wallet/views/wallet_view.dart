import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';

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
        body: ElevatedButton(
            onPressed: () {
              Get.toNamed(Routes.ADD_CREDITS);
            },
            child: Text("trigger")));
  }
}
