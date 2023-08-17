import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/view_jobs_posted_controller.dart';

class ViewJobsPostedView extends GetView<ViewJobsPostedController> {
  const ViewJobsPostedView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ViewJobsPostedView'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'ViewJobsPostedView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
