import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/application_model.dart';
import 'package:join_my_ship/app/data/models/ranks_model.dart';
import 'package:join_my_ship/app/data/providers/application_provider.dart';
import 'package:join_my_ship/app/data/providers/job_application_provider.dart';
import 'package:join_my_ship/app/data/providers/ranks_provider.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/continous_stream.dart';
import 'package:join_my_ship/utils/extensions/string_extensions.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';

class EmployerJobApplicationsController extends GetxController {
  RxList<Application> jobApplications = RxList();
  RxList<Rank> ranks = RxList.empty();
  Map<String, dynamic> filters = {};
  RxBool filterOn = false.obs;
  RxBool isLoading = false.obs;

  EmployerJobApplicationsArguments? args;

  RxList<int> toApplyRanks = RxList.empty();
  RxnInt toApplyGenderFilter = RxnInt();
  RxnBool toApplyIsShortlisted = RxnBool();

  RxList<int> selectedRanks = RxList.empty();
  RxnInt genderFilter = RxnInt();
  RxnBool isShortlisted = RxnBool();

  RxnInt applicationShortListing = RxnInt();

  FToast fToast = FToast();
  final parentKey = GlobalKey();

  @override
  void onInit() {
    if (Get.arguments is EmployerJobApplicationsArguments?) {
      args = Get.arguments;
    }
    instantiate();
    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
    ContinuousStream()
      ..on(Streams.profileShortlisted, _profileShortlisted)
      ..on(Streams.profileUnShortlisted, _profileUnShortlisted);
  }

  @override
  onClose() {
    ContinuousStream()
      ..cancel(Streams.profileShortlisted, _profileShortlisted)
      ..cancel(Streams.profileUnShortlisted, _profileUnShortlisted);
    super.onClose();
  }

  instantiate() async {
    isLoading.value = true;
    await loadJobApplications();
    await loadRanks();
    isLoading.value = false;
  }

  Future<void> applyFilters() async {
    isLoading.value = true;
    if (filters.isEmpty) {
      filterOn.value = false;
    }
    await loadJobApplications();
    isLoading.value = false;
  }

  Future<void> removeFilters() async {
    isLoading.value = true;
    filters.clear();
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  Future<void> loadJobApplications() async {
    if (args?.jobId == null) {
      return;
    }
    jobApplications.value =
        (await getIt<ApplicationProvider>().getApplicationsForAJob(
              args!.jobId!,
              ranks: selectedRanks.nullIfEmpty(),
              genders:
                  genderFilter.value == null ? null : [genderFilter.value!],
              shortlistedStatus: isShortlisted.value == null
                  ? null
                  : isShortlisted.value == true
                      ? 1
                      : 0,
            )) ??
            [];
  }

  Future<void> loadRanks() async {
    ranks.value = (await getIt<RanksProvider>().getRankList()) ?? [];
  }

  Future<void> shortListApplication(int? applicationId) async {
    if (jobApplications
            .firstWhereOrNull((element) => element.id == applicationId)
            ?.resumeStatus !=
        true) {
      fToast.safeShowToast(child: errorToast("Please download resume first"));
      return;
    }
    if (applicationId == null ||
        jobApplications.any((e) => e.id == applicationId) != true) {
      return;
    }
    applicationShortListing.value = applicationId;
    if (jobApplications
            .firstWhereOrNull((application) => application.id == applicationId)
            ?.shortlistedStatus !=
        true) {
      int? statusCode = await getIt<ApplicationProvider>().shortListApplication(
          jobApplications.firstWhereOrNull(
              (application) => application.id == applicationId)!);
      if (statusCode == 200) {
        int index = jobApplications.indexWhere((e) => e.id == applicationId);
        Application application = jobApplications[index];
        application.shortlistedStatus = true;
        jobApplications
          ..removeAt(index)
          ..insert(index, application);
      }
    } else {
      Application? updatedApplication = await getIt<ApplicationProvider>()
          .unshortListApplication(applicationId);
      if (updatedApplication != null) {
        int index = jobApplications.indexWhere((e) => e.id == applicationId);
        jobApplications
          ..removeAt(index)
          ..insert(index, updatedApplication);
      }
    }

    applicationShortListing.value = null;
  }

  _profileShortlisted(Object applicationId) {
    if (applicationId is int) {
      final index = jobApplications
          .indexWhere((application) => application.id == applicationId);
      Application application = jobApplications.removeAt(index);
      application.shortlistedStatus = true;
      jobApplications.insert(index, application);
    }
  }

  _profileUnShortlisted(Object applicationId) {
    if (applicationId is int) {
      final index = jobApplications
          .indexWhere((application) => application.id == applicationId);
      Application application = jobApplications.removeAt(index);
      application.shortlistedStatus = false;
      jobApplications.insert(index, application);
    }
  }
}

class FilterOptions {
  int shortlisted;
  String rank;
  String gender;
  FilterOptions(
      {required this.shortlisted, required this.rank, required this.gender});
}

class Custom {
  String name;
  String rank;
  String profilePic;
  bool shortlisted;
  Custom(
      {required this.name,
      required this.rank,
      required this.profilePic,
      required this.shortlisted});
}

class EmployerJobApplicationsArguments {
  final int? jobId;
  const EmployerJobApplicationsArguments({this.jobId});
}
