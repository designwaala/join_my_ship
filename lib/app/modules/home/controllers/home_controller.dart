import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 1.obs;
  RxBool showJobButtons = false.obs;

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey(); // Create a key

  @override
  void onInit() {
    super.onInit();
  }
}
