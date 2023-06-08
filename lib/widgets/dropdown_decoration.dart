import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DropdownDecoration extends BoxDecoration {
  DropdownDecoration({
    color,
    image,
    border,
    borderRadius,
    boxShadow,
    gradient,
    backgroundBlendMode,
    shape = BoxShape.rectangle,
  }) : super(
          color: color ?? Colors.white,
          image: image,
          border: border ?? Border.all(color: Get.theme.primaryColor),
          borderRadius: borderRadius ?? BorderRadius.circular(64),
          boxShadow: boxShadow,
          gradient: gradient,
          backgroundBlendMode: backgroundBlendMode,
          shape: shape,
        );
}
