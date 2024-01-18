import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/cdc_issuing_authority_model.dart';

class CdcIssuingAuthorityProvider extends WrapperConnect {
  CdcIssuingAuthorityProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return CdcIssuingAuthority.fromJson(map);
      if (map is List)
        return map.map((item) => CdcIssuingAuthority.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<CdcIssuingAuthority>?> getCdcIssuingAuthorities(
      int userType) async {
    final response = await get('employer/cdc_list/$userType', headers: {});
    return response.body;
  }
}
