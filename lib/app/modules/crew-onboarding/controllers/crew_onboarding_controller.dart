import 'dart:developer';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart' hide State;
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/previous_employer_model.dart';
import 'package:join_mp_ship/app/data/models/previous_employer_reference_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/sea_service_model.dart';
import 'package:join_mp_ship/app/data/models/service_record_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_list_model.dart';
import 'package:join_mp_ship/app/data/models/vessel_type_model.dart';
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/crew_user_provider.dart';
import 'package:join_mp_ship/app/data/providers/previous_employer_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/data/providers/sea_service_provider.dart';
import 'package:join_mp_ship/app/data/providers/service_record_provider.dart';
import 'package:join_mp_ship/app/data/providers/state_provider.dart';
import 'package:join_mp_ship/app/data/providers/user_details_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_list_provider.dart';
import 'package:join_mp_ship/app/data/providers/vessel_type_provider.dart';
import 'package:join_mp_ship/app/routes/app_pages.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/extensions/string_extensions.dart';
import 'package:join_mp_ship/utils/secure_storage.dart';
import 'package:join_mp_ship/app/data/models/state_model.dart';
import 'package:join_mp_ship/utils/user_details.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:time_machine/time_machine.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';

Map<int, String> maritalStatuses = {1: "Single", 2: "Married", 3: "Divorced"};
Map<String, int> reverseMaritalStatuses = {
  "Single": 1,
  "Married": 2,
  "Divorced": 3
};

Map<int, String> genderMap = {1: "Male", 2: "Female", 3: "Others"};
Map<String, int> reversedGenderMap = {"Male": 1, "Female": 2, "Others": 3};

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

enum Step3FormMiss {
  lessThan2SeaServiceRecords,
  referenceFromPreviousEmployerNotProvided,
  didNotAgreeToTermsAndCondition
}

TextStyle? get headingStyle =>
    Get.textTheme.titleSmall?.copyWith(color: Get.theme.primaryColor);

class CrewOnboardingController extends GetxController with PickImage {
  bool editMode = false;
  CrewUser? crewUser;
  UserDetails? userDetails;
  RxBool isLoading = false.obs;
  RxBool isUpdating = false.obs;
  FToast fToast = FToast();
  final parentKey = GlobalKey();

  Rxn<Rank> selectedRank = Rxn();
  Rxn<String> promotionRank = Rxn();
  RxnInt gender = RxnInt(1);
  Rxn<StateModel> state = Rxn();
  Rxn<Country> country = Rxn();
  RxBool isLookingForPromotion = false.obs;
  RxnString uploadedImagePath = RxnString();
  RxnString uploadedResumePath = RxnString();
  RxString selectedCountryCode = "+91".obs;
  //______________STEP 2__________________
  // RxList<String> stcwIssuingAuthority = RxList.empty();
  RxnBool isHoldingValidCOC = RxnBool(false);
  RxnBool isHoldingValidCOP = RxnBool(false);
  RxnBool isHoldingWatchKeeping = RxnBool(false);
  RxnBool isHoldingValidUSVisa = RxnBool(false);
  //______________________________________
  RxBool declaration1 = false.obs;
  RxBool declaration2 = false.obs;
  // RxList<String> cocIssuingAuthority = RxList.empty();
  // RxList<String> copIssuingAuthority = RxList.empty();
  // RxList<String> watchKeepingIssuingAuthority = RxList.empty();

  ///_________Step 1_____________
  TextEditingController addressLine1 = TextEditingController();
  TextEditingController addressLine2 = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();
  TextEditingController phoneNumber = TextEditingController();
  //__________________________

  //__________Step 2_________________
  TextEditingController zipCode = TextEditingController();
  TextEditingController indosNumber = TextEditingController();
  //
/*   TextEditingController cdcNumber = TextEditingController();
  TextEditingController cdcNumberValidTill = TextEditingController(); */
  //
  TextEditingController cdcSeamanNumber = TextEditingController();
  TextEditingController cdcSeamanNumberValidTill = TextEditingController();
  //
  TextEditingController passportNumber = TextEditingController();
  TextEditingController passportValidTill = TextEditingController();
  //
  TextEditingController usVisaValidTill = TextEditingController();
  TextEditingController stcwOther = TextEditingController();
  //__________________________

