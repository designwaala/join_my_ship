import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/job_application_model.dart';
import 'package:join_mp_ship/app/data/providers/job_application_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/main.dart';

class EmployerJobApplicationsController extends GetxController {
  RxList<JobApplication> jobApplications = RxList();
  RxList ranks = RxList.empty();
  Map<String, dynamic> filters = {};
  RxBool filterOn = false.obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
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
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  Future<void> removeFilters() async {
    isLoading.value = true;
    filters.clear();
    await Future.delayed(const Duration(seconds: 1));
    isLoading.value = false;
  }

  Future<void> loadJobApplications() async {
    jobApplications.addAll(
        (await getIt<JobApplicationProvider>().getJobApplications()) ?? []);
  }

  Future<void> loadRanks() async {
    ranks.value = (await getIt<RanksProvider>().getRankList()) ?? [];
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
