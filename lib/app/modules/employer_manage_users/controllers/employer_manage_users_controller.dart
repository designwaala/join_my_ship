import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/secondary_users_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/secondary_users_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/widgets/custom_elevated_button.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class EmployerManageUsersController extends GetxController {
  RxBool isLoading = false.obs;
  RxnInt userBeingDeleted = RxnInt();
  RxBool isInvitingNewUser = false.obs;
  RxList<CrewUser> subUsers = RxList.empty();

  TextEditingController newUserEmail = TextEditingController();

  FToast fToast = FToast();
  final parentKey = GlobalKey();

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  instantiate() async {
    isLoading.value = true;
    subUsers.value = await getIt<CrewUserProvider>().getSubUsers() ?? [];
    isLoading.value = false;
  }

  deleteUser(int userId) async {
    userBeingDeleted.value = userId;
    int? statusCode = await getIt<CrewUserProvider>().deleteSubUser(userId);
    if (statusCode == 204) {
      fToast.safeShowToast(child: successToast("User deleted successfully."));
      subUsers.removeWhere((e) => e.id == userId);
    }
    userBeingDeleted.value = null;
  }

  inviteNewUser() async {
    isInvitingNewUser.value = true;
    CrewUser? newUser =
        await getIt<CrewUserProvider>().createSubUser(newUserEmail.text);

    Get.back();
    if (newUser != null) {
      instantiate();
      showDialog(
          context: Get.context!,
          builder: (context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32)),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.check_circle,
                    color: Get.theme.primaryColor,
                    size: 64,
                  ),
                  16.verticalSpace,
                  Text("Invited Successfully",
                      style: Get.textTheme.bodyMedium?.copyWith(
                          color: Get.theme.primaryColor,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700)),
                  16.verticalSpace,
                  CustomElevatedButon(onPressed: Get.back, child: Text("OK"))
                ],
              ),
            );
          });
    } else {
      Get.showSnackbar(GetSnackBar(message: "Something went wrong"));
    }
    isInvitingNewUser.value = false;
  }
}
