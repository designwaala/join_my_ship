import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_type_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/main.dart';

enum Step1Miss {
  tentativeJoining,
  vesselType,
  grt,
  deckRank,
  engineRank,
  galleyRank;

  String get errorMessage {
    switch (this) {
      case Step1Miss.tentativeJoining:
        return "Please select a tentative joining date";
      case Step1Miss.vesselType:
        return "Please select a Vessel type";
      case Step1Miss.grt:
        return "Please enter GRT";
      case Step1Miss.deckRank:
        return "Please select atleast one rank.";
      case Step1Miss.engineRank:
        return "Please select atleast one rank.";
      case Step1Miss.galleyRank:
        return "Please select atleast one rank.";
    }
  }
}

enum Step2Miss {
  jobExpiry;

  String get errorMessage {
    switch (this) {
      case Step2Miss.jobExpiry:
        return "Please select Job Expiry";
    }
  }
}

enum CrewRequirements {
  deckNavigation,
  engine,
  galley;

  String get name {
    switch (this) {
      case CrewRequirements.deckNavigation:
        return "Deck / Navigation";
      case CrewRequirements.engine:
        return "Engine";
      case CrewRequirements.galley:
        return "Galley";
    }
  }
}

class JobPostController extends GetxController {
  RxInt currentStep = 1.obs;
  RxBool isLoading = false.obs;
  //Step 1
  TextEditingController tentativeJoining = TextEditingController();
  TextEditingController grt = TextEditingController();
  RxList<CrewRequirements> crewRequirements = RxList.empty();
  RxList<MapEntry<Rank?, double>> deckRankWithWages = RxList.empty();
  RxList<MapEntry<Rank?, double>> engineRankWithWages = RxList.empty();
  RxList<MapEntry<Rank?, double>> galleyRankWithWages = RxList.empty();
  RxnInt recordVesselType = RxnInt();
  VesselList? vesselList;
  RxList<Rank> ranks = RxList.empty();
  RxList<Step1Miss> step1Misses = RxList.empty();
  //
  //Step2
  RxBool needCOCRequirements = false.obs;
  RxBool needCOPRequirements = false.obs;
  RxBool needWatchKeepingRequirements = false.obs;
  RxList<Coc> cocRequirementsSelected = RxList.empty();
  RxList<Cop> copRequirementsSelected = RxList.empty();
  RxList<WatchKeeping> watchKeepingRequirementsSelected = RxList.empty();
  //
  RxList<Coc> cocs = RxList.empty();
  RxList<Cop> cops = RxList.empty();
  RxList<WatchKeeping> watchKeepings = RxList.empty();
  RxBool showMobileNumber = false.obs;
  RxBool showEmail = false.obs;
  RxInt jobExpiry = 7.obs;
  RxList<Step2Miss> step2Misses = RxList.empty();
  //
  RxBool hasAgreed = false.obs;
  CrewUser? user;

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  instantiate() async {
    if (vesselList != null) {
      return;
    }
    isLoading.value = true;
    user = await getIt<CrewUserProvider>().getCrewUser();
    vesselList = await getIt<VesselListProvider>().getVesselList();
    ranks.value = (await getIt<RanksProvider>().getRankList()) ?? [];
    cocs.value = (await getIt<CocProvider>().getCOCList(userType: 3)) ?? [];
    cops.value = (await getIt<CopProvider>().getCOPList(userType: 3)) ?? [];
    watchKeepings.value = (await getIt<WatchKeepingProvider>()
            .getWatchKeepingList(userType: 3)) ??
        [];
    isLoading.value = false;
  }

  validateStep1() {
    step1Misses.clear();
    deckRankWithWages.removeWhere((e) => e.key == null);
    engineRankWithWages.removeWhere((e) => e.key == null);
    galleyRankWithWages.removeWhere((e) => e.key == null);
    if (tentativeJoining.text.isEmpty) {
      step1Misses.add(Step1Miss.tentativeJoining);
    }
    if (recordVesselType.value == null) {
      step1Misses.add(Step1Miss.vesselType);
    }
    if (grt.text.isEmpty) {
      step1Misses.add(Step1Miss.grt);
    }
    if (crewRequirements.contains(CrewRequirements.deckNavigation) &&
        deckRankWithWages.isEmpty) {
      step1Misses.add(Step1Miss.deckRank);
    }
    if (crewRequirements.contains(CrewRequirements.engine) &&
        engineRankWithWages.isEmpty) {
      step1Misses.add(Step1Miss.engineRank);
    }
    if (crewRequirements.contains(CrewRequirements.galley) &&
        galleyRankWithWages.isEmpty) {
      step1Misses.add(Step1Miss.galleyRank);
    }
    if (step1Misses.isEmpty) {
      currentStep.value = 2;
    }
  }

  validateStep2() {
    step2Misses.clear();
    // if(jobExpiry)
  }
}
