import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class CrewListController extends GetxController {
  Rank? selectedRank;
  RxBool isLoading = false.obs;
  List<CrewUser>? crewList;

  CrewListArguments? args;

  @override
  void onInit() {
    if (Get.arguments is CrewListArguments?) {
      args = Get.arguments;
    }
    selectedRank = args?.rank;
    getCrewList();
    super.onInit();
  }

  Future<void> getCrewList() async {
    if (selectedRank?.name == null) {
      return;
    }
    isLoading.value = true;
    crewList =
        await getIt<CrewUserProvider>().findCrewByRank(selectedRank!.name!);
    await UserStates.instance.getRanksIfEmpty();
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class CrewListArguments {
  final Rank? rank;
  const CrewListArguments({this.rank});
}
