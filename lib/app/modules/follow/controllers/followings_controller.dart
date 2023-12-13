import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/follow_model.dart';
import 'package:join_mp_ship/app/data/providers/follow_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class FollowingsController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<Follow> follows = RxList.empty();
  RxnInt unfollowId = RxnInt();

  FollowArguments? args;

  RxBool showDownloadedResume = false.obs;
  List<DownloadTask>? tasks;

  @override
  void onInit() {
    if (Get.arguments is FollowArguments?) {
      args = Get.arguments;
    }
    switch (args?.viewType) {
      case FollowViewType.following:
        _getMyFollowings();
        break;
      case FollowViewType.followers:
        _getMyFollowers();
        break;
      case FollowViewType.savedProfile:
        _getMyFollowings();
        break;
    }
    super.onInit();
  }

  Future<void> _getMyFollowers() async {
    isLoading.value = true;
    follows.value = (await getIt<FollowProvider>().getMyFollowers()) ?? [];
    UserStates.instance.ranks ??= await getIt<RanksProvider>().getRankList();
    isLoading.value = false;
  }

  Future<void> _getMyFollowings() async {
    isLoading.value = true;
    follows.value = (await getIt<FollowProvider>().getMyFollowings()) ?? [];
    UserStates.instance.ranks ??= await getIt<RanksProvider>().getRankList();
    tasks = await FlutterDownloader.loadTasks();
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

enum FollowViewType { following, followers, savedProfile }

class FollowArguments {
  final FollowViewType viewType;
  const FollowArguments({required this.viewType});
}
