import 'package:collection/collection.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join_my_ship/app/data/models/crew_user_model.dart';
import 'package:join_my_ship/app/data/providers/country_provider.dart';
import 'package:join_my_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_my_ship/app/data/providers/fcm_token_provider.dart';
import 'package:join_my_ship/app/data/providers/state_provider.dart';
import 'package:join_my_ship/app/data/providers/user_details_provider.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/extensions/string_extensions.dart';
import 'package:join_my_ship/utils/extensions/toast_extension.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/widgets/toasts/toast.dart';

import '../../../data/models/country_model.dart';
import '../../../data/models/state_model.dart';

enum Step1FormMiss {
  didNotSelectProfilePic,
  didNotSelectCountry,
  didNotSelectState,
  didNotSelectGender
}

class EmployerCreateUserController extends GetxController {
  RxList<Step1FormMiss> step1FormMisses = RxList.empty();
  RxBool isLoadingStates = false.obs;

  Rxn<StateModel> state = Rxn();
  Rxn<Country> country = Rxn();
  List<Country> countries = [];
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final Rxn<XFile> pickedImage = Rxn();
  final ImagePicker imagePicker = ImagePicker();
  RxnString uploadedImagePath = RxnString();
  RxList<StateModel> states = RxList.empty();
  RxnInt gender = RxnInt();

  final parentKey = GlobalKey();
  FToast fToast = FToast();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  CrewUser? crewUser;

  bool editMode = false;

  RxString selectedCountryCode = "+91".obs;

  @override
  void onInit() {
    if (Get.arguments is EmployerCreateUserArguments?) {
      EmployerCreateUserArguments? args = Get.arguments;
      editMode = args?.editMode ?? false;
    }
    instantiate();
    super.onInit();
  }

  @override
  onReady() {
    super.onReady();
    websiteController.text = PreferencesHelper.instance.website ?? "";
    companyNameController.text = PreferencesHelper.instance.companyName ?? "";
    fToast.init(parentKey.currentContext!);
  }

  getStates() async {
    isLoadingStates.value = true;
    if (country.value?.id == null) {
      isLoadingStates.value = false;
      return;
    }
    state.value = null;
    states.value = (await getIt<StateProvider>()
            .getStates(countryId: country.value!.id!)) ??
        [];
    states.add(
        StateModel(id: 58, country: 00, stateCode: "00", stateName: "Others"));
    isLoadingStates.value = false;
  }

  instantiate() async {
    isLoading.value = true;
    countries = (await getIt<CountryProvider>().getCountry()) ?? [];
    Country? india =
        countries.firstWhereOrNull((country) => country.countryCode == "IN");
    countries.removeWhere((country) => country.id == india?.id);
    if (india != null) {
      countries.insert(0, india);
    }
    if (PreferencesHelper.instance.userLink != null &&
        UserStates.instance.crewUser?.addressLine1 == null) {
      await getIt<CrewUserProvider>()
          .fetchSubUserDetails(PreferencesHelper.instance.userLink!);
    }
    if (editMode ||
        (UserStates.instance.crewUser != null &&
            UserStates.instance.crewUser?.addressLine1 == null)) {
      crewUser = UserStates.instance.crewUser ??
          await getIt<CrewUserProvider>().getCrewUser();
      UserStates.instance.crewUser = crewUser;
      // if (crewUser?.id != null) {
      //   if (crewUser?.isVerified == 1) {
      //     Get.offAllNamed(Routes.HOME);
      //   } else {
      //     Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
      //   }
      // }

      firstNameController.text = crewUser?.firstName ?? "";
      lastNameController.text = crewUser?.lastName ?? "";
      designationController.text = crewUser?.designation ?? "";
      cityController.text = crewUser?.addressCity ?? "";
      addressLine1Controller.text = crewUser?.addressLine1 ?? "";
      addressLine2Controller.text = crewUser?.addressLine2 ?? "";
      zipCodeController.text = crewUser?.pincode ?? "";
      companyNameController.text = crewUser?.companyName ?? "";
      websiteController.text = crewUser?.website ?? "";
      gender.value = crewUser?.gender;
      emailController.text = FirebaseAuth.instance.currentUser?.email ?? "";

      uploadedImagePath.value = crewUser?.profilePic;
      country.value =
          countries.firstWhereOrNull((e) => e.id == crewUser?.countryId);
      await getStates();
      state.value = states.firstWhereOrNull((e) => e.id == crewUser?.state);

      phoneNumberController.text =
          FirebaseAuth.instance.currentUser?.phoneNumber ?? "";
      /* selectedCountryCode.value =
          crewUser?.number?.split("-").firstOrNull ?? ""; */
    }
    isLoading.value = false;
  }

