import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/data/providers/application_provider.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class CrewJobApplicationsController extends GetxController {
  RxList<Application> applications = RxList.empty();
  VesselList? vesselList;
  RxList<Rank> ranks = RxList.empty();
  RxList<Coc> cocs = RxList.empty();
  RxList<Cop> cops = RxList.empty();
  RxList<WatchKeeping> watchKeepings = RxList.empty();
  RxBool isLoading = false.obs;

  WidgetsToImageController widgetsToImageController =
      WidgetsToImageController();
  // to save image bytes of widget
  Uint8List? bytes;
  RxBool buildCaptureWidget = false.obs;
  RxBool isSharing = false.obs;
  Application? applicationToBuild;

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  Future<void> captureWidget(Application application) async {
    isSharing.value = true;
    applicationToBuild = application;
    buildCaptureWidget.value = true;
    await Future.delayed(const Duration(milliseconds: 200));
    bytes = await widgetsToImageController.capture();
    if (bytes == null) {
      buildCaptureWidget.value = false;
    }
    File file = File.fromRawPath(bytes!);
    final String path = (await getApplicationDocumentsDirectory()).path;
    File newImage =
        await File('$path/job_${application.id}.png').writeAsBytes(bytes!);
    // final File newImage = await file.copy('$path/job_${application.id}.png');
    Share.shareXFiles([XFile(newImage.path)],
        subject: "Hey wanna apply to this Job?",
        text: '''
Click on this link to view this Job
http://joinmyship.com/job/?job_id=${application.jobData?.id}
''');
    buildCaptureWidget.value = false;
    print(bytes);
    isSharing.value = false;
  }

  instantiate() async {
    isLoading.value = true;
    applications.value =
        (await getIt<ApplicationProvider>().getAppliedJobList())?.results ?? [];

    vesselList = await getIt<VesselListProvider>().getVesselList();

    ranks.value = (await getIt<RanksProvider>().getRankList()) ?? [];

    cocs.value = (await getIt<CocProvider>().getCOCList(userType: 3)) ?? [];

    cops.value = (await getIt<CopProvider>().getCOPList(userType: 3)) ?? [];

    watchKeepings.value = (await getIt<WatchKeepingProvider>()
            .getWatchKeepingList(userType: 3)) ??
        [];
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }
}