  //Add a record bottom sheet
  TextEditingController recordCompanyName = TextEditingController();
  TextEditingController recordShipName = TextEditingController();
  TextEditingController recordIMONumber = TextEditingController();
  Rxn<Rank> recordRank = Rxn<Rank>();
  TextEditingController recordFlagName = TextEditingController();
  TextEditingController recordGrt = TextEditingController();
  RxnInt recordVesselType = RxnInt();
  TextEditingController recordSignOnDate = TextEditingController();
  TextEditingController recordSignOffDate = TextEditingController();
  // TextEditingController recordContarctDuration = TextEditingController();
  SeaServiceRecord? selectedSeaServiceRecord;
  PreviousEmployerReference? selectedPreviousReference;
  RxnString recordContractDuration = RxnString();

  //Add a reference bottom sheet
  TextEditingController referenceCompanyName = TextEditingController();
  TextEditingController referenceReferenceName = TextEditingController();
  TextEditingController referenceContactNumber = TextEditingController();
  TextEditingController referenceDialCode = TextEditingController(text: "+91");

  Rxn<File> pickedResume = Rxn();

  RxList<Step1FormMiss> step1FormMisses = RxList.empty();
  RxList<Step2FormMiss> step2FormMisses = RxList.empty();
  RxList<Step3FormMiss> step3FormMisses = RxList.empty();

  GlobalKey<FormState> formKeyStep1 = GlobalKey<FormState>();
  GlobalKey<FormState> formKeyStep2 = GlobalKey<FormState>();

  List<Country> countries = [];
  RxList<StateModel> states = RxList.empty();

  RxList<SeaServiceRecord> serviceRecords = RxList.empty();
  RxList<PreviousEmployerReference> previousEmployerReferences = RxList.empty();

  RxBool isAddingBottomSheet = false.obs;

  RxList<IssuingAuthority> stcwIssuingAuthorities = RxList.empty();
  RxList<IssuingAuthority> cocIssuingAuthorities = RxList.empty();
  RxList<IssuingAuthority> copIssuingAuthorities = RxList.empty();
  RxList<IssuingAuthority> watchKeepingIssuingAuthorities = RxList.empty();

  int? userId;

  // List<VesselType> vesselTypes = [];
  VesselList? vesselList;
  RxBool isPreparingRecordBottomSheet = false.obs;
  RxBool isLoadingStates = false.obs;

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

  RxInt serviceRecordDeletingId = (-1).obs;
  RxInt previousEmployerReferenceDeletingId = (-1).obs;

  @override
  void onInit() {
    CrewOnboardingArguments? args =
        (Get.arguments is CrewOnboardingArguments?) ? Get.arguments : null;
    email = args?.email;
    password = args?.password;
    editMode = args?.editMode ?? false;
    instantiate();
    super.onInit();
  }

  Future<void> getAndSetCurrentScreen() async {
    isLoading.value = true;
    if (step.value == 1 && crewUser == null) {
      crewUser = await getIt<CrewUserProvider>().getCrewUser(softRefresh: true);
      UserStates.instance.crewUser = crewUser;
      if (crewUser?.id != null) {
        await setStep1Fields();
      }
    } else if (step.value == 2 && userDetails == null) {
      userDetails =
          await getIt<UserDetailsProvider>().getUserDetails(crewUser!.id!);
      UserStates.instance.userDetails = userDetails;
      await setStep2Fields();
    } else if (step.value == 3 &&
        (serviceRecords.isEmpty || previousEmployerReferences.isEmpty)) {
      serviceRecords.value =
          (await getIt<SeaServiceProvider>().getSeaServices(crewUser!.id!)) ??
              [];
      UserStates.instance.serviceRecords = serviceRecords;
      previousEmployerReferences.value =
          (await getIt<PreviousEmployerProvider>()
                  .getPreviousEmployer(crewUser!.id!)) ??
              [];
      UserStates.instance.previousEmployerReferences =
          previousEmployerReferences;
    }
    isLoading.value = false;
  }

