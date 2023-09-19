import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/follow_model.dart';
import 'package:join_mp_ship/app/data/providers/follow_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class FollowingsController extends GetxController {
  RxBool isLoading = false.obs;
  List<Follow> follows = [];
  RxnInt unfollowId = RxnInt();

  FollowArguments? args;

  @override
  void onInit() {
    if (Get.arguments is FollowArguments?) {
      args = Get.arguments;
    }
    if (args?.viewType == FollowViewType.followers) {
      _getMyFollowers();
    } else {
      _getMyFollowings();
    }
    super.onInit();
  }

  Future<void> _getMyFollowers() async {
    isLoading.value = true;
    follows = (await getIt<FollowProvider>().getMyFollowers()) ?? [];
    UserStates.instance.ranks ??= await getIt<RanksProvider>().getRankList();
    isLoading.value = false;
  }

  Future<void> _getMyFollowings() async {
    isLoading.value = true;
    follows = (await getIt<FollowProvider>().getMyFollowings()) ?? [];
    UserStates.instance.ranks ??= await getIt<RanksProvider>().getRankList();
    isLoading.value = false;
  }

  Future<void> unfollow(int unfollowId) async {
    this.unfollowId.value = unfollowId;
    int? statusCode = await getIt<FollowProvider>().unfollow(unfollowId);
    if (statusCode == 204) {
      follows.removeWhere((element) => element.id == unfollowId);
    }
    this.unfollowId.value = null;
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

enum FollowViewType { following, followers }

class FollowArguments {
  final FollowViewType viewType;
  const FollowArguments({required this.viewType});
}
