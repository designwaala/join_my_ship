import 'package:collection/collection.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/app/data/models/job_rank_with_wages_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_type_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_coc_post.dart';
import 'package:join_mp_ship/app/data/providers/job_cop_post.dart';
import 'package:join_mp_ship/app/data/providers/job_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_rank_with_wages_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_watch_keeping_post.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

enum Step1Miss {
  tentativeJoining,
  vesselType,
  grt,
  deckRank,
  engineRank,
  galleyRank,
  crewRequirements,
  ;

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
      case Step1Miss.crewRequirements:
        return "Please select at least one Crew Requirements";
    }
  }
}

enum Step2Miss {
  jobExpiry,
  coc,
  cop,
  watchKeeping;

  String get errorMessage {
    switch (this) {
      case Step2Miss.jobExpiry:
        return "Please select Job Expiry";
      case Step2Miss.coc:
        return "Please choose a COC Issuing Authority";
      case Step2Miss.cop:
        return "Please choose a COP Issuing Authority";
      case Step2Miss.watchKeeping:
        return "Please choose a Watch Keeping Authority";
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
  //
  FToast fToast = FToast();
  final parentKey = GlobalKey();
  //
  RxBool isPostingJob = false.obs;
  //
  Job? jobToEdit;
  //
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    if (Get.arguments is JobPostArguments?) {
      JobPostArguments? args = Get.arguments;
      jobToEdit = args?.jobToEdit;
    }
    instantiate();
    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
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

    if (jobToEdit?.id != null) {
      tentativeJoining.text = jobToEdit?.tentativeJoining ?? "";
      recordVesselType.value = jobToEdit?.vesselId;
      grt.text = jobToEdit?.gRT ?? "";
      jobExpiry.value = int.tryParse(jobToEdit?.expiryInDay ?? "") ?? 0;
      showEmail.value = jobToEdit?.mailInfo ?? false;
      showMobileNumber.value = jobToEdit?.numberInfo ?? false;
      deckRankWithWages.value = jobToEdit?.jobRankWithWages
              ?.where((jobWithWage) => ranks
                  .where((e) => e.jobType == CrewRequirements.deckNavigation)
                  .any((e) => e.id == jobWithWage.rankNumber))
              .map((e) => MapEntry(
                  ranks.firstWhereOrNull((rank) => rank.id == e.rankNumber),
                  double.parse(e.wages ?? "0")))
              .toList() ??
          [];
      engineRankWithWages.value = jobToEdit?.jobRankWithWages
              ?.where((jobWithWage) => ranks
                  .where((e) => e.jobType == CrewRequirements.engine)
                  .any((e) => e.id == jobWithWage.rankNumber))
              .map((e) => MapEntry(
                  ranks.firstWhereOrNull((rank) => rank.id == e.rankNumber),
                  double.parse(e.wages ?? "0")))
              .toList() ??
          [];
      galleyRankWithWages.value = jobToEdit?.jobRankWithWages
              ?.where((jobWithWage) => ranks
                  .where((e) => e.jobType == CrewRequirements.galley)
                  .any((e) => e.id == jobWithWage.rankNumber))
              .map((e) => MapEntry(
                  ranks.firstWhereOrNull((rank) => rank.id == e.rankNumber),
                  double.parse(e.wages ?? "0")))
              .toList() ??
          [];
      crewRequirements.value = <CrewRequirements>[
        if (deckRankWithWages.isNotEmpty) CrewRequirements.deckNavigation,
        if (engineRankWithWages.isNotEmpty) CrewRequirements.engine,
        if (galleyRankWithWages.isNotEmpty) CrewRequirements.galley
      ];
      cocRequirementsSelected.value = cocs
          .where(
              (coc) => jobToEdit?.jobCoc?.any((e) => e.cocId == coc.id) == true)
          .toList();
      if (cocRequirementsSelected.isNotEmpty) {
        needCOCRequirements.value = true;
      }
      copRequirementsSelected.value = cops
          .where(
              (cop) => jobToEdit?.jobCop?.any((e) => e.copId == cop.id) == true)
          .toList();
      if (copRequirementsSelected.isNotEmpty) {
        needCOPRequirements.value = true;
      }
      watchKeepingRequirementsSelected.value = watchKeepings
          .where((watchKeeping) =>
              jobToEdit?.jobWatchKeeping
                  ?.any((e) => e.watchKeepingId == watchKeeping.id) ==
              true)
          .toList();
      if (watchKeepingRequirementsSelected.isNotEmpty) {
        needWatchKeepingRequirements.value = true;
      }
    }
    isLoading.value = false;
  }

  validateStep1() {
    if (formKey.currentState?.validate() != true) {
      return;
    }
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
    if (crewRequirements.isEmpty) {
      step1Misses.add(Step1Miss.crewRequirements);
    }
    if (step1Misses.isEmpty) {
      currentStep.value = 2;
    }
  }

  validateStep2() {
    step2Misses.clear();
    if (needCOCRequirements.value && cocRequirementsSelected.isEmpty) {
      step2Misses.add(Step2Miss.coc);
    }
    if (needCOPRequirements.value && copRequirementsSelected.isEmpty) {
      step2Misses.add(Step2Miss.cop);
    }
    if (needWatchKeepingRequirements.value &&
        watchKeepingRequirementsSelected.isEmpty) {
      step2Misses.add(Step2Miss.watchKeeping);
    }
    if (step2Misses.isEmpty) {
      currentStep.value = 3;
    }
    // if(jobExpiry)
  }

  Future<void> postJob() async {
    isPostingJob.value = true;

    if (jobToEdit?.id == null) {
      //Step 1: Post The Job
      Job? postedJob = await getIt<JobProvider>().postJob(Job(
          tentativeJoining: tentativeJoining.text,
          vesselId: recordVesselType.value,
          gRT: grt.text,
          expiryInDay: jobExpiry.value.toString(),
          mailInfo: showEmail.value,
          numberInfo: showMobileNumber.value));

      //Step 2: Post All Rank with wages
      await Future.wait([
        ...deckRankWithWages,
        ...engineRankWithWages,
        ...galleyRankWithWages
      ].map((MapEntry<Rank?, double> e) => getIt<JobRankWithWagesProvider>()
              .postJobRankWithWages(JobRankWithWages(
            jobId: postedJob.id,
            rankNumber: e.key?.id,
            wages: e.value.toString(),
          ))));

      //Step 3: Post COC
      await Future.wait(cocRequirementsSelected.map((e) =>
          getIt<JobCOCPostProvider>()
              .postJobCOC(JobCoc(jobId: postedJob.id, cocId: e.id))));

      //Step 4: Post COP
      await Future.wait(copRequirementsSelected.map((e) =>
          getIt<JobCOPPostProvider>()
              .postJobCOP(JobCop(jobId: postedJob.id, copId: e.id))));

      //Step 5: Post Watch Keeping
      await Future.wait(watchKeepingRequirementsSelected.map((e) =>
          getIt<JobWatchKeepingPostProvider>().postJobWatchKeeping(
              JobWatchKeeping(jobId: postedJob.id, watchKeepingId: e.id))));

      fToast.safeShowToast(child: successToast("Job Posted Successfully!"));
    } else {
      //Step1: check whether Job needs to be edited
      if (jobToEdit?.tentativeJoining == tentativeJoining.text &&
          jobToEdit?.vesselId == recordVesselType.value &&
          jobToEdit?.gRT == grt.text &&
          jobToEdit?.expiryInDay == jobExpiry.value.toString() &&
          jobToEdit?.mailInfo == showEmail.value &&
          jobToEdit?.numberInfo == showMobileNumber.value) {
        //Job is not required to be updated
      } else {
        await getIt<JobProvider>().updateJob(Job(
            id: jobToEdit?.id,
            tentativeJoining: tentativeJoining.text,
            vesselId: recordVesselType.value,
            gRT: grt.text,
            expiryInDay: jobExpiry.value.toString(),
            mailInfo: showEmail.value,
            numberInfo: showMobileNumber.value));
      }

      //Step2: add new ranks if any
      await Future.wait([
        ...deckRankWithWages,
        ...engineRankWithWages,
        ...galleyRankWithWages
      ]
          .where((rankWithWage) =>
              jobToEdit?.jobRankWithWages
                  ?.none((p0) => p0.rankNumber == rankWithWage.key?.id) ==
              true)
          .map((e) => getIt<JobRankWithWagesProvider>()
                  .postJobRankWithWages(JobRankWithWages(
                jobId: jobToEdit?.id,
                rankNumber: e.key?.id,
                wages: e.value.toString(),
              ))));

      //Step3: delete old ranks if any
      await Future.wait(jobToEdit?.jobRankWithWages
              ?.where((rankWithWages) => [
                    ...deckRankWithWages,
                    ...engineRankWithWages,
                    ...galleyRankWithWages
                  ].none((p0) => p0.key?.id == rankWithWages.rankNumber))
              .map((jobRankWithWages) => getIt<JobRankWithWagesProvider>()
                  .deleteJobRankWithWages(jobRankWithWages)) ??
          [Future.value(null)]);

      //Step4: Update Rank with Wages if required
      await Future.wait([
        ...deckRankWithWages,
        ...engineRankWithWages,
        ...galleyRankWithWages
      ]
          .where((rankWithWage) =>
              jobToEdit?.jobRankWithWages?.any((e) =>
                  e.rankNumber == rankWithWage.key?.id &&
                  double.tryParse(e.wages ?? "") != rankWithWage.value) ==
              true)
          .map((e) => e.updateJob(jobToEdit)));
    }

    //Step 5: Delete COCs if any
    await Future.wait(jobToEdit?.jobCoc
            ?.where((coc) =>
                cocRequirementsSelected.none((p0) => p0.id == coc.cocId))
            .map((coc) => coc.id == null
                ? Future.value(null)
                : getIt<JobCOCPostProvider>()
                    .deleteJobCOC(JobCoc(id: coc.id))) ??
        [Future.value(null)]);

    //Step 6: Add COCs if any
    await Future.wait(cocRequirementsSelected
        .where((coc) =>
            jobToEdit?.jobCoc?.none((p0) => p0.cocId == coc.id) == true)
        .map((e) => getIt<JobCOCPostProvider>()
            .postJobCOC(JobCoc(cocId: e.id, jobId: jobToEdit?.id))));

    //Step 7: Delete COPs if any
    await Future.wait(jobToEdit?.jobCop
            ?.where((cop) =>
                copRequirementsSelected.none((p0) => p0.id == cop.copId))
            .map((cop) => cop.id == null
                ? Future.value(null)
                : getIt<JobCOPPostProvider>()
                    .deleteJobCOP(JobCop(jobId: jobToEdit?.id, id: cop.id))) ??
        [Future.value(null)]);

    //Step 8: Add COPs if any
    await Future.wait(copRequirementsSelected
        .where((cop) =>
            jobToEdit?.jobCop?.none((p0) => p0.copId == cop.id) == true)
        .map((e) => getIt<JobCOPPostProvider>()
            .postJobCOP(JobCop(jobId: jobToEdit?.id, copId: e.id))));

    //Step 9: Delete Watch Keepings if any
    await Future.wait(jobToEdit?.jobWatchKeeping
            ?.where((watchKeeping) => watchKeepingRequirementsSelected
                .none((p0) => p0.id == watchKeeping.watchKeepingId))
            .map((watchKeeping) => watchKeeping.id == null
                ? Future.value(null)
                : getIt<JobWatchKeepingPostProvider>().deleteJobWatchKeeping(
                    JobWatchKeeping(id: watchKeeping.id))) ??
        [Future.value(null)]);

    //Step 10: Add Watch Keepings if any
    await Future.wait(watchKeepingRequirementsSelected
        .where((watchKeeping) =>
            jobToEdit?.jobWatchKeeping
                ?.none((p0) => p0.watchKeepingId == watchKeeping.id) ==
            true)
        .map((e) => getIt<JobWatchKeepingPostProvider>().postJobWatchKeeping(
            JobWatchKeeping(jobId: jobToEdit?.id, watchKeepingId: e.id))));

    isPostingJob.value = false;
  }
}

class JobPostArguments {
  final Job? jobToEdit;
  const JobPostArguments({this.jobToEdit});
}

extension JobUpdate on MapEntry<Rank?, double>? {
  Future<void> updateJob(Job? job) {
    print("Updating Job Post for ${this?.key?.name} ${this?.value}");
    return this == null
        ? Future.value(null)
        : getIt<JobRankWithWagesProvider>().updateJobRankWithWages(
            JobRankWithWages(
                id: job
                    ?.jobRankWithWages
                    ?.firstWhereOrNull((rankWithWage) =>
                        rankWithWage.rankNumber == this?.key?.id)
                    ?.id,
                jobId: job?.id,
                rankNumber: this?.key?.id,
                wages: this?.value.toString()));
  }
}
