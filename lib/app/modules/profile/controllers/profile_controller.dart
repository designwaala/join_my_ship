import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class ProfileController extends GetxController {
  RxBool isLoading = false.obs;
  CrewUser? crewUser;

  String get rank =>
      UserStates.instance.ranks?[crewUser?.rankId ?? -1].name ?? "";

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  instantiate() async {
    isLoading.value = true;
    crewUser = UserStates.instance.crewUser ??
        (await getIt<CrewUserProvider>().getCrewUser());
    isLoading.value = false;
  }
}
