import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/country_model.dart';
import '../../../data/models/state_model.dart';

enum Step1FormMiss {
  didNotSelectProfilePic,
  didNotChooseCurrentRank,
  didNotSelectMaritalStatus,
  didNotSelectResume,
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
  final Rxn<XFile> pickedImage = Rxn();
  final ImagePicker imagePicker = ImagePicker();
  RxnString uploadedImagePath = RxnString();
  RxnString uploadedResumePath = RxnString();
  RxList<StateModel> states = RxList.empty();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }
  // Future<bool> postEmployerUser() async {
  //   step1FormMisses.clear();
  //   if (pickedImage.value?.path == null && ?.profilePic == null) {
  //     step1FormMisses.add(Step1FormMiss.didNotSelectProfilePic);
  //   }
  //   if (pickedResume.value?.path == null && crewUser?.resume == null) {
  //     step1FormMisses.add(Step1FormMiss.didNotSelectResume);
  //   }
  //   if (selectedRank.value?.id == null) {
  //     step1FormMisses.add(Step1FormMiss.didNotChooseCurrentRank);
  //   }
  //   if (maritalStatus.value == null) {
  //     step1FormMisses.add(Step1FormMiss.didNotSelectMaritalStatus);
  //   }
  //   if (country.value == null) {
  //     step1FormMisses.add(Step1FormMiss.didNotSelectCountry);
  //   }
  //   if (state.value == null) {
  //     step1FormMisses.add(Step1FormMiss.didNotSelectState);
  //   }

  //   if (formKeyStep1.currentState?.validate() != true) {
  //     return false;
  //   }

  //   if ((pickedImage.value?.path == null && crewUser?.profilePic == null) ||
  //       (pickedResume.value?.path == null && crewUser?.resume == null) ||
  //       selectedRank.value?.id == null ||
  //       maritalStatus.value == null ||
  //       country.value == null ||
  //       state.value == null) {
  //     return false;
  //   }
  //   isUpdating.value = true;
  //   String password = await SecureStorage.instance.password;
  //   int? statusCode;
  //   if (crewUser?.id == null) {
  //     statusCode = await getIt<CrewUserProvider>().createCrewUser(
  //         crewUser: CrewUser(
  //             firstName: FirebaseAuth.instance.currentUser?.displayName,
  //             lastName: "_",
  //             password: "Demo@123",
  //             email: FirebaseAuth.instance.currentUser?.email,
  //             addressLine1: addressLine1.text,
  //             pincode: zipCode.text,
  //             dob: dateOfBirth.text,
  //             maritalStatus: maritalStatus.value,
  //             country: country.value?.id,
  //             rankId: selectedRank.value?.id,
  //             gender: gender.value,
  //             userTypeKey: 2,
  //             addressLine2: addressLine2.text.nullIfEmpty(),
  //             addressCity: city.text,
  //             state: state.value?.id,
  //             promotionApplied: isLookingForPromotion.value,
  //             screenCheck: 1,
  //             authKey: await FirebaseAuth.instance.currentUser?.getIdToken()),
  //         profilePicPath: pickedImage.value?.path,
  //         resumePath: pickedResume.value?.path);
  //     if (statusCode < 300) {
  //       fToast.safeShowToast(
  //           child: successToast("Your account was successfully created."));
  //     } else {
  //       fToast.safeShowToast(child: errorToast("Error creating your account"));
  //     }
  //   } else {
  //     statusCode = await getIt<CrewUserProvider>().updateCrewUser(
  //         crewId: crewUser!.id!,
  //         crewUser: CrewUser(
  //             firstName: FirebaseAuth.instance.currentUser?.displayName,
  //             lastName: "_",
  //             email: FirebaseAuth.instance.currentUser?.email,
  //             addressLine1: addressLine1.text,
  //             pincode: zipCode.text,
  //             dob: dateOfBirth.text,
  //             maritalStatus: maritalStatus.value,
  //             country: country.value?.id,
  //             rankId: selectedRank.value?.id,
  //             gender: gender.value,
  //             userTypeKey: 2,
  //             addressLine2: addressLine2.text,
  //             addressCity: city.text,
  //             state: state.value?.id,
  //             promotionApplied: isLookingForPromotion.value,
  //             screenCheck: 1,
  //             authKey: await FirebaseAuth.instance.currentUser?.getIdToken()),
  //         profilePicPath: pickedImage.value?.path,
  //         resumePath: pickedResume.value?.path);
  //     if ((statusCode ?? 0) < 300) {
  //       fToast.safeShowToast(
  //           child: successToast("Your account was successfully updated."));
  //     } else {
  //       fToast.safeShowToast(child: errorToast("Error updating your account"));
  //     }
  //   }
  //   isUpdating.value = false;

  //   return (statusCode ?? 0) < 300;
  // }

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
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
