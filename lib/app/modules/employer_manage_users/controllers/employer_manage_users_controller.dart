import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/secondary_users_model.dart';
import 'package:join_mp_ship/app/data/providers/secondary_users_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/widgets/custom_elevated_button.dart';

class EmployerManageUsersController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<SecondaryUsers> secondaryUsers = RxList.empty();
  RxnInt userBeingDeleted = RxnInt();
  RxBool isInvitingNewUser = false.obs;

  TextEditingController newUserEmail = TextEditingController();

  @override
  void onInit() {
    instantiate();
    super.onInit();
  }

  instantiate() async {
    isLoading.value = true;
    secondaryUsers.value =
        (await getIt<SecondaryUsersProvider>().getSecondaryUsers()) ?? [];
    isLoading.value = false;
  }

  deleteUser(int userId) async {
    userBeingDeleted.value = userId;
    await getIt<SecondaryUsersProvider>().deleteUser(userId);
    userBeingDeleted.value = null;
  }

  inviteNewUser() async {
    isInvitingNewUser.value = true;
    int? statusCode =
        await getIt<SecondaryUsersProvider>().inviteNewUser(newUserEmail.text);
    Get.back();
    if (statusCode == 200) {
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
    } else {}
    isInvitingNewUser.value = false;
  }
}
