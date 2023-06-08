import 'package:join_mp_ship/app/data/models/country_model.dart';
import 'package:join_mp_ship/app/data/models/crew_user_model.dart';
import 'package:join_mp_ship/app/data/models/previous_employer_model.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/data/models/sea_service_model.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';

class UserStates {
  UserStates._();
  static final UserStates instance = UserStates._();
  List<Rank>? ranks;
  List<Country>? countries;
  CrewUser? crewUser;
  UserDetails? userDetails;
  List<SeaServiceRecord>? serviceRecords;
  List<PreviousEmployerReference>? previousEmployerReferences;
}
