import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';

class EmployerJobPostsController extends GetxController {
  RxList<Job> jobPosts = RxList.empty();
  Rxn<CrewUser> currentEmployerUser = Rxn();
/*   RxMap<int, String> vesselTypes = RxMap();
  RxMap<int, String> rankTypes = RxMap();
  RxMap<int, String> cocTypes = RxMap();
  RxMap<int, String> copTypes = RxMap();
  RxMap<int, String> watchKeepingTypes = RxMap(); */
  VesselList? vesselList;
  RxList<Rank> ranks = RxList.empty();
  RxList<Coc> cocs = RxList.empty();
  RxList<Cop> cops = RxList.empty();
  RxList<WatchKeeping> watchKeepings = RxList.empty();

  RxBool isLoading = false.obs;

  RxnInt jobIdBeingDeleted = RxnInt();

  WidgetsToImageController widgetsToImageController =
      WidgetsToImageController();
  Uint8List? bytes;
  RxBool buildCaptureWidget = false.obs;
  RxBool isSharing = false.obs;
  Job? jobToBuild;

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  instantiate() async {
    isLoading.value = true;
    currentEmployerUser.value = UserStates.instance.crewUser ??
        await getIt<CrewUserProvider>().getCrewUser();
    await Future.wait([
      loadJobPosts(),
      loadVesselTypes(),
      loadRanks(),
      loadCOC(),
      loadCOP(),
      loadWatchKeeping(),
    ]);
    isLoading.value = false;
  }

  Future<void> loadJobPosts() async {
    jobPosts.value = (await getIt<JobProvider>()
            .getJobList(employerId: PreferencesHelper.instance.userId ?? -1)) ??
        [];
  }

  Future<void> loadVesselTypes() async {
    vesselList = await getIt<VesselListProvider>().getVesselList();
  }

  Future<void> loadRanks() async {
    ranks.value = (await getIt<RanksProvider>().getRankList()) ?? [];
  }

  Future<void> loadCOC() async {
    cocs.value = (await getIt<CocProvider>().getCOCList(userType: 3)) ?? [];
  }

  Future<void> loadCOP() async {
    cops.value = (await getIt<CopProvider>().getCOPList(userType: 3)) ?? [];
  }

  Future<void> loadWatchKeeping() async {
    watchKeepings.value = (await getIt<WatchKeepingProvider>()
            .getWatchKeepingList(userType: 3)) ??
        [];
  }

  Future<void> deleteJobPost(int jobId) async {
    jobIdBeingDeleted.value = jobId;
    int? statusCode = await getIt<JobProvider>().deleteJob(jobId);
    if (statusCode == 204) {
      jobPosts.removeWhere((jobPost) => jobPost.id == jobId);
    }
    jobIdBeingDeleted.value = null;
  }

  Future<void> captureWidget(Job job) async {
    jobToBuild = job;
    buildCaptureWidget.value = true;
    try {
      await Future.delayed(const Duration(milliseconds: 200));
      bytes = await widgetsToImageController.capture();
      if (bytes == null) {
        Share.share('''
Click on this link to view this Job
http://designwaala.me/job/?job_id=${job.id}
''');
        buildCaptureWidget.value = false;
        return;
      }
      final String path = (await getApplicationDocumentsDirectory()).path;
      File newImage =
          await File('$path/job_${job.id}.png').writeAsBytes(bytes!);
      Share.shareXFiles([XFile(newImage.path)],
          subject: "Hey wanna apply to this Job?",
          text: '''
Click on this link to view this Job
http://designwaala.me/job/?job_id=${job.id}
''');
    } catch (e) {
      Share.share('''
Click on this link to view this Job
http://designwaala.me/job/?job_id=${job.id}
''');
    }
    buildCaptureWidget.value = false;
    print(bytes);
  }
}
