import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/check_referral_code_apply_model.dart';

class CheckReferralCodeApplyProvider extends WrapperConnect {
  CheckReferralCodeApplyProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>)
        return CheckReferralCodeApply.fromJson(map);
      if (map is List)
        return map
            .map((item) => CheckReferralCodeApply.fromJson(item))
            .toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<CheckReferralCodeApply?> getCheckReferralCodeApply() async {
    final response = await get('crew/check_referred_code/');
    return response.body;
  }
}
