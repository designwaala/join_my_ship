import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/highlight_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/highlight_provider.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class ProfileController extends GetxController with PickImage {
  RxBool isLoading = false.obs;
  Rxn<CrewUser> crewUser = Rxn();

  final parentKey = GlobalKey();
  FToast fToast = FToast();
  Rxn<File> pickedResume = Rxn();

  String get rank =>
      UserStates.instance.ranks
          ?.firstWhereOrNull(
              (rank) => rank.id == (crewUser.value?.rankId ?? -1))
          ?.name ??
      "";
  String? version = packageInfo?.version;
  String? buildNumber = packageInfo?.buildNumber;
  RxBool isHighlighting = false.obs;
  Highlight? highlight;

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  instantiate() async {
    isLoading.value = true;
    crewUser.value = UserStates.instance.crewUser ??
        (await getIt<CrewUserProvider>().getCrewUser());
    isLoading.value = false;
  }

  updateImage() async {
    if (crewUser.value?.id == null) {
      return;
    }
    await pickSource();
    if (pickedImage.value == null) {
      return;
    }
    bool? confirm = await confirmUpdate();
    if (confirm != true) {
      pickedImage.value = null;
      return;
    }
    isLoading.value = true;
    await getIt<CrewUserProvider>().updateCrewUser(
      crewId: crewUser.value!.id!,
      profilePicPath: pickedImage.value?.path,
    );
    crewUser.value = await getIt<CrewUserProvider>().getCrewUser();
    pickedImage.value = null;
    isLoading.value = false;
  }

  updateResume() async {
    if (crewUser.value?.id == null) {
      return;
    }
    bool? confirm = await showDialog<bool>(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure you want to update to this Resume?"),
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    Get.back(result: true);
                  },
                  child: Text("Yes")),
              8.horizontalSpace,
              OutlinedButton(
                  onPressed: () {
                    pickedImage.value = null;
                    Get.back(result: false);
                  },
                  child: Text("No")),
              8.horizontalSpace,
            ],
          );
        });

    if (confirm != true) {
      pickedResume.value = null;
      return;
    }
    isLoading.value = true;
    await getIt<CrewUserProvider>().updateCrewUser(
        crewId: crewUser.value!.id!, resumePath: pickedResume.value?.path);
    crewUser.value = await getIt<CrewUserProvider>().getCrewUser();
    pickedResume.value = null;
    isLoading.value = false;
  }

  Future<void> highlightCrew() async {
    await showDialog(
        context: Get.context!,
        builder: (context) {
          return Obx(() {
            return AlertDialog(
              title: Text("Choose the Plan"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [Card(child: Text("1 day"))],
              ),
              actions: [
                isHighlighting.value
                    ? CircularProgressIndicator()
                    : FilledButton(
                        onPressed: () async {
                          isHighlighting.value = true;
                          highlight =
                              await getIt<HighlightProvider>().crewHighlight(1);
                          isHighlighting.value = false;
                          Get.back();
                        },
                        child: Text("Highlight"))
              ],
            );
          });
        });
    if (highlight != null) {
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              title: Text("Your Profile was successfully Highlighted"),
              content: Text("Remaining Days ${highlight?.daysActive}."),
              actions: [FilledButton(onPressed: Get.back, child: Text("OK"))],
            );
          });
    }
  }
}
