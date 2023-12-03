import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/flag_model.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/app/data/models/job_rank_with_wages_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/flag_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_coc_post.dart';
import 'package:join_mp_ship/app/data/providers/job_cop_post.dart';
import 'package:join_mp_ship/app/data/providers/job_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_rank_with_wages_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_watch_keeping_post.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/app/modules/job_post/controllers/job_post_controller.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/extensions/string_extensions.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:collection/collection.dart';

enum Miss {
  tentativeJoining,
  vesselType,
  vesselIMONo,
  flag,
  joiningPort,
  rank,
  jobExpiry,
  coc,
  cop,
  watchKeeping;

  String get errorMessage {
    switch (this) {
      case Miss.tentativeJoining:
        return "Please select a tentative joining date";
      case Miss.vesselType:
        return "Please select a Vessel type";
      case Miss.vesselIMONo:
        return "Please enter IMO No.";
      case Miss.flag:
        return "Please choose Flag";
      case Miss.joiningPort:
        return "Please enter Joining Port";
      case Miss.rank:
        return "Please select a Rank";
      case Miss.jobExpiry:
        return "Please select Job Expiry";
      case Miss.coc:
        return "Please choose a COC Issuing Authority";
      case Miss.cop:
        return "Please choose a COP Issuing Authority";
      case Miss.watchKeeping:
        return "Please choose a Watch Keeping Authority";
    }
  }
}

class CrewReferralController extends GetxController {
  RxBool isLoading = false.obs;
  //Step 1
  TextEditingController tentativeJoining = TextEditingController();
  TextEditingController vesselIMONo = TextEditingController();
  TextEditingController flag = TextEditingController();
  TextEditingController joiningPort = TextEditingController();
  RxnInt recordVesselType = RxnInt();
  VesselList? vesselList;
  RxList<Rank> ranks = RxList.empty();
  RxList<Miss> misses = RxList.empty();
  Rxn<Rank> selectedRank = Rxn();
  Rxn<Flag> selectedFlag = Rxn();
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
  RxInt jobExpiry = 7.obs;
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

  RxBool previewJob = false.obs;
  Rxn<CrewRequirements> selectedCrewRequirement = Rxn();
  List<Flag> flags = [];

  @override
  void onInit() {
    instantiate();
    super.onInit();
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
    flags = (await getIt<FlagProvider>().getFlags()) ?? [];

    if (jobToEdit?.id != null) {
      tentativeJoining.text = jobToEdit?.tentativeJoining ?? "";
      recordVesselType.value = jobToEdit?.vesselId;
      vesselIMONo.text = jobToEdit?.vesselIMO.toString() ?? "";
      flag.text = flags
              .firstWhereOrNull((flag) => flag.id == jobToEdit?.flag)
              ?.countryName ??
          "";
      joiningPort.text = jobToEdit?.joiningPort ?? "";
      jobExpiry.value = int.tryParse(jobToEdit?.expiryInDay ?? "") ?? 0;

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

  validate() {
    if (formKey.currentState?.validate() != true) {
      return;
    }
    misses.clear();

    if (tentativeJoining.text.isEmpty) {
      misses.add(Miss.tentativeJoining);
    }
    if (recordVesselType.value == null) {
      misses.add(Miss.vesselType);
    }
    if (selectedRank.value == null) {
      misses.add(Miss.rank);
    }
    if (vesselIMONo.text.nullIfEmpty() == null) {
      misses.add(Miss.vesselIMONo);
    }
    if (flag.text.nullIfEmpty() == null) {
      misses.add(Miss.flag);
    }
    if (joiningPort.text.nullIfEmpty() == null) {
      misses.add(Miss.joiningPort);
    }
    if (needCOCRequirements.value && cocRequirementsSelected.isEmpty) {
      misses.add(Miss.coc);
    }
    if (needCOPRequirements.value && copRequirementsSelected.isEmpty) {
      misses.add(Miss.cop);
    }
    if (needWatchKeepingRequirements.value &&
        watchKeepingRequirementsSelected.isEmpty) {
      misses.add(Miss.watchKeeping);
    }
    if (misses.isEmpty) {
      previewJob.value = true;
    }
  }

  Future<void> postJob() async {
    isPostingJob.value = true;

    if (jobToEdit?.id == null) {
      //Step 1: Post The Job
      Job? postedJob = await getIt<JobProvider>().postJob(Job(
          tentativeJoining: tentativeJoining.text,
          vesselId: recordVesselType.value,
          expiryInDay: jobExpiry.value.toString(),
          vesselIMO: int.tryParse(vesselIMONo.text.nullIfEmpty() ?? ""),
          flag: selectedFlag.value?.id,
          joiningPort: joiningPort.text.nullIfEmpty()));

      //Step 2: Post Rank
      await getIt<JobRankWithWagesProvider>().postJobRankWithWages(
          JobRankWithWages(
              jobId: postedJob.id, rankNumber: selectedRank.value?.id));

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
          jobToEdit?.expiryInDay == jobExpiry.value.toString()) {
        //Job is not required to be updated
      } else {
        await getIt<JobProvider>().updateJob(Job(
            id: jobToEdit?.id,
            tentativeJoining: tentativeJoining.text,
            vesselId: recordVesselType.value,
            expiryInDay: jobExpiry.value.toString()));
      }

      //Step2: add new ranks if any

      //Step3: delete old ranks if any

      //Step4: Update Rank with Wages if required
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
