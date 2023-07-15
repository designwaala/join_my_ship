import 'package:flutter/material.dart';

class CustomElevatedButon extends ElevatedButton {
  CustomElevatedButon(
      {required Function() onPressed, required Widget? child, Key? key, ButtonStyle? style})
      : super(
          key: key,
          onPressed: onPressed,
          child: child,
          style: style ?? ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(64))),
        );
}
