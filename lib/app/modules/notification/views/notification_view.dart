import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';

import '../controllers/notification_controller.dart';

class NotificationView extends GetView<NotificationController> {
  const NotificationView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notification'),
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const CircularProgressIndicator()
              : ListView(
                  padding: const EdgeInsets.all(24),
                  children: controller.notifications
                          .map((notification) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Color.fromRGBO(0, 0, 0, 0.1),
                                        spreadRadius: 1,
                                        blurRadius: 10,
                                        offset: Offset(0, 1),
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(notification.title ?? "",
                                            style: Get.textTheme.titleLarge),
                                        8.verticalSpace,
                                        Text(notification.data ?? "")
                                      ],
                                    ),
                                  ),
                                ),
                              ))
                          .toList() ??
                      []);
        }));
  }
}
