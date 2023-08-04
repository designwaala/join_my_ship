import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/job_application_model.dart';
import 'package:join_mp_ship/app/data/providers/job_application_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/main.dart';

class EmployerJobApplicationsController extends GetxController {
  RxList<JobApplication> jobApplications = RxList();
  Map<int, String> rankTypes = <int, String>{};
  final RxMap<String, dynamic> filterOptions = RxMap();
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

  Future<void> loadJobApplications() async {
    jobApplications.addAll(
        (await getIt<JobApplicationProvider>().getJobApplications()) ?? []);
  }

  Future<void> loadRanks() async {
    final ranksList = await getIt<RanksProvider>().getRankList() ?? [];
    for (final rank in ranksList) {
      rankTypes[rank.id!] = rank.name!;
    }
  }

//   sortJobApplicationsList() {
//     print("sorting");
//     jobApplicationsList.clear();
//     if (!filterOn.value) {
//       jobApplicationsList.addAll(jobApplications);
//       return;
//     }
//     jobApplicationsList.addAll(jobApplications.where((jobApplication) {
//       bool filter = true;
//       if (filterOptions.value.shortlisted != -1) {
//         filter &= filterOptions.value.shortlisted ==
//             (jobApplication.shortlisted ? 1 : 0);
//       }
//       if (filterOptions.value.rank.isNotEmpty) {
//         filter &= filterOptions.value.rank == jobApplication.rank;
//       }
//       if (filterOptions.value.gender.isNotEmpty) {
//         // filter &= filterOptions.rank!.value == jobApplication.rank;
//       }
//       return filter;
//     }));
//     jobApplicationsList.refresh();
//     // for (final jobApplication in jobApplications) {
//     //   bool filter = true;
//     //   if (filterOptions.shortlisted!.value != -1) {
//     //     filter &= filterOptions.shortlisted!.value ==
//     //         (jobApplication.shortlisted ? 1 : 0);
//     //   }
//     //   if (filterOptions.rank!.value.isNotEmpty) {
//     //     // filter &= filter
//     //   }
//     // }
//   }
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
