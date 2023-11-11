import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';

class CircularProgressIndicatorAlertDialog extends GetWidget {
  const CircularProgressIndicatorAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: alertDialogShape,
      content: Container(
        height: 150,
        width: 400,
        color: Colors.white70,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
