import 'dart:io';
import 'dart:isolate';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/application_model.dart';
import 'package:join_my_ship/app/data/models/country_model.dart';
import 'package:join_my_ship/app/data/models/crew_user_model.dart';
import 'package:join_my_ship/app/data/models/follow_model.dart';
import 'package:join_my_ship/app/data/models/ranks_model.dart';
import 'package:join_my_ship/app/data/models/user_details_model.dart';
import 'package:join_my_ship/app/data/providers/application_provider.dart';
import 'package:join_my_ship/app/data/providers/country_provider.dart';
import 'package:join_my_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_my_ship/app/data/providers/follow_provider.dart';
import 'package:join_my_ship/app/data/providers/job_application_provider.dart';
import 'package:join_my_ship/app/data/providers/ranks_provider.dart';
import 'package:join_my_ship/app/data/providers/user_details_provider.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/continous_stream.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:collection/collection.dart';
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

  RxBool isFollowing = false.obs;

  FToast fToast = FToast();
  final parentKey = GlobalKey();

  ReceivePort _port = ReceivePort();

  @override
  void onInit() {
    if (Get.arguments is ApplicantDetailArguments?) {
      args = Get.arguments;
      application.value = args?.application;
    }
    instantiate();
    super.onInit();
    IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      final status = DownloadTaskStatus.fromInt(data[1] as int);
      fToast.safeShowToast(child: successToast(status.name));
    });

    FlutterDownloader.registerCallback(downloadCallback);
  }

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, int status, int progress) {
    final SendPort? send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  @override
  void onClose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.onClose();
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
/*     FlutterDownloader.open(taskId: "com.example.joinMpShip.download.task.13247.1702202773.045498");
    return; */
    bool? shouldDownload = await showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: alertDialogShape,
        title: const Text(
          "Are You Sure ?",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.blue),
        ),
        actionsPadding: const EdgeInsets.only(bottom: 25),
        /* content: const Text(
          "Are you sure you want to use your 100 credits?",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14.5,
            fontWeight: FontWeight.w600,
          ),
        ), */
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actions: [
          ElevatedButton(
            onPressed: Get.back,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              elevation: 3,
              padding: const EdgeInsets.symmetric(horizontal: 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("NO"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(result: true);
            },
            style: ElevatedButton.styleFrom(
              elevation: 3,
              padding: const EdgeInsets.symmetric(horizontal: 35),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text("YES"),
          ),
        ],
      ),
    );
    if (shouldDownload != true) {
      return;
    }
    isGettingResume.value = true;
    String? resume = await getIt<ApplicationProvider>()
        .downloadResumeForApplication(args?.application?.jobId,
            args?.application?.userData?.id ?? args?.userId ?? -1);
    if (resume == null) {
      isGettingResume.value = false;
      return;
    }
    application.value?.resumeStatus = true;
    await _prepareSaveDir();
    DateTime now = DateTime.now();
    final taskId = await FlutterDownloader.enqueue(
      url: "https://joinmyship.com$resume",
      headers: {}, // optional: header send with url (auth token etc)
      savedDir: _localPath ?? "",
      saveInPublicStorage: true,
      fileName:
          "${applicant?.id ?? ""}_${applicant?.firstName ?? ""}_${applicant?.lastName ?? ""}_${now.millisecondsSinceEpoch}.${resume.split(".").lastOrNull ?? ""}",
      showNotification:
          true, // show download progress in status bar (for Android)
      openFileFromNotification:
          true, // click on notification to open downloaded file (for Android)
    );
    // await loadPdfFromNetwork("https://joinmyship.com$resume");
    /* launchUrl(Uri.parse("https://joinmyship.com$resume"),
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
    if (application.value?.resumeStatus != true) {
      fToast.safeShowToast(child: errorToast("Please download resume first"));
      return;
    }
    if (application.value?.id == null) {
      return;
    }
    isShortListing.value = true;
    if (application.value?.shortlistedStatus != true) {
      int? statusCode = await getIt<ApplicationProvider>()
          .shortListApplication(application.value!);
      if (statusCode == 200) {
        ContinuousStream()
            .emit(Streams.profileShortlisted, application.value?.id);
        application.value?.shortlistedStatus = true;
        fToast.safeShowToast(child: successToast("Profile Shortlisted"));
      }
    } else {
      Application? updatedApplication = await getIt<ApplicationProvider>()
          .unshortListApplication(application.value!.id!);
      if (updatedApplication != null) {
        application.value = updatedApplication;
        ContinuousStream()
            .emit(Streams.profileUnShortlisted, application.value?.id);
      }
    }

    isShortListing.value = false;
  }

  Future<void> follow() async {
    if (applicant?.id == null) {
      return;
    }
    isFollowing.value = true;
    Follow? follow = await getIt<FollowProvider>().follow(applicant!.id!);
    isFollowing.value = false;
  }
}

class ApplicantDetailArguments {
  final int? userId;
  final Application? application;
  final ViewType? viewType;
  const ApplicantDetailArguments(
      {this.userId, this.application, this.viewType});
}

enum ViewType { applicant, crewDetail }
