import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/job_post_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/job_post_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class EmployerJobPostsController extends GetxController {
  RxList<JobPost> jobPosts = RxList.empty();
  Rxn<CrewUser> currentEmployerUser = Rxn();
  RxMap<int, String> vesselTypes = RxMap();
  RxMap<int, String> rankTypes = RxMap();
  RxMap<int, String> cocTypes = RxMap();
  RxMap<int, String> copTypes = RxMap();
  RxMap<int, String> watchKeepingTypes = RxMap();
  RxInt resourceLoadingRemaining = RxInt(6);

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  instantiate() async {
    currentEmployerUser.value = UserStates.instance.crewUser ??
        await getIt<CrewUserProvider>().getCrewUser();
    currentEmployerUser.value!.userTypeKey = 3;
    loadJobPosts();
    loadVesselTypes();
    loadRanks();
    loadCOC(userType: currentEmployerUser.value!.userTypeKey!);
    loadCOP(userType: currentEmployerUser.value!.userTypeKey!);
    loadWatchKeeping(userType: currentEmployerUser.value!.userTypeKey!);
  }

  loadJobPosts() async {
    jobPosts.value = await getIt<JobPostProvider>()
        .getJobPosts(employerId: currentEmployerUser.value!.id!);
    resourceLoadingRemaining.value--;
  }

  loadVesselTypes() async {
    final VesselList vesselList =
        (await getIt<VesselListProvider>().getVesselList()) ??
            const VesselList(vessels: []);
    for (final vessel in vesselList.vessels ?? <Vessel>[]) {
      for (final subVessel in vessel.subVessels ?? <SubVessel>[]) {
        vesselTypes[subVessel.id!] = subVessel.name!;
      }
    }
    resourceLoadingRemaining.value--;
  }

  loadRanks() async {
    final ranksList = await getIt<RanksProvider>().getRankList() ?? [];
    for (final rank in ranksList) {
      rankTypes[rank.id!] = rank.name!;
    }
    resourceLoadingRemaining.value--;
  }

  loadCOC({required int userType}) async {
    final cocList =
        await getIt<CocProvider>().getCOCList(userType: userType) ?? [];
    for (final coc in cocList) {
      cocTypes[coc.id!] = coc.name!;
    }
    resourceLoadingRemaining.value--;
  }

  loadCOP({required int userType}) async {
    final copList =
        await getIt<CopProvider>().getCOPList(userType: userType) ?? [];
    for (final cop in copList) {
      copTypes[cop.id!] = cop.name!;
    }
    resourceLoadingRemaining.value--;
  }

  loadWatchKeeping({required int userType}) async {
    final watchKeepingList = await getIt<WatchKeepingProvider>()
            .getWatchKeepingList(userType: userType) ??
        [];
    for (final watchKeeping in watchKeepingList) {
      watchKeepingTypes[watchKeeping.id!] = watchKeeping.name!;
    }
    resourceLoadingRemaining.value--;
  }
}
