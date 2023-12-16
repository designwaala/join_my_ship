import 'dart:async';

import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/app/modules/employer_create_user/controllers/employer_create_user_controller.dart';
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
  GlobalKey<CurvedNavigationBarState> bottomNavigationKey =
      GlobalKey<CurvedNavigationBarState>();

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
      try {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        if (fcmToken?.nullIfEmpty() != null) {
          PreferencesHelper.instance.setFCMToken(fcmToken!);
          getIt<FcmTokenProvider>().postFCMToken(fcmToken);
        }
      } catch (e) {}
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
          currentIndex.value = 1;
          final CurvedNavigationBarState? navBarState =
              bottomNavigationKey.currentState;
          navBarState?.setPage(0);
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
          currentIndex.value = 4;
          final CurvedNavigationBarState? navBarState =
              bottomNavigationKey.currentState;
          navBarState?.setPage(3);
        }
      },
      {
        "title": "Notifications",
        "iconPath": "assets/icons/notification.png",
        "iconSize": 20.0,
        "onTap": () {
          Get.toNamed(Routes.NOTIFICATION);
        }
      },
      {
        "title": "My Profile",
        "iconPath": "assets/icons/profile.png",
        "iconSize": 19.0,
        "onTap": () async {
          if (UserStates.instance.crewUser?.userTypeKey == 2) {
            await Get.toNamed(Routes.CREW_ONBOARDING,
                arguments: const CrewOnboardingArguments(editMode: true));
          } else {
            await Get.toNamed(Routes.EMPLOYER_CREATE_USER,
                arguments: const EmployerCreateUserArguments(editMode: true));
          }
        }
      },
      {
        "title": "Help & Feedback",
        "iconPath": "assets/icons/info.png",
        "iconSize": 18.0,
        "onTap": () {
          Get.toNamed(Routes.HELP);
        }
      },
      {
        "title": "Logout",
        "iconPath": "assets/icons/logout.png",
        "iconSize": 18.0,
        "onTap": () async {
          UserStates.instance.reset();
          await FirebaseAuth.instance.signOut();
          await PreferencesHelper.instance.clearAll();
          Get.offAllNamed(Routes.SPLASH);
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
