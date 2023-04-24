import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget successToast(String text) => Container(
      decoration: BoxDecoration(
          color: Colors.green, borderRadius: BorderRadius.circular(64.r)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check, color: Colors.white),
            16.horizontalSpace,
            Text(text,
                style: Get.textTheme.bodyMedium?.copyWith(color: Colors.white)),
            8.horizontalSpace
          ],
        ),
      ),
    );

Widget errorToast(String text) => Container(
      decoration: BoxDecoration(
          color: Colors.red, borderRadius: BorderRadius.circular(64.r)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            8.horizontalSpace,
            Icon(Icons.info, color: Colors.white),
            16.horizontalSpace,
            Flexible(
              child: Text(text,
                  style:
                      Get.textTheme.bodyMedium?.copyWith(color: Colors.white),
                  maxLines: 2),
            ),
            8.horizontalSpace
          ],
        ),
      ),
    );
