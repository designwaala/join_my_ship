import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/state_provider.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/extensions/string_extensions.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/utils/shared_preferences.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

import '../../../data/models/country_model.dart';
import '../../../data/models/state_model.dart';

enum Step1FormMiss {
  didNotSelectProfilePic,
  didNotSelectCountry,
  didNotSelectState
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
  final Rxn<XFile> pickedImage = Rxn();
  final ImagePicker imagePicker = ImagePicker();
  RxnString uploadedImagePath = RxnString();
  RxnString uploadedResumePath = RxnString();
  RxList<StateModel> states = RxList.empty();

  final parentKey = GlobalKey();
  FToast fToast = FToast();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;

  CrewUser? crewUser;

  @override
  void onInit() {
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
    isLoading.value = false;
  }

  Future<bool> postEmployerUser() async {
    step1FormMisses.clear();
    if (pickedImage.value?.path == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectProfilePic);
    }
    if (country.value == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectCountry);
    }
    if (state.value == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectState);
    }

    if (formKey.currentState?.validate() != true) {
      return false;
    }

    if (pickedImage.value?.path == null ||
        country.value == null ||
        state.value == null) {
      return false;
    }
    if (formKey.currentState?.validate() != true) {
      return false;
    }
    isUpdating.value = true;
    int? statusCode;
    if (crewUser?.id == null) {
      statusCode = await getIt<CrewUserProvider>().createCrewUser(
          crewUser: CrewUser(
              firstName: firstNameController.text,
              lastName: lastNameController.text,
              designation: designationController.text,
              website: websiteController.text.nullIfEmpty(),
              country: country.value?.id,
              state: state.value?.id,
              addressCity: cityController.text,
              addressLine1: addressLine1Controller.text.nullIfEmpty(),
              addressLine2: addressLine2Controller.text.nullIfEmpty(),
              pincode: zipCodeController.text.nullIfEmpty(),
              password: "Demo@123",
              email: FirebaseAuth.instance.currentUser?.email,
              userTypeKey: 3,
              screenCheck: 1,
              gender: 3,
              username: companyNameController.text.nullIfEmpty(),
              authKey: await FirebaseAuth.instance.currentUser?.getIdToken()),
          profilePicPath: pickedImage.value?.path);
      if (statusCode < 300) {
        fToast.safeShowToast(
            child: successToast("Your account was successfully created."));
        Get.toNamed(Routes.HOME);
      } else {
        fToast.safeShowToast(child: errorToast("Error creating your account"));
      }
    } else {
      statusCode = await getIt<CrewUserProvider>().updateCrewUser(
          crewId: crewUser!.id!,
          crewUser: CrewUser(
              firstName: FirebaseAuth.instance.currentUser?.displayName,
              lastName: "_",
              password: "Demo@123",
              email: FirebaseAuth.instance.currentUser?.email,
              website: websiteController.text.nullIfEmpty(),
              addressLine1: addressLine1Controller.text,
              pincode: zipCodeController.text,
              country: country.value?.id,
              userTypeKey: 3,
              addressLine2: addressLine2Controller.text.nullIfEmpty(),
              addressCity: cityController.text,
              state: state.value?.id,
              screenCheck: 1,
              gender: 3,
              username: companyNameController.text.nullIfEmpty(),
              authKey: await FirebaseAuth.instance.currentUser?.getIdToken()),
          profilePicPath: pickedImage.value?.path);
      if ((statusCode ?? 0) < 300) {
        fToast.safeShowToast(
            child: successToast("Your account was successfully updated."));
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
