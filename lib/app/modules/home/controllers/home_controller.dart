import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 1.obs;
  RxBool showJobButtons = false.obs;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  RxString selectedDrawerButton = "Home".obs;
  List<Map<String, dynamic>> drawerButtons = [];

  @override
  void onInit() {
    super.onInit();
    _initialize();
  }

  _initialize() {
    _addDrawerButtons();
  }

  _addDrawerButtons() {
    drawerButtons = [
      {
        "title": "Home",
        "iconPath": "assets/icons/home.png",
        "iconSize": 18.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "Applied Jobs",
        "iconPath": "assets/icons/suitcase.png",
        "iconSize": 18.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "Liked Jobs",
        "iconPath": "assets/icons/like.png",
        "iconSize": 20.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "Find Jobs",
        "iconPath": "assets/icons/search.png",
        "iconSize": 19.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "Notifications",
        "iconPath": "assets/icons/notification.png",
        "iconSize": 20.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "My Profile",
        "iconPath": "assets/icons/profile.png",
        "iconSize": 19.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "Help & Feedback",
        "iconPath": "assets/icons/info.png",
        "iconSize": 18.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "Logout",
        "iconPath": "assets/icons/logout.png",
        "iconSize": 18.0,
        "onTap": () {
          // TODO
        }
      },
    ];
  }
}
