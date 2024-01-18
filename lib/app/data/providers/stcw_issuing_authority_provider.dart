import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/stcw_issuing_authority_model.dart';

class StcwIssuingAuthorityProvider extends WrapperConnect {
  StcwIssuingAuthorityProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>)
        return StcwIssuingAuthority.fromJson(map);
      if (map is List)
        return map.map((item) => StcwIssuingAuthority.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<StcwIssuingAuthority>?> getStcwIssuingAuthorities(
      int userType) async {
    final response = await get('employer/stcw_list/$userType', headers: {});
    return response.body;
  }
}
