import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:timelines/timelines.dart';

import '../controllers/application_status_controller.dart';

class ApplicationStatusView extends GetView<ApplicationStatusController> {
  const ApplicationStatusView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Application Status'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            32.verticalSpace,
            Timeline.tileBuilder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              builder: TimelineTileBuilder.fromStyle(
                // indicatorStyle: IndicatorStyle.container,
                contentsBuilder: (context, index) {
                  switch (index) {
                    case 0:
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Job Applied", style: Get.textTheme.titleMedium),
                          Text("You have successfully applied for your job",
                              style: Get.textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey))
                        ],
                      );
                    case 1:
                    case 2:
                    case 3:
                  }
                },
                itemCount: 4,
              ),
            )
          ],
        ));
  }
}
