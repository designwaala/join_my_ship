import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/boosting_model.dart';
import 'package:join_mp_ship/app/data/models/current_resume_pack.dart';
import 'package:join_mp_ship/app/data/models/current_resume_top_up.dart';
import 'package:join_mp_ship/app/data/models/highlight_model.dart';
import 'package:join_mp_ship/app/data/providers/boosting_provider.dart';
import 'package:join_mp_ship/app/data/providers/highlight_provider.dart';
import 'package:join_mp_ship/app/data/providers/resume_pack_provider.dart';
import 'package:join_mp_ship/app/data/providers/resume_pack_buy_provider.dart';
import 'package:join_mp_ship/app/data/providers/resume_top_up_buy_provider.dart';
import 'package:join_mp_ship/app/data/providers/resume_top_up_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class SubscriptionsController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingPlans = false.obs;
  RxBool isLoadingPurchases = false.obs;
  Rxn<SubscriptionViewTypes> view = Rxn(SubscriptionViewTypes.buyPlans);

  RxnInt buyingPlan = RxnInt();
  RxnInt toppingUpPlan = RxnInt();

  final parentKey = GlobalKey();
  FToast fToast = FToast();

  RxBool showResumePacks = true.obs;
  RxBool showResumeTopUpPacks = true.obs;

  RxBool showResumePacksPurchases = true.obs;
  RxBool showResumeTopUpPurchases = true.obs;

  RxBool showBoostings = true.obs;

  RxBool showHighlights = true.obs;

  RxList<CurrentResumePack> currentPackPurchases = RxList.empty();
  RxList<CurrentResumeTopUpPack> currentTopUpPurchases = RxList.empty();
  RxList<Employer> currentEmployerBoostings = RxList.empty();
  Rxn<Crew> currentCrewBoostings = Rxn();

  RxList<Highlight> currentCrewHighlights = RxList.empty();

  @override
  void onInit() {
    super.onInit();
    instantiate();
  }

  Future<void> instantiate() async {
    isLoading.value = true;
    UserStates.instance.resumePacks ??=
        await getIt<ResumePackProvider>().getResumePacks();
    UserStates.instance.resumeTopUps ??=
        await getIt<ResumeTopUpProvider>().getResumeTopUp();
    UserStates.instance.vessels ??=
        await getIt<VesselListProvider>().getVesselList();
    UserStates.instance.crewUser?.userTypeKey != 2
        ? await _employerData()
        : await _crewData();
    isLoading.value = false;
  }

  Future<void> getPurchases() async {
    isLoadingPurchases.value = true;
    UserStates.instance.crewUser?.userTypeKey != 2
        ? await _employerData()
        : await _crewData();
    isLoadingPurchases.value = false;
  }

  Future<void> _employerData() async {
    currentPackPurchases.value =
        (await getIt<ResumePackBuyProvider>().getCurrentBoughtPacks()) ?? [];
    currentTopUpPurchases.value =
        (await getIt<ResumeTopUpBuyProvider>().getTopUpPurchases()) ?? [];
    currentEmployerBoostings.value =
        (await getIt<BoostingProvider>().getEmployerBoostings()) ?? [];
  }

  Future<void> _crewData() async {
    currentCrewBoostings.value =
        await getIt<BoostingProvider>().getCrewBoostings();
    currentCrewHighlights.value =
        (await getIt<HighlightProvider>().fetchCrewHighlight()) ?? [];
  }

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> buyPlan(int planId) async {
    buyingPlan.value = planId;
    final response = await getIt<ResumePackBuyProvider>().buyResumePack(planId);
    if (response?.id != null) {
      fToast.showToast(child: successToast("Plan Activated"));
    }
    buyingPlan.value = null;
  }

  Future<void> topUp(int topUpId) async {
    toppingUpPlan.value = topUpId;
    final response = await getIt<ResumeTopUpBuyProvider>().buyTopUp(topUpId);
    if (response?.id != null) {
      fToast.showToast(child: successToast("Top Up Activated"));
    }
    toppingUpPlan.value = null;
  }
}

enum SubscriptionViewTypes {
  buyPlans,
  activePlans;

  String get name {
    switch (this) {
      case SubscriptionViewTypes.buyPlans:
        return "Buy Plans";
      case SubscriptionViewTypes.activePlans:
        return "Active Plans";
    }
  }
}
