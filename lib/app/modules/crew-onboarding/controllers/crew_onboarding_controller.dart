import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide State;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/previous_employer_reference_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/service_record_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/service_record_provider.dart';
import 'package:join_mp_ship/app/data/providers/state_provider.dart';
import 'package:join_mp_ship/app/data/providers/user_details_provider.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/secure_storage.dart';
import 'package:join_mp_ship/app/data/models/state_model.dart';

Map<String, int> maritalStatuses = {"Single": 1, "Married": 2, "Divorced": 3};

enum Step1FormMiss {
  didNotSelectProfilePic,
  didNotChooseCurrentRank,
  didNotSelectMaritalStatus,
  didNotSelectResume,
  didNotSelectCountry,
  didNotSelectState
}

enum Step2FormMiss {
  stcwIssuingAuthority,
  cocIssuingAuthority,
  copIssuingAuthority,
  watchKeepingIssuingAuthority,
}

class CrewOnboardingController extends GetxController {
  CrewUser? crewUser;
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  FToast fToast = FToast();
  final parentKey = GlobalKey();

  Rxn<Rank> selectedRank = Rxn();
  Rxn<String> promotionRank = Rxn();
  Rx<Gender> gender = Gender.male.obs;
  Rxn<StateModel> state = Rxn();
  Rxn<Country> country = Rxn();
  RxBool isLookingForPromotion = false.obs;
  //______________STEP 2__________________
  RxList<String> stcwIssuingAuthority = RxList.empty();
  RxnBool isHoldingValidCOC = RxnBool(false);
  RxnBool isHoldingValidCOP = RxnBool(false);
  RxnBool isHoldingWatchKeeping = RxnBool(false);
  RxnBool isHoldingValidUSVisa = RxnBool(false);
  //______________________________________
  RxBool declaration1 = false.obs;
  RxBool declaration2 = false.obs;
  RxList<String> cocIssuingAuthority = RxList.empty();
  RxList<String> copIssuingAuthority = RxList.empty();
  RxList<String> watchKeepingIssuingAuthority = RxList.empty();

  final Rxn<XFile> pickedImage = Rxn();

  ///_________Step 1_____________
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  //__________________________

  //__________Step 2_________________
  TextEditingController zipCode = TextEditingController();
  TextEditingController indosNumber = TextEditingController();
  //
  TextEditingController cdcNumber = TextEditingController();
  TextEditingController cdcNumberValidTill = TextEditingController();
  //
  TextEditingController cdcSeamanNumber = TextEditingController();
  TextEditingController cdcSeamanNumberValidTill = TextEditingController();
  //
  TextEditingController passportNumber = TextEditingController();
  TextEditingController passportValidTill = TextEditingController();
  //
  TextEditingController stcwDetailValidTill = TextEditingController();
  TextEditingController cocValidTill = TextEditingController();
  TextEditingController copValidTill = TextEditingController();
  TextEditingController watchKeepingValidTill = TextEditingController();
  TextEditingController usVisaValidTill = TextEditingController();
  //__________________________

  final ImagePicker imagePicker = ImagePicker();

  //Add a record bottom sheet
  TextEditingController recordCompanyName = TextEditingController();
  TextEditingController recordShipName = TextEditingController();
  TextEditingController recordIMONumber = TextEditingController();
  Rxn<Rank> recordRank = Rxn<Rank>();
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

  RxList<Step1FormMiss> step1FormMisses = RxList.empty();
  RxList<Step2FormMiss> step2FormMisses = RxList.empty();

  GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();

  List<Country> countries = [];
  RxList<StateModel> states = RxList.empty();

  RxList<ServiceRecord> serviceRecords = RxList.empty();
  RxList<PreviousEmployerReference> previousEmployerReferences = RxList.empty();

