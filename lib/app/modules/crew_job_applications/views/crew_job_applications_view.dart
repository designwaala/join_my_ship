import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/crew_job_applications_controller.dart';

class CrewJobApplicationsView extends GetView<CrewJobApplicationsController> {
  const CrewJobApplicationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            foregroundColor: const Color(0xFF000000),
            toolbarHeight: 70,
            backgroundColor: Colors.white,
            centerTitle: true,
            title: Text('Crew Job Applications',
                style: Get.theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600)),
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: Color(0xFFF3F3F3), shape: BoxShape.circle),
                child: const Icon(
                  Icons.keyboard_backspace_rounded,
                  color: Colors.black,
                ),
              ),
            )),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                      /* children: controller.applications.map((application) => 
                  ExpansionTile(title: Text(application.))
                  ).toList() */
                      ));
        }));
  }
}
