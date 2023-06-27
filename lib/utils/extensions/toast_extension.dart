import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

extension SafeToast on FToast {
  safeShowToast({required Widget child}) {
    try {
      showToast(child: child);
    } catch (e) {
      print("$e");
    }
  }
}