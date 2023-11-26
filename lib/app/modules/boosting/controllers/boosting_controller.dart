import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:join_mp_ship/app/data/models/boosting_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/providers/boosting_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class BoostingController extends GetxController {
  RxBool isLoading = false.obs;
  // Rxn<CrewBoostingList> crewBoostings = Rxn();
  // RxList<Map<String, List<Employer>>> jobBoostings = RxList.empty();
  Rx<BoostingViewType> view = BoostingViewType.jobPost.obs;
  List<Rank> ranks = [];

  PagingController<int, Map<String, List<Employer>>> jobPagingController =
      PagingController(firstPageKey: 1);

  PagingController<int, Crew> crewPagingController =
      PagingController(firstPageKey: 1);

  @override
  void onInit() {
    super.onInit();
    getRanks();
  }

  Future<void> getRanks() async {
    isLoading.value = true;
    await Future.wait([
      if (UserStates.instance.ranks != null)
        Future.value(UserStates.instance.ranks)
            .then((value) => ranks = value ?? [])
      else
        getIt<RanksProvider>()
            .getRankList()
            .then((value) => ranks = value ?? []),
      Future.delayed(const Duration(seconds: 1))
    ]);
    isLoading.value = false;
  }

  getJobBoostings({int? page}) async {
    List<Map<String, List<Employer>>> jobBoostings =
        (await getIt<BoostingProvider>().getJobBoosting(page: page)) ?? [];
    if (jobBoostings.isEmpty) {
      jobPagingController.appendLastPage([]);
    } else {
      jobPagingController.appendPage(jobBoostings, (page ?? 0) + 1);
    }
  }

  getCrewBoosting({int? page}) async {
    List<Crew> crews =
        (await getIt<BoostingProvider>().getCrewBoosting(page: page))
                ?.results ??
            [];
    if (crews.isEmpty) {
      crewPagingController.appendLastPage([]);
    } else {
      crewPagingController.appendPage(crews, (page ?? 0) + 1);
    }
  }

  @override
  void onReady() {
    super.onReady();
    jobPagingController.addPageRequestListener((pageKey) {
      getJobBoostings(page: pageKey);
    });
    crewPagingController.addPageRequestListener((pageKey) {
      getCrewBoosting(page: pageKey);
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}

enum BoostingViewType {
  jobPost,
  profile;

  String get name {
    switch (this) {
      case BoostingViewType.jobPost:
        return "Job Posts";
      case BoostingViewType.profile:
        return "Profile";
    }
  }
}
