import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class UnFocusGesture extends StatefulWidget {
  const UnFocusGesture({required this.child});

  final Widget child;

  @override
  _UnFocusGestureState createState() => _UnFocusGestureState();
}

ConnectivityResult? latestConnectivity;

class _UnFocusGestureState extends State<UnFocusGesture> {
  late FocusNode node;
  StreamSubscription<ConnectivityResult>? connectivity;

  @override
  void initState() {
    Connectivity()
        .checkConnectivity()
        .then((value) => latestConnectivity = value);
    connectivity = Connectivity().onConnectivityChanged.listen((event) {
      print(Get.currentRoute);
      latestConnectivity = event;
      if (event == ConnectivityResult.none) {
        if (Get.currentRoute != Routes.CONNECTIVITY_LOST &&
            Get.currentRoute != Routes.INFO) {
          Get.toNamed(Routes.CONNECTIVITY_LOST);
        }
      } else {
        if (Get.currentRoute == Routes.CONNECTIVITY_LOST) {
          Get.back();
        }
      }
    });
    node = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    connectivity?.cancel();
    node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          if (!node.hasFocus) FocusScope.of(context).requestFocus(node);
        },
        onLongPress: () async {
          showDialog(
              context: Get.context!,
              builder: (context) {
                return AlertDialog(
                  title: Text("Would you like to sign out"),
                  actions: [
                    OutlinedButton(
                        onPressed: () async {
                          UserStates.instance.reset();
                          await FirebaseAuth.instance.signOut();
                          await PreferencesHelper.instance.clearAll();
                          Get.offAllNamed(Routes.SPLASH);
                        },
                        child: Text("Yes")),
                    8.horizontalSpace,
                    OutlinedButton(onPressed: Get.back, child: Text("No")),
                    8.horizontalSpace,
                  ],
                );
              });
        },
        child: widget.child,
      );
}
