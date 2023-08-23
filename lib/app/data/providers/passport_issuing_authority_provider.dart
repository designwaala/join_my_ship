import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/passport_issuing_authority_model.dart';

class PassportIssuingAuthorityProvider extends WrapperConnect {
  PassportIssuingAuthorityProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>)
        return PassportIssuingAuthority.fromJson(map);
      if (map is List)
        return map
            .map((item) => PassportIssuingAuthority.fromJson(item))
            .toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<PassportIssuingAuthority>?> getPassportIssuingAuthority(
      int userType) async {
    final response = await get('employer/passport_list/$userType', headers: {});
    return response.body;
  }
}
