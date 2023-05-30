import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/secure_storage.dart';

Map<String, int> maritalStatuses = {"Single": 1, "Married": 2, "Divorced": 3};

class CrewOnboardingController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  FToast fToast = FToast();
  final parentKey = GlobalKey();

  Rxn<Rank> selectedRank = Rxn();
  Rxn<String> promotionRank = Rxn();
  Rxn<Gender> gender = Rxn();
  RxnString state = RxnString();
  RxnString country = RxnString();
  RxBool isLookingForPromotion = false.obs;
  RxList<String> stcwIssuingAuthority = RxList.empty();
  RxnBool isHoldingValidCOC = RxnBool();
  RxnBool isHoldingValidCOP = RxnBool();
  RxnBool isHoldingWatchKeeping = RxnBool();
  RxnBool isHoldingValidUSVisa = RxnBool();
  RxBool declaration1 = false.obs;
  RxBool declaration2 = false.obs;
  RxList<String> cocIssuingAuthority = RxList.empty();
  RxList<String> copIssuingAuthority = RxList.empty();
  RxList<String> watchKeepingIssuingAuthority = RxList.empty();

  final Rxn<XFile> pickedImage = Rxn();

  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();

  TextEditingController zipCode = TextEditingController();
  TextEditingController indosNumber = TextEditingController();
  TextEditingController cdcNumber = TextEditingController();
  TextEditingController cdcNumberValidTill = TextEditingController();
  TextEditingController passportValidTill = TextEditingController();
  TextEditingController stcwDetailValidTill = TextEditingController();
  TextEditingController cocValidTill = TextEditingController();
  TextEditingController copValidTill = TextEditingController();
  TextEditingController watchKeepingValidTill = TextEditingController();
  TextEditingController usVisaValidTill = TextEditingController();

  final ImagePicker imagePicker = ImagePicker();

  //Add a record bottom sheet
  TextEditingController recordCompanyName = TextEditingController();
  TextEditingController recordShipName = TextEditingController();
  TextEditingController recordIMONumber = TextEditingController();
  RxnString recordRank = RxnString();
  TextEditingController recordFlagName = TextEditingController();
  TextEditingController recordGrt = TextEditingController();
  RxnString recordVesselType = RxnString();
  TextEditingController recordSignOnDate = TextEditingController();
  TextEditingController recordSignOffDate = TextEditingController();
  TextEditingController recordContarctDuration = TextEditingController();

  //Add a reference bottom sheet
  TextEditingController referenceCompanyName = TextEditingController();
  TextEditingController referenceReferenceName = TextEditingController();
  TextEditingController referenceContactNumber = TextEditingController();

  Rxn<File> pickedResume = Rxn();

/*   List<String> ranks = [
    "Master/Captain",
    "Cheif Officer",
    "Second Officer / 2nd Officer",
    "Third Officer / 3rd Officer",
    "Bosun",
    "Pumpman",
    "Deck Fitter",
    "AB / Able Bodied Seaman",
    "OS / Ordinary Seaman",
    "Trainee Ordinary Seaman",
    "Deck Cadet",
    "Chief Engineer",
    "Second Engineer / 2nd Engineer",
    "Third Engineer / 3rd Engineer",
    "Fourth Engineer / 4th Engineer",
    "ETO / Electrician",
    "Trainee Electrical Cadet",
    "Motorman",
    "Engine Fitter",
    "Oiler",
    "Wiper",
    "Trainee Wiper",
    "Engine Cadet",
    "Chief Cook",
    "Second Cook / 2nd Cook",
    "Mess boy / GS / Steward",
  ]; */

  List<Rank>? ranks;

  RxInt step = 1.obs;

  String? email, password;

  RxnInt maritalStatus = RxnInt();

  @override
  void onInit() {
    CrewOnboardingArguments? args =
        (Get.arguments is CrewOnboardingArguments?) ? Get.arguments : null;
    email = args?.email;
    password = args?.password;
    instantiate();
    super.onInit();
  }

  instantiate() async {
    isLoading.value = true;
    ranks = await getIt<RanksProvider>().getRankList();
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  pickSource() async {
    showDialog(
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
                      Get.back();
                      pickedImage.value = await imagePicker.pickImage(
                          source: ImageSource.gallery);
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

  postStep1() async {
    isUpdating.value = true;
    String password = await SecureStorage.instance.password;
    await getIt<CrewUserProvider>().createCrewUser(
        crewUser: CrewUser(
            firstName: FirebaseAuth.instance.currentUser?.displayName,
            lastName: "",
            password: password,
            email: email,
            profilePic: MultipartFile(File(pickedImage.value?.path ?? ""),
                filename:
                    "profile_pic_${FirebaseAuth.instance.currentUser?.displayName ?? ""}"),
            resume: MultipartFile(File(pickedResume.value?.path ?? ""),
                filename:
                    "profile_pic_${FirebaseAuth.instance.currentUser?.displayName ?? ""}"),
            addressLine1: addressLine1.text,
            pincode: zipCode.text,
            dob: dateOfBirth.text,
            maritalStatus: maritalStatus.value,
            country: 1,
            rankId: selectedRank.value?.rankPriority,
            userTypeKey: 2,
            addressLine2: addressLine2.text,
            addressCity: city.text,
            state: 1));
    isUpdating.value = false;
  }
}

class CrewOnboardingArguments {
  final String email;
  final String password;

  const CrewOnboardingArguments({required this.email, required this.password});
}

enum Gender { male, female }
