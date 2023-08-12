import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/application_model.dart';
import 'package:join_mp_ship/app/data/models/coc_model.dart';
import 'package:join_mp_ship/app/data/models/cop_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/watch_keeping_model.dart';
import 'package:join_mp_ship/app/data/providers/application_provider.dart';
import 'package:join_mp_ship/app/data/providers/coc_provider.dart';
import 'package:join_mp_ship/app/data/providers/cop_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/watch_keeping_provider.dart';
import 'package:join_mp_ship/main.dart';

class CrewJobApplicationsController extends GetxController {
  RxList<Application> applications = RxList.empty();
    VesselList? vesselList;
  RxList<Rank> ranks = RxList.empty();
  RxList<Coc> cocs = RxList.empty();
  RxList<Cop> cops = RxList.empty();
  RxList<WatchKeeping> watchKeepings = RxList.empty();
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  instantiate() async {
    isLoading.value = true;
    applications.value =
        (await getIt<ApplicationProvider>().getAppliedJobList())?.results ?? [];

    vesselList = await getIt<VesselListProvider>().getVesselList();

    ranks.value = (await getIt<RanksProvider>().getRankList()) ?? [];

    cocs.value = (await getIt<CocProvider>().getCOCList(userType: 3)) ?? [];

    cops.value = (await getIt<CopProvider>().getCOPList(userType: 3)) ?? [];

    watchKeepings.value = (await getIt<WatchKeepingProvider>()
            .getWatchKeepingList(userType: 3)) ??
        [];
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }
}
