import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularProgressIndicatorAlertDialog extends GetWidget {
  const CircularProgressIndicatorAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Container(
        height: 150,
        width: 400,
        color: Colors.white70,
        child: const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