  instantiate() async {
    isLoading.value = true;
    ranks = await getIt<RanksProvider>().getRankList();
    ranks?.sort((a, b) => (a.rankPriority ?? 0) - (b.rankPriority ?? 0));
    UserStates.instance.ranks = ranks;
    countries = (await getIt<CountryProvider>().getCountry()) ?? [];
    Country? india =
        countries.firstWhereOrNull((country) => country.countryCode == "IN");
    countries.removeWhere((country) => country.id == india?.id);
    if (india != null) {
      countries.insert(0, india);
    }
    UserStates.instance.countries = countries;
    crewUser = UserStates.instance.crewUser ??
        await getIt<CrewUserProvider>().getCrewUser(softRefresh: true);
    UserStates.instance.crewUser = crewUser;
    if (crewUser?.id != null) {
      await setStep1Fields();
    }
    if (!editMode) {
      if (crewUser?.screenCheck == 1) {
        userDetails =
            await getIt<UserDetailsProvider>().getUserDetails(crewUser!.id!);
        UserStates.instance.userDetails = userDetails;
        await setStep2Fields();
      } else if (crewUser?.screenCheck == 2) {
        serviceRecords.value =
            (await getIt<SeaServiceProvider>().getSeaServices(crewUser!.id!)) ??
                [];
        UserStates.instance.serviceRecords = serviceRecords;
        previousEmployerReferences.value =
            (await getIt<PreviousEmployerProvider>()
                    .getPreviousEmployer(crewUser!.id!)) ??
                [];
        UserStates.instance.previousEmployerReferences =
            previousEmployerReferences;
      } else if (crewUser?.screenCheck == 3) {
        if (crewUser?.isVerified == 1) {
          Get.offAllNamed(Routes.HOME);
        } else {
          Get.offAllNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
        }
      }
      step.value = (crewUser?.screenCheck ?? 0) + 1;
    }

    isLoading.value = false;
  }

  Future<void> setStep2Fields() async {
    indosNumber.text = userDetails?.iNDOSNumber ?? "";
    cdcSeamanNumber.text = userDetails?.cDCSeamanBookNumber ?? "";
    cdcSeamanNumberValidTill.text =
        userDetails?.cDCSeamanBookNumberValidTill ?? "";
    passportNumber.text = userDetails?.passportNumber ?? "";
    passportValidTill.text = userDetails?.passportNumberValidTill ?? "";
    usVisaValidTill.text = userDetails?.validUSVisaValidTill ?? "";
    stcwIssuingAuthorities.value = userDetails?.sTCWIssuingAuthority ?? [];
    cocIssuingAuthorities.value = userDetails?.validCOCIssuingAuthority ?? [];
    copIssuingAuthorities.value = userDetails?.validCOPIssuingAuthority ?? [];
    watchKeepingIssuingAuthorities.value =
        userDetails?.validWatchKeepingIssuingAuthority ?? [];
    isHoldingValidCOC.value = cocIssuingAuthorities.isNotEmpty;
    isHoldingValidCOP.value = copIssuingAuthorities.isNotEmpty;
    isHoldingWatchKeeping.value = watchKeepingIssuingAuthorities.isNotEmpty;
    isHoldingValidUSVisa.value = userDetails?.validUSVisaValidTill != null;
  }

