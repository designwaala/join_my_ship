import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:join_my_ship/app/data/models/boosting_model.dart';
import 'package:join_my_ship/app/data/models/ranks_model.dart';
import 'package:join_my_ship/app/modules/boosting/views/boosting_view.dart';
import 'package:join_my_ship/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:join_my_ship/app/modules/crew_list/controllers/crew_list_controller.dart';
import 'package:join_my_ship/app/modules/follow/controllers/followings_controller.dart';
import 'package:join_my_ship/app/modules/job_openings/controllers/job_openings_controller.dart';
import 'package:join_my_ship/app/modules/job_openings/views/job_openings_view.dart';
import 'package:join_my_ship/app/modules/profile/views/profile_view.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/widgets/custom_elevated_button.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GestureDetector(
        onTap: () {
          controller.showJobButtons.value = false;
        },
        child: Stack(
          children: [
            Scaffold(
              key: controller.scaffoldKey,
              drawer: SafeArea(
                child: Drawer(
                  width: 256,
                  child: CustomScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      slivers: [
                        SliverFillRemaining(
                          hasScrollBody: false,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(colors: [
                                    Color.fromRGBO(64, 123, 255, 1),
                                    Color.fromRGBO(1, 66, 211, 1),
                                  ]),
                                ),
                                padding:
                                    const EdgeInsets.only(top: 26, bottom: 16),
                                child: Row(
                                  children: [
                                    24.horizontalSpace,
                                    CachedNetworkImage(
                                      imageUrl: UserStates
                                              .instance.crewUser?.profilePic ??
                                          "",
                                      height: 40,
                                      width: 40,
                                      imageBuilder: (context, imageProvider) {
                                        return Container(
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover)),
                                        );
                                      },
                                    ),
                                    16.horizontalSpace,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              UserStates.instance.crewUser?.firstName ?? "",
                                              style: Get.textTheme.bodyMedium
                                                  ?.copyWith(
                                                      color: Colors.white)),
                                          Text(
                                              "${UserStates.instance.crewUser?.email}",
                                              overflow: TextOverflow.ellipsis,
                                              style: Get.textTheme.bodyMedium
                                                  ?.copyWith(
                                                      fontSize: 12,
                                                      color: Colors.white))
                                        ],
                                      ),
                                    ),
                                    24.horizontalSpace
                                  ],
                                ),
                              ),
                              24.verticalSpace,
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 24),
                                child: Column(
                                    children:
                                        controller.drawerButtons.map((button) {
                                  final selected = button["title"] ==
                                      controller.selectedDrawerButton.value;
                                  return ListTile(
                                    selected: selected,
                                    contentPadding: const EdgeInsets.all(0),
                                    title: Row(
                                      children: [
                                        button["iconPath"].contains(".png")
                                            ? ImageIcon(
                                                AssetImage(button["iconPath"]),
                                                color: selected
                                                    ? Colors.blue
                                                    : Colors.black54,
                                                size: button["iconSize"],
                                              )
                                            : SvgPicture.asset(
                                                button["iconPath"],
                                                color: selected
                                                    ? Colors.blue
                                                    : Colors.black54,
                                                height: button["iconSize"],
                                              ),
                                        (15 + 22 - button["iconSize"])
                                            .horizontalSpace,
                                        Text(
                                          button["title"],
                                          style: Get.textTheme.bodyMedium
                                              ?.copyWith(
                                                  fontSize: 15,
                                                  color: selected
                                                      ? Colors.blue
                                                      : Colors.black),
                                        ),
                                      ],
                                    ),
                                    onTap: () {
                                      controller.selectedDrawerButton.value =
                                          button["title"];
                                      controller.scaffoldKey.currentState
                                          ?.closeDrawer();
                                      button["onTap"].call();
                                    },
                                  );
                                }).toList()),
                              ),
                              const Spacer(),
                              Text(
                                "Join My Ship",
                                style: Get.theme.textTheme.bodyMedium?.copyWith(
                                    color: Colors.blue,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w400,
                                    fontFamily:
                                        GoogleFonts.racingSansOne().fontFamily),
                              ),
                              const Text(
                                "www.joinmyship.com",
                                style: TextStyle(fontSize: 10),
                              ),
                              30.verticalSpace,
                            ],
                          ),
                        ),
                      ]),
                ),
              ),
              body: controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : () {
                      switch (controller.currentIndex.value) {
                        case 1:
                          return UserStates.instance.crewUser?.userTypeKey == 2
                              ? _buildBody()
                              : _buildEmployerDashboard();
                        case 2:
                          return const BoostingView();
                        case 3:
                          return const SizedBox();
                        case 4:
                          return const JobOpeningsView();
                        case 5:
                          return const ProfileView();
                        default:
                          return const SizedBox();
                      }
                    }(),
              // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: CurvedNavigationBar(
                key: controller.bottomNavigationKey,
                height: 64,
                backgroundColor: Colors.transparent,
                buttonBackgroundColor: Colors.white,
                items: bottomIcons
                    .mapIndexed(
                        (index, e) => index == controller.currentIndex.value - 1
                            ? e.icon
                            : ColorFiltered(
                                colorFilter: const ColorFilter.matrix([
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0.2126,
                                  0.7152,
                                  0.0722,
                                  0,
                                  0,
                                  0,
                                  0,
                                  0,
                                  1,
                                  0,
                                ]),
                                child: e.icon))
                    .toList(),
                onTap: (index) {
                  if (index != 2) {
                    controller.showJobButtons.value = false;
                    controller.currentIndex.value = index + 1;
                  } else {
                    controller.showJobButtons.value = true;
                  }
                },
              ),
            ),
            if (UserStates.instance.crewUser?.isVerified == 1)
              Positioned(
                  bottom: 72,
                  left: 0,
                  right: 0,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: controller.showJobButtons.value
                        ? (UserStates.instance.crewUser?.userTypeKey ?? 0) >= 3
                            ? IntrinsicWidth(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: CustomElevatedButon(
                                              onPressed: () {
                                                Get.toNamed(Routes.JOB_POST);
                                              },
                                              child:
                                                  const Text("Post a new job")),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: CustomElevatedButon(
                                              onPressed: () {
                                                Get.toNamed(
                                                    Routes.EMPLOYER_JOB_POSTS);
                                              },
                                              child: const Text(
                                                  "View posted jobs")),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            : IntrinsicWidth(
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: CustomElevatedButon(
                                              onPressed: () {
                                                Get.toNamed(
                                                    Routes.CREW_REFERRAL);
                                              },
                                              child: const Text("Refer a job")),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Expanded(
                                          child: CustomElevatedButon(
                                              onPressed: () {
                                                Get.toNamed(
                                                    Routes.EMPLOYER_JOB_POSTS);
                                              },
                                              child: const Text(
                                                  "View referred jobs")),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                        : const SizedBox(),
                  ))
          ],
        ),
      );
    });
  }

  _buildEmployerDashboard() {
    return Column(
      children: [
        Stack(
          children: [
            ClipPath(
              clipper: CustomShape(),
              child: Container(
                height: 210.h,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromRGBO(1, 66, 211, 1),
                  Color.fromRGBO(64, 123, 255, 1)
                ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    (Get.mediaQuery.viewPadding.top + 26).verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.horizontalSpace,
                        InkWell(
                          child:
                              const Icon(Icons.menu_sharp, color: Colors.white),
                          onTap: () =>
                              controller.scaffoldKey.currentState?.openDrawer(),
                        ),
                        16.horizontalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Welcome",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            Text(
                                "${UserStates.instance.crewUser?.firstName ?? ""} ${UserStates.instance.crewUser?.lastName ?? ""}",
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white))
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              Get.toNamed(Routes.NOTIFICATION);
                            },
                            child: const Icon(Icons.notifications,
                                color: Colors.white)),
                        16.horizontalSpace
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16.h,
              left: 28,
              right: 28,
              child: PhysicalModel(
                borderRadius: BorderRadius.circular(64),
                color: Colors.white,
                elevation: 5.0,
                shadowColor: const Color.fromRGBO(46, 4, 142, 0.08),
                child: TypeAheadField<Rank>(
                    textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Search CV here...",
                            hintStyle: Get.textTheme.bodyMedium
                                ?.copyWith(color: Colors.grey),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Icon(Icons.search,
                                  color: Get.theme.primaryColor),
                            ),
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(64)))),
                    suggestionsCallback: (String pattern) {
                      return UserStates.instance.ranks?.where((rank) =>
                              rank.name
                                  ?.toUpperCase()
                                  .contains(pattern.toUpperCase()) ==
                              true) ??
                          [];
                    },
                    itemBuilder: (context, rank) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(rank.name ?? ""),
                      );
                    },
                    onSuggestionSelected: (Rank rank) async {
                      controller.selectedRank = rank;
                      Get.toNamed(Routes.CREW_LIST,
                          arguments: CrewListArguments(rank: rank),
                          preventDuplicates: false);
                    }),
              ),
            ),
          ],
        ),
        Expanded(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            8.verticalSpace,
            Row(children: [
              28.horizontalSpace,
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.EMPLOYER_JOB_POSTS);
                  },
                  child: Container(
                    height: 93,
                    decoration: BoxDecoration(
                        boxShadow: [
                          const BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.03),
                              blurRadius: 4,
                              spreadRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(22),
                        gradient: const LinearGradient(colors: [
                          Color(0xFFFBFBFB),
                          Color(0xFFFFFFFF),
                        ])),
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("${controller.employerCounts?.jobCount ?? 0}",
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w700)),
                            8.horizontalSpace,
                            const Icon(Icons.keyboard_arrow_right,
                                color: Colors.grey)
                          ],
                        ),
                        const Text("Jobs Posted",
                            style: TextStyle(fontSize: 14, color: Colors.grey))
                      ],
                    ),
                  ),
                ),
              ),
              18.horizontalSpace,
              Expanded(
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.FOLLOW,
                        arguments: const FollowArguments(
                            viewType: FollowViewType.savedProfile));
                  },
                  child: Container(
                    height: 93,
                    decoration: BoxDecoration(
                        boxShadow: [
                          const BoxShadow(
                              color: Color.fromRGBO(0, 0, 0, 0.03),
                              blurRadius: 4,
                              spreadRadius: 2)
                        ],
                        borderRadius: BorderRadius.circular(22),
                        gradient: const LinearGradient(colors: [
                          Color(0xFFFBFBFB),
                          Color(0xFFFFFFFF),
                        ])),
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("${controller.savedProfiles.value ?? 0}",
                                style: const TextStyle(
                                    fontSize: 24, fontWeight: FontWeight.w700)),
                            8.horizontalSpace,
                            const Icon(Icons.keyboard_arrow_right,
                                color: Colors.grey)
                          ],
                        ),
                        const Text("Saved Profiles",
                            style: TextStyle(fontSize: 14, color: Colors.grey))
                      ],
                    ),
                  ),
                ),
              ),
              28.horizontalSpace
            ]),
            8.verticalSpace,
            Row(
              children: [
                28.horizontalSpace,
                Text("Featured Companies",
                    style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 18.sp)),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.COMPANIES);
                    },
                    child: Text("More",
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Get.theme.primaryColor))),
                28.horizontalSpace
              ],
            ),
            4.verticalSpace,
            ...controller.featuredCompanies.map(
              (company) => InkWell(
                onTap: () {
                  Get.toNamed(Routes.COMPANY_DETAIL,
                      arguments: CompanyDetailArguments(employer: company));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.r),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 4,
                            spreadRadius: 1)
                      ]),
                  child: Row(
                    children: [
                      Container(
                        height: 50.h,
                        width: 50.h,
                        decoration: BoxDecoration(
                            color: Color(int.parse(
                                    "${company.companyName?.split("").firstOrNull?.codeUnitAt(0)}${company.id ?? 0}",
                                    radix: 16))
                                .withAlpha(0xff),
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                            child: Text(
                                company.companyName?.split("").firstOrNull ??
                                    "",
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white))),
                      ),
                      20.horizontalSpace,
                      Flexible(
                        child: Text(company.companyName ?? "",
                            maxLines: 2,
                            style: Get.textTheme.bodyMedium?.copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ),
            ),
            16.verticalSpace
          ],
        )),
        // 65.verticalSpace
      ],
    );
  }

  _buildBody() {
    return Column(
      children: [
        Stack(
          children: [
            ClipPath(
              clipper: CustomShape(),
              child: Container(
                height: 210.h,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(colors: [
                  Color.fromRGBO(1, 66, 211, 1),
                  Color.fromRGBO(64, 123, 255, 1)
                ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    (Get.mediaQuery.viewPadding.top + 26).verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        16.horizontalSpace,
                        InkWell(
                          child:
                              const Icon(Icons.menu_sharp, color: Colors.white),
                          onTap: () =>
                              controller.scaffoldKey.currentState?.openDrawer(),
                        ),
                        16.horizontalSpace,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text("Welcome",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white)),
                            Text(
                                "${UserStates.instance.crewUser?.firstName ?? ""} ${UserStates.instance.crewUser?.lastName ?? ""}",
                                style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white))
                          ],
                        ),
                        const Spacer(),
                        InkWell(
                            onTap: () {
                              Get.toNamed(Routes.NOTIFICATION);
                            },
                            child: const Icon(Icons.notifications,
                                color: Colors.white)),
                        16.horizontalSpace
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 16.h,
              left: 28,
              right: 28,
              child: PhysicalModel(
                borderRadius: BorderRadius.circular(64),
                color: Colors.white,
                elevation: 5.0,
                shadowColor: const Color.fromRGBO(46, 4, 142, 0.08),
                child: TypeAheadField<Rank>(
                    textFieldConfiguration: TextFieldConfiguration(
                        decoration: InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: "Search job here...",
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            prefixIcon: Icon(Icons.search,
                                color: Get.theme.primaryColor),
                            border: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.circular(64)))),
                    suggestionsCallback: (String pattern) {
                      return UserStates.instance.ranks?.where((rank) =>
                              rank.name
                                  ?.toUpperCase()
                                  .contains(pattern.toUpperCase()) ==
                              true) ??
                          [];
                    },
                    itemBuilder: (context, rank) {
                      return Padding(
                        padding: const EdgeInsets.all(12),
                        child: Text(rank.name ?? ""),
                      );
                    },
                    onSuggestionSelected: (Rank rank) async {
                      controller.selectedRank = rank;
                      Get.toNamed(Routes.JOB_OPENINGS,
                          arguments: JobOpeningsArguments(rankFilter: rank),
                          preventDuplicates: false);
                    }),
              ),
            ),
          ],
        ),
        Expanded(
            child: ListView(
          padding: EdgeInsets.zero,
          children: [
            8.verticalSpace,
            InkWell(
              onTap: () {
                Get.toNamed(Routes.JOB_OPENINGS,
                    arguments: JobOpeningsArguments(
                        rankFilter: UserStates.instance.ranks?.firstWhereOrNull(
                            (rank) =>
                                rank.id ==
                                UserStates.instance.crewUser?.rankId)));
              },
              child: Stack(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 28, vertical: 16),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    height: 95,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade500,
                              blurRadius: 4,
                              offset: const Offset(4, 4))
                        ],
                        borderRadius: BorderRadius.circular(22),
                        gradient: const LinearGradient(colors: [
                          Color.fromRGBO(1, 66, 211, 1),
                          Color.fromRGBO(92, 197, 255, 1)
                        ])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        10.verticalSpace,
                        Text("Recommended Jobs",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
                        6.verticalSpace,
                        Text(
                            "See our recommended jobs for \nyou based on your rank",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: Colors.white))
                      ],
                    ),
                  ),
                  Positioned(
                    right: 32,
                    top: 0,
                    child: Image.asset(
                      "assets/images/dashboard/recommended_jobs.png",
                      height: 94,
                      width: 99
                    ),
                  )
                ],
              ),
            ),
            Row(
              children: [
                28.horizontalSpace,
                Text("Featured Companies",
                    style: Get.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600, fontSize: 18)),
                const Spacer(),
                TextButton(
                    onPressed: () {
                      Get.toNamed(Routes.COMPANIES);
                    },
                    child: Text("More",
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Get.theme.primaryColor))),
                28.horizontalSpace
              ],
            ),
            4.verticalSpace,
            ...controller.featuredCompanies.map(
              (company) => InkWell(
                onTap: () {
                  Get.toNamed(Routes.COMPANY_DETAIL,
                      arguments: CompanyDetailArguments(employer: company));
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            color: Color.fromRGBO(0, 0, 0, 0.1),
                            blurRadius: 8,
                            spreadRadius: 2)
                      ]),
                  child: Row(
                    children: [
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            color: Color(int.parse(
                                    "${company.companyName?.split("").firstOrNull?.codeUnitAt(0)}${company.id ?? 0}",
                                    radix: 16))
                                .withAlpha(0xff),
                            borderRadius: BorderRadius.circular(8)),
                        child: Center(
                            child: Text(
                                company.companyName?.split("").firstOrNull ??
                                    "",
                                style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white))),
                      ),
                      20.horizontalSpace,
                      Flexible(
                        child: Text(company.companyName ?? "",
                            maxLines: 2,
                            style: Get.textTheme.bodyMedium?.copyWith(
                                fontSize: 16, fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              ),
            ),
            16.verticalSpace
          ],
        )),
        // 65.verticalSpace
      ],
    );
  }
}

class BottomIcon {
  final Widget icon;
  final String text;

  const BottomIcon({required this.icon, required this.text});
}

List<BottomIcon> bottomIcons = [
  BottomIcon(
      icon: Image.asset(
        "assets/images/dashboard/home.png",
        height: 20,
        width: 20,
      ),
      text: "Home"),
  BottomIcon(
      icon: Image.asset(
        "assets/images/dashboard/discover.png",
        height: 20,
        width: 20,
      ),
      text: "Discover"),
  BottomIcon(
      icon: Icon(
        Icons.add,
        color: Get.theme.primaryColor,
      ),
      text: "Add"),
  BottomIcon(
      icon: Image.asset(
        "assets/images/dashboard/jobs.png",
        height: 20,
        width: 20,
      ),
      text: "Jobs"),
  BottomIcon(
      icon: Image.asset(
        "assets/images/dashboard/profile.png",
        height: 20,
        width: 20,
      ),
      text: "Profile"),
];

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 50);
    path.quadraticBezierTo(width / 2, height, width, height - 50);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
