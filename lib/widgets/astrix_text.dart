import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class AsterixText extends StatelessWidget {
  final String text;
  const AsterixText(this.text, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(children: [
      TextSpan(text: text, style: _headingStyle),
      WidgetSpan(child: 4.horizontalSpace),
      TextSpan(text: "*", style: _headingStyle?.copyWith(color: Colors.red))
    ]));
  }
}

TextStyle? get _headingStyle =>
    Get.textTheme.titleSmall?.copyWith(color: Get.theme.primaryColor);
