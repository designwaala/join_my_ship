import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/crew_job_applications_controller.dart';

class CrewJobApplicationsView extends GetView<CrewJobApplicationsController> {
  const CrewJobApplicationsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('CrewJobApplicationsView'),
          centerTitle: true,
        ),
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
