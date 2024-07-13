import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/boosting_model.dart';
import 'package:join_my_ship/app/data/models/current_job_post_pack.dart';
import 'package:join_my_ship/app/data/models/current_resume_pack.dart';
import 'package:join_my_ship/app/data/models/current_resume_top_up.dart';
import 'package:join_my_ship/app/data/models/highlight_model.dart';
import 'package:join_my_ship/app/data/models/job_post_plan_model.dart';
import 'package:join_my_ship/app/data/models/job_post_plan_top_up_model.dart';
import 'package:join_my_ship/app/data/models/job_post_top_up_packs.dart';
import 'package:join_my_ship/app/data/models/subscription_model.dart';
import 'package:join_my_ship/app/data/models/subscription_plan_model.dart';
import 'package:join_my_ship/app/data/providers/boosting_provider.dart';
import 'package:join_my_ship/app/data/providers/current_job_post_provider.dart';
import 'package:join_my_ship/app/data/providers/highlight_provider.dart';
import 'package:join_my_ship/app/data/providers/job_post_plan_provider.dart';
import 'package:join_my_ship/app/data/providers/job_post_plan_top_up_provider.dart';
import 'package:join_my_ship/app/data/providers/resume_pack_provider.dart';
import 'package:join_my_ship/app/data/providers/resume_pack_buy_provider.dart';
import 'package:join_my_ship/app/data/providers/resume_top_up_buy_provider.dart';
import 'package:join_my_ship/app/data/providers/resume_top_up_provider.dart';
import 'package:join_my_ship/app/data/providers/subscription_plan_provider.dart';
import 'package:join_my_ship/app/data/providers/subscription_provider.dart';
import 'package:join_my_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';

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

  RxBool showJobPostPacks = true.obs;
  RxBool showJobPostTopUpPacks = true.obs;

  RxnInt jobPostPlanBeingBought = RxnInt();
  RxnInt jobPostTopUpPlan = RxnInt();

  RxBool showJobPostPurchases = true.obs;
  RxBool showJobPostTopUpPurchases = true.obs;

  JobPostPlanTopUp? currentJobPostTopUps;
  List<CurrentJobPostPack>? currentJobPostPacks;

  SubscriptionPlan? jobPostTopUpPack;
  // List<Subscription> jobPostPacks = [];
  List<JobPostPlan> jobPostPacks = [];

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
    if (UserStates.instance.crewUser?.userTypeKey == 5) {
      await getJobPostData();
      await getJobPostPlanAndTopUp();
    }
    isLoading.value = false;
  }

  Future<void> getJobPostData() async {
    currentJobPostTopUps =
        await getIt<JobPostPlanTopUpProvider>().getJobPostPlanTopUp();
    final allJobPostPlans =
        (await getIt<CurrentJobPostProvider>().getCurrentJobPostPacks()) ?? [];
    currentJobPostPacks = allJobPostPlans.where((e) => e.isActive == true).toList();
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

  Future<void> getJobPostPlanAndTopUp() async {
    jobPostTopUpPack =
        await getIt<SubscriptionPlanProvider>().getSubscriptionPlan(37);
    jobPostPacks =
        (await getIt<JobPostPlanProvider>().getJobPostPlan()) ??
            [];
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

  Future<void> buyJobPostPlan(int packId) async {
    jobPostPlanBeingBought.value = packId;
    final response = await getIt<CurrentJobPostProvider>().buyJobPost(packId);
    if (response?.id != null) {
      fToast.showToast(child: successToast("Job Post Plan Activated"));
    }
    jobPostPlanBeingBought.value = null;
  }

  Future<void> topUpJobPostPlan({required JobPostTopUpPack topUpPack}) async {
    jobPostTopUpPlan.value = topUpPack.pointsUsed;
    final response = await getIt<JobPostPlanTopUpProvider>().jobPostPlanTopUp(
        postPurchased: topUpPack.postPurchased ?? 0,
        pointsUsed:
            ((topUpPack.postPurchased ?? 0) * (jobPostTopUpPack?.points ?? 0)));
    if (response?.id != null) {
      fToast.safeShowToast(child: successToast("Job Post Plan Topped Up"));
    }
    jobPostTopUpPlan.value = null;
  }
}

int jobPostTopUp = 500;

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
