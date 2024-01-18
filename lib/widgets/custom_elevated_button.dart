import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/utils/styles.dart';

class CustomElevatedButon extends ElevatedButton {
  CustomElevatedButon(
      {Function()? onPressed,
      required Widget? child,
      Key? key,
      ButtonStyle? style})
      : super(
          key: key,
          onPressed: onPressed,
          child: child,
          style: style ??
              ElevatedButton.styleFrom(
                  textStyle: Get.textTheme.s16w600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(64))),
        );
}