  Future<bool> postEmployerUser() async {
    step1FormMisses.clear();
    if (pickedImage.value?.path == null && uploadedImagePath.value == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectProfilePic);
    }
    if (country.value == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectCountry);
    }
    if (state.value == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectState);
    }
    if (gender.value == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectGender);
    }

    if (formKey.currentState?.validate() != true) {
      return false;
    }

    if ((crewUser?.id == null &&
            (pickedImage.value?.path == null &&
                uploadedImagePath.value == null)) ||
        country.value == null ||
        state.value == null ||
        gender.value == null) {
      return false;
    }
    if (formKey.currentState?.validate() != true) {
      return false;
    }
    isUpdating.value = true;
    int? statusCode;
    await FirebaseAuth.instance.currentUser
        ?.updateDisplayName(firstNameController.text);
    fToast.init(parentKey.currentContext!);
    if (crewUser?.id == null) {
      statusCode = await getIt<CrewUserProvider>().createCrewUser(
          crewUser: CrewUser(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              designation: designationController.text,
              website: websiteController.text.nullIfEmpty(),
              countryId: country.value?.id,
              state: state.value?.id,
              addressCity: cityController.text,
              addressLine1: addressLine1Controller.text.nullIfEmpty(),
              addressLine2: addressLine2Controller.text.nullIfEmpty(),
              pincode: zipCodeController.text.nullIfEmpty(),
              password: "Demo@123",
              email: FirebaseAuth.instance.currentUser?.email,
              number:
                  FirebaseAuth.instance.currentUser?.phoneNumber?.nullIfEmpty(),
              userTypeKey: UserStates.instance.employerType?.backendIndex,
              screenCheck: 1,
              gender: gender.value,
              companyName: companyNameController.text.nullIfEmpty(),
              authKey: await FirebaseAuth.instance.currentUser?.getIdToken()),
          profilePicPath: pickedImage.value?.path);
      if (statusCode < 300) {
        fToast.safeShowToast(
            child: successToast("Your account was successfully created."));
        try {
          String? fcmToken = await FirebaseMessaging.instance.getToken();
          if (fcmToken?.nullIfEmpty() != null) {
            await getIt<CrewUserProvider>().getCrewUser();
            PreferencesHelper.instance.setFCMToken(fcmToken!);
            await getIt<FcmTokenProvider>().postFCMToken(fcmToken);
          }
        } catch (e) {}
        Get.toNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
      } else {
        fToast.safeShowToast(child: errorToast("Error creating your account"));
      }
    } else {
      statusCode = await getIt<CrewUserProvider>().updateCrewUser(
          crewId: crewUser!.id!,
          crewUser: CrewUser(
              userTypeKey:
                  PreferencesHelper.instance.employerType?.backendIndex,
              firstName: FirebaseAuth.instance.currentUser?.displayName,
              lastName: lastNameController.text,
              email: FirebaseAuth.instance.currentUser?.email,
              designation: designationController.text,
              website: websiteController.text.nullIfEmpty(),
              addressLine1: addressLine1Controller.text,
              pincode: zipCodeController.text,
              countryId: country.value?.id,
              addressLine2: addressLine2Controller.text.nullIfEmpty(),
              addressCity: cityController.text,
              state: state.value?.id,
              screenCheck: 1,
              gender: gender.value,
              companyName: companyNameController.text.nullIfEmpty(),
              authKey: await FirebaseAuth.instance.currentUser?.getIdToken()),
          profilePicPath: pickedImage.value?.path);
      if ((statusCode ?? 0) < 300) {
        PreferencesHelper.instance.clearUserLink();
        UserStates.instance.userLink = null;
        fToast.safeShowToast(
            child: successToast("Your account was successfully updated."));
        if ((crewUser != null && crewUser?.addressLine1 == null)) {
          Get.toNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
        }
      } else {
        fToast.safeShowToast(child: errorToast("Error updating your account"));
      }
    }
    isUpdating.value = false;

    return (statusCode ?? 0) < 300;
  }

  Future<void> pickSource() async {
    return showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
              shape: alertDialogShape,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pick Image from"),
                  IconButton(onPressed: Get.back, icon: Icon(Icons.close))
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: EdgeInsets.symmetric(vertical: 16),
              titlePadding: EdgeInsets.only(left: 16, right: 16, top: 16),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      pickedImage.value = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      Get.back();
                    },
                    child: Text("Gallery")),
                // Spacer(),
                ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      pickedImage.value = await imagePicker.pickImage(
                          source: ImageSource.camera);
                    },
                    child: Text("Image"))
              ],
            ));
  }

  @override
  void onClose() {
    super.onClose();
  }
}

class EmployerCreateUserArguments {
  final bool? editMode;
  const EmployerCreateUserArguments({this.editMode});
}
