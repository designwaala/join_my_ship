import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/modules/success/controllers/success_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/utils/styles.dart';
import 'package:join_mp_ship/widgets/custom_elevated_button.dart';

class SuccessView extends GetView<SuccessController> {
  const SuccessView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          const Spacer(),
          Icon(
            Icons.check_circle,
            size: 114,
            color: Get.theme.primaryColor,
          ),
          26.verticalSpace,
          Text(controller.args?.message ?? "JOB PUBLISHED\nSUCCESSFULLY!",
              style: Get.textTheme.s20w700
                  .copyWith(color: Get.theme.primaryColor)),
          20.verticalSpace,
          SizedBox(
            height: 48,
            width: 231,
            child: CustomElevatedButon(
                onPressed: controller.args?.redirection ?? () => Get.back(),
                child: Text("Let’s Discover ")),
          ),
          const Spacer()
        ],
      ),
    ));
  }
}