  Future<void> setStep1Fields() async {
    phoneNumber.text = crewUser?.number?.split("-")[1] ?? "";
    selectedCountryCode.value = crewUser?.number?.split("-").firstOrNull ?? "";
    selectedRank.value =
        ranks?.firstWhereOrNull((e) => e.id == crewUser?.rankId);
    addressLine1.text = crewUser?.addressLine1 ?? "";
    addressLine2.text = crewUser?.addressLine2 ?? "";
    city.text = crewUser?.addressCity ?? "";
    dateOfBirth.text = crewUser?.dob ?? "";
    userId = crewUser?.id;
    isLookingForPromotion.value = crewUser?.promotionApplied == true;
    zipCode.text = crewUser?.pincode ?? "";
    maritalStatus.value = crewUser?.maritalStatus;
    uploadedImagePath.value = "$baseURL/${crewUser?.profilePic}";
    uploadedResumePath.value = "$baseURL/${crewUser?.resume}";
    gender.value = crewUser?.gender;
    country.value =
        countries.firstWhereOrNull((e) => e.id == crewUser?.country);
    await getStates();
    state.value = states.firstWhereOrNull((e) => e.id == crewUser?.state);
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

  prepareRecordBottomSheet() async {
    if (vesselList != null) {
      return;
    }
    isPreparingRecordBottomSheet.value = true;
    vesselList = await getIt<VesselListProvider>().getVesselList();
    isPreparingRecordBottomSheet.value = false;
  }

  @override
  void onReady() {
    super.onReady();
    fToast.init(parentKey.currentContext!);
  }

  Future<bool> postStep1() async {
    step1FormMisses.clear();
    if (pickedImage.value?.path == null && crewUser?.profilePic == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectProfilePic);
    }
    if (pickedResume.value?.path == null && crewUser?.resume == null) {
      step1FormMisses.add(Step1FormMiss.didNotSelectResume);
    }
    if (selectedRank.value?.id == null) {
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

    if ((pickedImage.value?.path == null && crewUser?.profilePic == null) ||
        (pickedResume.value?.path == null && crewUser?.resume == null) ||
        selectedRank.value?.id == null ||
        maritalStatus.value == null ||
        country.value == null ||
        state.value == null) {
      return false;
    }
    isUpdating.value = true;
    int? statusCode;
    if (crewUser?.id == null) {
      statusCode = await getIt<CrewUserProvider>().createCrewUser(
          crewUser: CrewUser(
              firstName: FirebaseAuth.instance.currentUser?.displayName,
              lastName: "_",
              password: "Demo@123",
              email: FirebaseAuth.instance.currentUser?.email,
              addressLine1: addressLine1.text,
              pincode: zipCode.text,
              dob: dateOfBirth.text,
              maritalStatus: maritalStatus.value,
              country: country.value?.id,
              rankId: selectedRank.value?.id,
              gender: gender.value,
              userTypeKey: 2,
              addressLine2: addressLine2.text.nullIfEmpty(),
              addressCity: city.text,
              state: state.value?.id,
              promotionApplied: isLookingForPromotion.value,
              screenCheck: 1,
              authKey: await FirebaseAuth.instance.currentUser?.getIdToken()),
          profilePicPath: pickedImage.value?.path,
          resumePath: pickedResume.value?.path);
      if (statusCode < 300) {
        fToast.safeShowToast(
            child: successToast("Your account was successfully created."));
      } else {
        fToast.safeShowToast(child: errorToast("Error creating your account"));
      }
    } else {
      statusCode = await getIt<CrewUserProvider>().updateCrewUser(
          crewId: crewUser!.id!,
          crewUser: CrewUser(
              firstName: FirebaseAuth.instance.currentUser?.displayName,
              lastName: "_",
              email: FirebaseAuth.instance.currentUser?.email,
              addressLine1: addressLine1.text,
              pincode: zipCode.text,
              dob: dateOfBirth.text,
              maritalStatus: maritalStatus.value,
              country: country.value?.id,
              rankId: selectedRank.value?.id,
              gender: gender.value,
              userTypeKey: 2,
              addressLine2: addressLine2.text,
              addressCity: city.text,
              state: state.value?.id,
              promotionApplied: isLookingForPromotion.value,
              screenCheck: 1,
              authKey: await FirebaseAuth.instance.currentUser?.getIdToken()),
          profilePicPath: pickedImage.value?.path,
          resumePath: pickedResume.value?.path);
      if ((statusCode ?? 999) < 300) {
        fToast.safeShowToast(
            child: successToast("Your account was successfully updated."));
      } else {
        fToast.safeShowToast(child: errorToast("Error updating your account"));
      }
    }
    isUpdating.value = false;

    return (statusCode ?? 0) < 300;
  }

  Future<bool> postStep2() async {
    step2FormMisses.clear();
    if (stcwIssuingAuthorities.isEmpty) {
      step2FormMisses.add(Step2FormMiss.stcwIssuingAuthority);
    }
    if (selectedRank.value?.coc == true &&
        // ![
        //     "Deck Cadet",
        //     "Trainee Electrical Cadet",
        //     "Engine Cadet",
        //     "Trainee Ordinary Seaman",
        //     "Trainee Wiper"
        //   ].contains(selectedRank.value?.name) &&
        isHoldingValidCOC.value == true &&
        cocIssuingAuthorities.isEmpty) {
      step2FormMisses.add(Step2FormMiss.cocIssuingAuthority);
    }
    if (isHoldingValidCOC.value != true &&
        selectedRank.value?.cop == true &&
        // ![
        //   "Mess boy / GS / Steward",
        //   "Second Cook / 2nd Cook",
        //   "Chief Cook",
        //   "Trainee Electrical Cadet",
        //   "ETO / Electrician",
        // ].contains(selectedRank.value?.name) &&

        isHoldingValidCOP.value == true &&
        copIssuingAuthorities.isEmpty) {
      step2FormMisses.add(Step2FormMiss.copIssuingAuthority);
    }
    if (isHoldingValidCOC.value != true &&
        selectedRank.value?.watchKeeping == true &&
        // ![
        //   "Mess boy / GS / Steward",
        //   "Second Cook / 2nd Cook",
        //   "Chief Cook",
        //   "Trainee Electrical Cadet",
        //   "ETO / Electrician",
        // ].contains(selectedRank.value?.name) &&
        isHoldingWatchKeeping.value == true &&
        watchKeepingIssuingAuthorities.isEmpty) {
      step2FormMisses.add(Step2FormMiss.watchKeepingIssuingAuthority);
    }
    if (formKeyStep2.currentState?.validate() != true) {
      return false;
    }
    if (step2FormMisses.isNotEmpty) {
      return false;
    }
    isUpdating.value = true;
    UserDetails? userDetails;
    try {
      if (this.userDetails?.id == null) {
        userDetails = await getIt<UserDetailsProvider>().postUserDetails(
            UserDetails(
                userId: userId,
                iNDOSNumber: indosNumber.text.nullIfEmpty(),
                cDCSeamanBookNumber: cdcSeamanNumber.text.nullIfEmpty(),
                cDCSeamanBookNumberValidTill:
                    cdcSeamanNumberValidTill.text.nullIfEmpty(),
                passportNumber: passportNumber.text.nullIfEmpty(),
                passportNumberValidTill: passportValidTill.text.nullIfEmpty(),
                validUSVisa: usVisaValidTill.text.isNotEmpty,
                sTCWIssuingAuthority: stcwIssuingAuthorities.nullIfEmpty(),
                validCOCIssuingAuthority: cocIssuingAuthorities.nullIfEmpty(),
                validCOPIssuingAuthority: copIssuingAuthorities.nullIfEmpty(),
                validWatchKeepingIssuingAuthority:
                    watchKeepingIssuingAuthorities.nullIfEmpty(),
                validUSVisaValidTill: usVisaValidTill.text.nullIfEmpty()));
        await getIt<CrewUserProvider>().updateCrewUser(
            crewId: crewUser?.id ?? -1, crewUser: CrewUser(screenCheck: 2));
      } else {
        userDetails = await getIt<UserDetailsProvider>().patchUserDetails(
            UserDetails(
                id: this.userDetails?.id,
                userId: userId,
                iNDOSNumber: indosNumber.text.nullIfEmpty(),
                cDCSeamanBookNumber: cdcSeamanNumber.text.nullIfEmpty(),
                cDCSeamanBookNumberValidTill:
                    cdcSeamanNumberValidTill.text.nullIfEmpty(),
                passportNumber: passportNumber.text.nullIfEmpty(),
                passportNumberValidTill: passportValidTill.text.nullIfEmpty(),
                validUSVisa: usVisaValidTill.text.isNotEmpty,
                sTCWIssuingAuthority: stcwIssuingAuthorities.nullIfEmpty(),
                validCOCIssuingAuthority: cocIssuingAuthorities.nullIfEmpty(),
                validCOPIssuingAuthority: copIssuingAuthorities.nullIfEmpty(),
                validWatchKeepingIssuingAuthority:
                    watchKeepingIssuingAuthorities.nullIfEmpty(),
                validUSVisaValidTill: usVisaValidTill.text.nullIfEmpty()));
      }
    } catch (e) {
      print("$e");
    }

    if (userDetails?.userId != null) {
      fToast.safeShowToast(child: successToast("Details uploaded"));
    } else {
      fToast.safeShowToast(
          child:
              errorToast("Some error occurred while uploading your details"));
    }
    isUpdating.value = false;
    return true;
  }

  step3SubmitOnPress() async {
    step3FormMisses.clear();
    /* if (serviceRecords.length < 2) {
      step3FormMisses.add(Step3FormMiss.lessThan2SeaServiceRecords);
    }
    if (previousEmployerReferences.isEmpty) {
      step3FormMisses
          .add(Step3FormMiss.referenceFromPreviousEmployerNotProvided);
    } */
    if (!declaration1.value || !declaration2.value) {
      step3FormMisses.add(Step3FormMiss.didNotAgreeToTermsAndCondition);
    }

    if (step3FormMisses.isNotEmpty) {
      return;
    }
    isUpdating.value = true;
    await getIt<CrewUserProvider>().updateCrewUser(
        crewId: crewUser?.id ?? -1, crewUser: CrewUser(screenCheck: 3));
    isUpdating.value = false;
    Get.toNamed(Routes.ACCOUNT_UNDER_VERIFICATION);
  }

  calculateDuration() {
    if (recordSignOffDate.text.isEmpty || recordSignOnDate.text.isEmpty) {
      recordContractDuration.value = null;
      return;
    }
    LocalDate a = LocalDate.dateTime(DateTime.parse(recordSignOnDate.text));
    LocalDate b = LocalDate.dateTime(DateTime.parse(recordSignOffDate.text));
    Period diff = b.periodSince(a);
    String sentence = "";
    /* if (diff.years != 0) {
      if (diff.years == 1) {
        sentence = "${diff.years} Year-";
      } else {
        sentence = "${diff.years} Years-";
      }
    } */
    if ((diff.months + diff.years * 12) != 0) {
      if ((diff.months + diff.years * 12) == 1) {
        sentence = "$sentence ${(diff.months + diff.years * 12)} Month-";
      } else {
        sentence = "$sentence ${(diff.months + diff.years * 12)} Months-";
      }
    }
    if (diff.days != 0) {
      if (diff.days == 1) {
        sentence = "$sentence ${diff.days} Day-";
      } else {
        sentence = "$sentence ${diff.days} Days-";
      }
    }
    sentence = sentence.split("-").join(", ");
    sentence = sentence.substring(0, sentence.length - 2);
    recordContractDuration.value = sentence;
    /* if (diff.years == 0) {
      recordContractDuration.value = "${diff.months} Months";
    } else if (diff.months != 0) {
      recordContractDuration.value =
          "${diff.years} Years, ${diff.months} Months";
    } else {
      recordContractDuration.value = "${diff.years} Years";
    } */
  }

  Future<bool> addServiceRecord() async {
    isAddingBottomSheet.value = true;
    SeaServiceRecord? newRecord;
    SeaServiceRecord? updatedRecord;
    try {
      if (selectedSeaServiceRecord?.id == null) {
        newRecord = await getIt<SeaServiceProvider>().postSeaService(
            SeaServiceRecord(
                companyName: recordCompanyName.text,
                shipName: recordShipName.text,
                iMONumber: recordIMONumber.text,
                rankId: recordRank.value?.id,
                flag: recordFlagName.text,
                gRT: recordGrt.text,
                vesselType: recordVesselType.value,
                signonDate: recordSignOnDate.text,
                signoffDate: recordSignOffDate.text));
      } else {
        updatedRecord = await getIt<SeaServiceProvider>().updateSeaService(
            SeaServiceRecord(
                id: selectedSeaServiceRecord?.id,
                companyName: recordCompanyName.text,
                shipName: recordShipName.text,
                iMONumber: recordIMONumber.text,
                rankId: recordRank.value?.id,
                flag: recordFlagName.text,
                gRT: recordGrt.text,
                vesselType: recordVesselType.value,
                signonDate: recordSignOnDate.text,
                signoffDate: recordSignOffDate.text));
      }
    } catch (e) {
      print("$e");
    }

    isAddingBottomSheet.value = false;
    if (newRecord != null && newRecord.id != null) {
      serviceRecords.add(newRecord);
      return true;
    } else if (updatedRecord != null && updatedRecord.id != null) {
      int? index =
          serviceRecords.indexWhere((record) => record.id == updatedRecord?.id);
      serviceRecords
        ..removeAt(index)
        ..insert(index, updatedRecord);
      return true;
    } else {
      return false;
    }
  }

  Future<void> deleteServiceRecord(int id) async {
    serviceRecordDeletingId.value = id;
    Response resp = await getIt<SeaServiceProvider>().deleteSeaService(id);
    if (resp.statusCode == 204) {
      serviceRecords.removeWhere((serviceRecord) => serviceRecord.id == id);
    } else {
      fToast.safeShowToast(
          child: errorToast(
              "There was an issue deleting your Sea Service Record"));
    }
    serviceRecordDeletingId.value = -1;
  }

  Future<bool> addReferenceFromPreviousEmployer() async {
    isAddingBottomSheet.value = true;
    PreviousEmployerReference? newPreviousEmployerReference;
    PreviousEmployerReference? updatedPreviousEmployerReference;
    try {
      if (selectedPreviousReference?.id == null) {
        newPreviousEmployerReference = await getIt<PreviousEmployerProvider>()
            .postPreviousEmployer(PreviousEmployerReference(
          userId: userId,
          companyName: referenceCompanyName.text,
          referenceName: referenceReferenceName.text,
          contactNumber:
              "${referenceDialCode.text}-${referenceContactNumber.text}",
        ));
      } else {
        updatedPreviousEmployerReference =
            await getIt<PreviousEmployerProvider>()
                .patchPreviousEmployer(PreviousEmployerReference(
          id: selectedPreviousReference?.id,
          userId: userId,
          companyName: referenceCompanyName.text,
          referenceName: referenceReferenceName.text,
          contactNumber:
              "${referenceDialCode.text}-${referenceContactNumber.text}",
        ));
      }
    } catch (e) {
      print("$e");
    }
    isAddingBottomSheet.value = false;
    if (newPreviousEmployerReference != null) {
      previousEmployerReferences.add(newPreviousEmployerReference);
      return true;
    } else if (updatedPreviousEmployerReference != null) {
      int? index = previousEmployerReferences
          .indexWhere((ref) => ref.id == selectedPreviousReference?.id);

      previousEmployerReferences
        ..removeAt(index)
        ..insert(index, updatedPreviousEmployerReference);
      return true;
    } else {
      return false;
    }
  }

  deleteReferenceFromPreviousEmployer(int id) async {
    previousEmployerReferenceDeletingId.value = id;
    final resp =
        await getIt<PreviousEmployerProvider>().deletePreviousEmployer(id);
    if (resp.statusCode == 204) {
      previousEmployerReferences.removeWhere(
          (previousEmployerReference) => previousEmployerReference.id == id);
    } else {
      fToast.safeShowToast(
          child: errorToast(
              "There was an issue deleting your Employer Reference"));
    }
    previousEmployerReferenceDeletingId.value = -1;
  }

  resetRecordBottomSheet() {
    recordCompanyName.clear();
    recordShipName.clear();
    recordIMONumber.clear();
    recordFlagName.clear();
    recordGrt.clear();
    recordSignOnDate.clear();
    recordSignOffDate.clear();
    recordContractDuration.value = null;
    recordRank.value = null;
    recordVesselType.value = null;
    selectedSeaServiceRecord = null;
  }

  resetReferenceBottomSheet() {
    referenceCompanyName.clear();
    referenceReferenceName.clear();
    referenceContactNumber.clear();
    selectedPreviousReference = null;
  }

  setRecordBottomSheet(SeaServiceRecord record) {
    selectedSeaServiceRecord = record;
    recordCompanyName.text = record.companyName ?? "";
    recordShipName.text = record.shipName ?? "";
    recordIMONumber.text = record.iMONumber ?? "";
    recordRank.value = ranks?.firstWhere((rank) => rank.id == record.rankId);
    recordFlagName.text = record.flag ?? "";
    recordGrt.text = record.gRT ?? "";
    recordVesselType.value = record.vesselType;
    recordSignOnDate.text = record.signonDate ?? "";
    recordSignOffDate.text = record.signoffDate ?? "";
    calculateDuration();
    // recordContarctDuration.text = record.contractDuration?.toString() ?? "";
  }

  setReferenceBottomSheet(PreviousEmployerReference reference) {
    selectedPreviousReference = reference;
    referenceCompanyName.text = reference.companyName ?? "";
    try {
      referenceContactNumber.text =
          reference.contactNumber?.split("-")[1] ?? "";
      referenceDialCode.text = reference.contactNumber?.split("-")[0] ?? "";
    } catch (e) {
      print(e);
    }
    referenceReferenceName.text = reference.referenceName ?? "";
  }

  Future<void> pickResume() async {
    // final x = await Permission.storage.request();
    // await checkStoragePermission();
    final path = await FlutterDocumentPicker.openDocument(
        params: FlutterDocumentPickerParams(
      allowedFileExtensions: ['pdf', 'doc', 'docx'],
    ));
    if (path == null) {
      return;
    }
    pickedResume.value = File(path);

/*     FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result == null) {
      return;
    }
    if (!["doc", "docx", "pdf"].contains(result.files.single.extension ?? "")) {
      fToast.safeShowToast(
          child:
              errorToast("Please pick your resume in supported file format"));
      return;
    }

    if (result.files.single.path != null) {
      pickedResume.value = File(result.files.single.path!);
    } else {
      // User canceled the picker
    } */
  }

  Future<bool> checkStoragePermission() async {
    PermissionStatus status;
    status = await Permission.storage.request();
    if (Platform.isAndroid) {
      final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
      final AndroidDeviceInfo info = await deviceInfoPlugin.androidInfo;
      if ((info.version.sdkInt ?? 0) >= 33) {
        status = await Permission.manageExternalStorage.request();
      } else {
        status = await Permission.storage.request();
      }
    } else {
      status = await Permission.storage.request();
    }

    switch (status) {
      case PermissionStatus.denied:
        return false;
      case PermissionStatus.granted:
        return true;
      case PermissionStatus.restricted:
        return false;
      case PermissionStatus.limited:
        return true;
      case PermissionStatus.permanentlyDenied:
        return false;
      case PermissionStatus.provisional:
        return true;
    }
  }
}

class CrewOnboardingArguments {
  final String? email;
  final String? password;
  final bool? editMode;

