import 'dart:io';

import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/data/providers/application_provider.dart';
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_application_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/user_details_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:http/http.dart' as http;

class ApplicantDetailController extends GetxController {
  CrewUser? applicant;
  UserDetails? applicantDetails;
  RxBool isLoading = false.obs;
  List<Rank>? ranks;
  List<Country>? countries;
  RxBool isGettingResume = false.obs;
  RxBool isShortListing = false.obs;

  ApplicantDetailArguments? args;
  Rxn<Application> application = Rxn();

  String? _localPath;

  @override
  void onInit() {
    if (Get.arguments is ApplicantDetailArguments?) {
      args = Get.arguments;
      application.value = args?.application;
    }
    instantiate();
    super.onInit();
  }

  instantiate() async {
    if (args?.userId == null) {
      return;
    }
    isLoading.value = true;
    applicant = await getIt<CrewUserProvider>().getJobApplicant(args!.userId!);
    applicantDetails =
        await getIt<UserDetailsProvider>().getUserDetails(args!.userId!);
    ranks = await getIt<RanksProvider>().getRankList();
    countries = await getIt<CountryProvider>().getCountry();
    isLoading.value = false;
    if (application.value?.viewedStatus != true &&
        args?.userId != null &&
        application.value?.jobId != null) {
      getIt<ApplicationProvider>()
          .viewApplication(args?.userId ?? -1, application.value?.jobId ?? -1);
    }
  }

  downloadResume() async {
    isGettingResume.value = true;
    String? resume = await getIt<ApplicationProvider>()
        .downloadResumeForApplication(args?.application?.jobId ?? -1,
            args?.application?.userData?.id ?? -1);
    await _prepareSaveDir();
    final taskId = await FlutterDownloader.enqueue(
      url: "https://designwaala.me$resume",
      headers: {}, // optional: header send with url (auth token etc)
      savedDir: _localPath ?? "",
      saveInPublicStorage: true,
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    // await loadPdfFromNetwork("https://designwaala.me$resume");
    /* launchUrl(Uri.parse("https://designwaala.me$resume"),
        mode: LaunchMode.externalApplication); */
    isGettingResume.value = false;
  }

  Future<void> _prepareSaveDir() async {
    _localPath = (await _getSavedDir())!;
    if (_localPath == null) {
      return;
    }
    final savedDir = Directory(_localPath!);
    if (!savedDir.existsSync()) {
      await savedDir.create();
    }
  }

  Future<String?> _getSavedDir() async {
    String? externalStorageDirPath;

    externalStorageDirPath =
        (await getApplicationDocumentsDirectory()).absolute.path;

    return externalStorageDirPath;
  }

  Future<File> loadPdfFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    final bytes = response.bodyBytes;
    return _storeFile(url, bytes);
  }

  Future<File> _storeFile(String url, List<int> bytes) async {
    final filename = "${applicant?.firstName}_${applicant?.id}";
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filename');
    await file.writeAsBytes(bytes, flush: true);
    return file;
  }

  shortList() async {
    if (application.value?.id == null) {
      return;
    }
    isShortListing.value = true;
    if (application.value?.shortlistedStatus != true) {
      int? statusCode = await getIt<ApplicationProvider>()
          .shortListApplication(application.value!);
      if (statusCode == 200) {
        application.value?.shortlistedStatus = true;
      }
    } else {
      Application? updatedApplication = await getIt<ApplicationProvider>()
          .unshortListApplication(application.value!.id!);
      if (updatedApplication != null) {
        application.value = updatedApplication;
      }
    }

    isShortListing.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }
}

class ApplicantDetailArguments {
  final int? userId;
  final Application? application;
  const ApplicantDetailArguments({this.userId, this.application});
}
