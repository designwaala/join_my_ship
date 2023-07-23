import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CircularProgressIndicatorWidget extends GetWidget {
  const CircularProgressIndicatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: const Center(child: CircularProgressIndicator()),
    );
  }
}
