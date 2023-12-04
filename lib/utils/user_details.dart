import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/previous_employer_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/resume_pack_model.dart';
import 'package:join_mp_ship/app/data/models/resume_top_up_model.dart';
import 'package:join_mp_ship/app/data/models/sea_service_model.dart';
import 'package:join_mp_ship/app/data/models/subscription_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/data/providers/country_provider.dart';
import 'package:join_mp_ship/app/data/providers/ranks_provider.dart';
import 'package:join_mp_ship/app/modules/sign_up_email/controllers/sign_up_email_controller.dart';
import 'package:join_mp_ship/main.dart';

class UserStates {
  UserStates._();
  static final UserStates instance = UserStates._();
  List<Rank>? ranks;
  List<Country>? countries;
  CrewUser? crewUser;
  UserDetails? userDetails;
  List<SeaServiceRecord>? serviceRecords;
  List<PreviousEmployerReference>? previousEmployerReferences;
  bool? _isCrew;
  SignUpType? employerType;
  CrewUser? prefilledDetails;
  String? userLink;
  List<Subscription>? subscription;
  List<ResumePack>? resumePacks;
  List<ResumeTopUp>? resumeTopUps;

  set isCrew(bool? value) {
    _isCrew = value;
    if (_isCrew == true) {
      employerType = SignUpType.crew;
    }
  }

  bool? get isCrew => _isCrew;

  setEmployerTypeIndex(int index) {
    switch (index) {
      case 3:
        employerType = SignUpType.employerITF;
        break;
      case 4:
        employerType = SignUpType.employerManagementCompany;
        break;
      case 5:
        employerType = SignUpType.employerCrewingAgent;
        break;
    }
  }

  Future<void> getRanksIfEmpty() async {
    if (ranks == null || ranks?.isEmpty == true) {
      ranks = await getIt<RanksProvider>().getRankList();
    }
  }

  Future<void> getCOuntriesIfEmpty() async {
    if (countries == null || countries?.isEmpty == true) {
      countries = await getIt<CountryProvider>().getCountry();
    }
  }

  reset() {
    ranks = countries = crewUser = userDetails = serviceRecords =
        previousEmployerReferences = _isCrew =
            employerType = resumePacks = resumeTopUps = subscription = null;
  }
}