  const CrewOnboardingArguments({this.email, this.password, this.editMode});
}

// enum Gender { male, female }

mixin PickImage {
  final Rxn<XFile> pickedImage = Rxn();
  final ImagePicker imagePicker = ImagePicker();

  Future<void> pickSource() async {
    return showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Pick Image from"),
                  IconButton(onPressed: Get.back, icon: const Icon(Icons.close))
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: const EdgeInsets.symmetric(vertical: 16),
              titlePadding: const EdgeInsets.only(left: 16, right: 16, top: 16),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      pickedImage.value = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      Get.back();
                    },
                    child: const Text("Gallery")),
                // Spacer(),
                ElevatedButton(
                    onPressed: () async {
                      pickedImage.value = await imagePicker.pickImage(
                          source: ImageSource.camera);
                      Get.back();
                    },
                    child: const Text("Image"))
              ],
            ));
  }

  Future<bool?> confirmUpdate() {
    return showDialog<bool>(
        context: Get.context!,
        builder: (context) {
          return AlertDialog(
            title: const Text("Are you sure you want to update to this image?"),
            content: Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: Image.file(File(pickedImage.value!.path)).image,
                      fit: BoxFit.cover)),
            ),
            actions: [
              OutlinedButton(
                  onPressed: () async {
                    Get.back(result: true);
                  },
                  child: const Text("Yes")),
              8.horizontalSpace,
              OutlinedButton(
                  onPressed: () {
                    pickedImage.value = null;
                    Get.back(result: false);
                  },
                  child: const Text("No")),
              8.horizontalSpace,
            ],
          );
        });
  }
}

mixin PickResume {}