  RxBool isAddingBottomSheet = false.obs;

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
    countries = (await getIt<CountryProvider>().getCountry()) ?? [];
    crewUser = await getIt<CrewUserProvider>().getCrewUser();
    if (crewUser == null) {
      step.value = 1;
    } else {
      step.value = 2;
    }
    isLoading.value = false;
  }

  getStates() async {
    states.value = (await getIt<StateProvider>().getStates(countryId: 1)) ?? [];
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

  Future<bool> postStep1() async {
    step1FormMisses.clear();
    if (pickedImage.value?.path == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectProfilePic);
    }
    if (pickedResume.value?.path == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectResume);
    }
    if (selectedRank.value?.rankPriority == null) {
      step1FormMisses.add(Step1FormMiss.didNotChooseCurrentRank);
    }
    if (maritalStatus.value == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectMaritalStatus);
    }
    if (country.value == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectCountry);
    }
    if (state.value == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectState);
    }

    if (formKeyStep1.currentState?.validate() != true) {
      return false;
    }

    if (pickedImage.value?.path == null ||
        pickedResume.value?.path == null ||
        selectedRank.value?.rankPriority == null ||
        maritalStatus.value == null ||
        country.value == null ||
        state.value == null) {
      return false;
    }
    isUpdating.value = true;
    String password = await SecureStorage.instance.password;
    int statusCode = await getIt<CrewUserProvider>().createCrewUser(
        crewUser: CrewUser(
            firstName: FirebaseAuth.instance.currentUser?.displayName,
            lastName: "_",
            password: password,
            email: FirebaseAuth.instance.currentUser?.email,
            addressLine1: addressLine1.text,
            pincode: zipCode.text,
            dob: dateOfBirth.text,
            maritalStatus: maritalStatus.value,
            country: 1,
            rankId: selectedRank.value?.rankPriority,
            userTypeKey: 2,
            addressLine2: addressLine2.text,
            addressCity: city.text,
            state: 1,
            authKey: await FirebaseAuth.instance.currentUser?.getIdToken()),
        profilePicPath: pickedImage.value?.path,
        resumePath: pickedResume.value?.path);
    isUpdating.value = false;
    return statusCode == 201;
  }

  Future<bool> postStep2() async {
    if (stcwIssuingAuthority.isEmpty) {
      step2FormMisses.add(Step2FormMiss.stcwIssuingAuthority);
    }
    if (![
          "Deck Cadet",
          "Trainee Electrical Cadet",
          "Engine Cadet",
          "Trainee Ordinary Seaman",
          "Trainee Wiper"
        ].contains(selectedRank.value?.name) &&
        isHoldingValidCOC.value == true &&
        cocIssuingAuthority.isEmpty) {
      step2FormMisses.add(Step2FormMiss.cocIssuingAuthority);
    }
    if (isHoldingValidCOC.value != true &&
        ![
          "Mess boy / GS / Steward",
          "Second Cook / 2nd Cook",
          "Chief Cook",
          "Trainee Electrical Cadet",
          "ETO / Electrician",
        ].contains(selectedRank.value?.name) &&
        isHoldingValidCOP.value == true &&
        copIssuingAuthority.isEmpty) {
      step2FormMisses.add(Step2FormMiss.copIssuingAuthority);
    }
    if (isHoldingValidCOC.value != true &&
        ![
          "Mess boy / GS / Steward",
          "Second Cook / 2nd Cook",
          "Chief Cook",
          "Trainee Electrical Cadet",
          "ETO / Electrician",
        ].contains(selectedRank.value?.name) &&
        isHoldingWatchKeeping.value == true &&
        watchKeepingIssuingAuthority.isEmpty) {
      step2FormMisses.add(Step2FormMiss.watchKeepingIssuingAuthority);
    }
    if (formKeyStep2.currentState?.validate() != true) {
      return false;
    }
    if (step2FormMisses.isNotEmpty) {
      return false;
    }
    isUpdating.value = true;
    await getIt<UserDetailsProvider>().postUserDetails(UserDetails(
        iNDOSNumber: indosNumber.text,
        cDCNumber: cdcNumber.text,
        cDCNumberValidTill: cdcNumberValidTill.text,
        passportNumber: passportNumber.text,
        passportNumberValidTill: passportValidTill.text,
        sTCWIssuingAuthority: "",
        sTCWIssuingAuthorityValidTill: stcwDetailValidTill.text,
        validCOCIssuingAuthority: "",
        validCOCIssuingAuthorityValidTill: cocValidTill.text,
        validCOPIssuingAuthority: "",
        validCOPIssuingAuthorityValidTill: copValidTill.text,
        validWatchKeepingIssuingAuthority: "",
        validWatchKeepingIssuingAuthorityValidTill: watchKeepingValidTill.text,
        validUSVisaValidTill: usVisaValidTill.text));
    isUpdating.value = false;
    return true;
  }

  Future<bool> addServiceRecord() async {
    isAddingBottomSheet.value = true;
    ServiceRecord? newRecord = await getIt<ServiceRecordProvider>()
        .postServiceRecord(ServiceRecord(
            companyName: recordCompanyName.text,
            shipName: recordShipName.text,
            iMONumber: recordIMONumber.text,
            rankId: recordRank.value?.rankPriority,
            flag: recordFlagName.text,
            gRT: recordGrt.text,
            vesselType: 1,
            signonDate: recordSignOnDate.text,
            signoffDate: recordSignOffDate.text,
            contractDuration: int.tryParse(recordContarctDuration.text)));

    isAddingBottomSheet.value = false;
    if (newRecord != null) {
      serviceRecords.add(newRecord);
      return true;
    } else {
      return false;
    }
  }
}

class CrewOnboardingArguments {
  final String email;
  final String password;

  const CrewOnboardingArguments({required this.email, required this.password});
}

enum Gender { male, female }
