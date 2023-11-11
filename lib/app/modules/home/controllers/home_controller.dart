import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/employer_counts_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/employer_counts_provider.dart';
import 'package:join_mp_ship/app/data/providers/fcm_token_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/modules/follow/controllers/followings_controller.dart';
import 'package:join_mp_ship/app/modules/job_opening/controllers/job_opening_controller.dart';
import 'package:join_mp_ship/app/modules/job_openings/controllers/job_openings_controller.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:uni_links/uni_links.dart';
import 'package:join_mp_ship/utils/extensions/string_extensions.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 1.obs;
  RxBool showJobButtons = false.obs;

  final scaffoldKey = GlobalKey<ScaffoldState>();
  RxString selectedDrawerButton = "Home".obs;
  List<Map<String, dynamic>> drawerButtons = [];

  RxBool isLoading = false.obs;

  StreamSubscription<String?>? uriStream;

  List<CrewUser> featuredCompanies = [];

  Rank? selectedRank;

  HomeArguments? args;

  EmployerCounts? employerCounts;

  @override
  void onInit() {
    if (Get.arguments is HomeArguments?) {
      args = Get.arguments;
      selectedRank = args?.selectedRank;
      currentIndex.value = args?.currentIndex ?? 1;
    }
    uriStream = linkStream.listen((event) {
      Uri uri = Uri.parse(event ?? "");
      _handleLink(uri);
    });
    super.onInit();
    _initialize();
  }

  Future<void> _getFeaturedCompanies() async {
    featuredCompanies = await getIt<CrewUserProvider>().getFeaturedCompanies();
  }

  _handleLink(Uri uri) {
    switch (uri.path) {
      case "/job/":
        Get.toNamed(Routes.JOB_OPENING,
            arguments: JobOpeningArguments(
                jobId: int.tryParse(uri.queryParameters['job_id'] ?? "")),
            preventDuplicates: false);
    }
  }

  @override
  void onClose() {
    uriStream?.cancel();
    super.onClose();
  }

  _initialize() async {
    isLoading.value = true;
    final uri = await getInitialUri();
    if (uri != null) {
      _handleLink(uri);
    }
    UserStates.instance.crewUser ??=
        await getIt<CrewUserProvider>().getCrewUser();
    if (UserStates.instance.crewUser?.userTypeKey != 2) {
      employerCounts =
          await getIt<EmployerCountsProvider>().getEmployerCounts();
    }
    if (UserStates.instance.ranks == null ||
        UserStates.instance.ranks?.isEmpty == true) {
      UserStates.instance.ranks = await getIt<RanksProvider>().getRankList();
    }
    await _getFeaturedCompanies();
    _addDrawerButtons();
    if (PreferencesHelper.instance.localFCMToken == null) {
      String? fcmToken = await FirebaseMessaging.instance.getToken();
      if (fcmToken?.nullIfEmpty() != null) {
        PreferencesHelper.instance.setFCMToken(fcmToken!);
        getIt<FcmTokenProvider>().postFCMToken(fcmToken);
      }
    }
    isLoading.value = false;
  }

  _addDrawerButtons() {
    drawerButtons = [
      {
        "title": "Home",
        "iconPath": "assets/icons/home.png",
        "iconSize": 18.0,
        "onTap": () {
          // TODO
        }
      },
      if (UserStates.instance.crewUser?.userTypeKey == 2)
        {
          "title": "Applied Jobs",
          "iconPath": "assets/icons/suitcase.png",
          "iconSize": 18.0,
          "onTap": () {
            Get.toNamed(Routes.CREW_JOB_APPLICATIONS);
          }
        },
      {
        "title": "Liked Jobs",
        "iconPath": "assets/icons/like.png",
        "iconSize": 20.0,
        "onTap": () {
          Get.toNamed(Routes.LIKED_JOBS);
        }
      },
      if (PreferencesHelper.instance.isCrew == true)
        {
          "title": "Followings",
          "iconPath": "assets/icons/like.png",
          "iconSize": 20.0,
          "onTap": () {
            Get.toNamed(Routes.FOLLOW,
                arguments:
                    const FollowArguments(viewType: FollowViewType.following));
          }
        },
      if (PreferencesHelper.instance.isCrew != true)
        {
          "title": "Followers",
          "iconPath": "assets/icons/like.png",
          "iconSize": 20.0,
          "onTap": () {
            Get.toNamed(Routes.FOLLOW,
                arguments:
                    const FollowArguments(viewType: FollowViewType.followers));
          }
        },
      {
        "title": "Find Jobs",
        "iconPath": "assets/icons/search.png",
        "iconSize": 19.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "Notifications",
        "iconPath": "assets/icons/notification.png",
        "iconSize": 20.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "My Profile",
        "iconPath": "assets/icons/profile.png",
        "iconSize": 19.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "Help & Feedback",
        "iconPath": "assets/icons/info.png",
        "iconSize": 18.0,
        "onTap": () {
          // TODO
        }
      },
      {
        "title": "Logout",
        "iconPath": "assets/icons/logout.png",
        "iconSize": 18.0,
        "onTap": () {
          // TODO
        }
      },
    ];
  }
}

class HomeArguments {
  final Rank? selectedRank;
  final int? currentIndex;

  const HomeArguments({this.selectedRank, this.currentIndex});
}
