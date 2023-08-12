import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/providers/application_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_application_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/extensions/string_extensions.dart';

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

  @override
  void onInit() {
    if (Get.arguments is EmployerJobApplicationsArguments?) {
      args = Get.arguments;
    }
    instantiate();
    super.onInit();
  }

  instantiate() async {
    isLoading.value = true;

    await Future.wait([
      loadJobApplications(),
      loadRanks(),
    ]);

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
    jobApplications.value = (await getIt<ApplicationProvider>()
            .getApplicationsForAJob(args!.jobId!,
                ranks: selectedRanks.nullIfEmpty(),
                genders:
                    genderFilter.value == null ? null : [genderFilter.value!],
                statuses: isShortlisted.value == null
                    ? null
                    : [
                        if (isShortlisted.value == true) ...[
                          ApplicationStatus.SHORT_LISTED,
                          ApplicationStatus.RESUME_DOWNLOADED
                        ] else
                          ApplicationStatus.APPLIED
                      ])) ??
        [];
  }

  Future<void> loadRanks() async {
    ranks.value = (await getIt<RanksProvider>().getRankList()) ?? [];
  }

  Future<void> shortListApplication(int? applicationId) async {
    if (applicationId == null) {
      return;
    }
    applicationShortListing.value = applicationId;
    final updatedJobApplication =
        await getIt<ApplicationProvider>().shortListApplication(applicationId);
    if (updatedJobApplication != null) {
      int index = jobApplications.indexWhere((e) => e.id == applicationId);
      jobApplications
        ..removeAt(index)
        ..insert(index, updatedJobApplication);
    }
    applicationShortListing.value = null;
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
