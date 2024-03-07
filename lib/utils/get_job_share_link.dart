import 'package:join_my_ship/utils/shared_preferences.dart';

String getJobShareLink(int? jobId) =>
    "http://joinmyship.com/job/?job_id=${jobId}${PreferencesHelper.instance.userCode?.isNotEmpty == true ? "&user_code=${PreferencesHelper.instance.userCode}" : ""}";
