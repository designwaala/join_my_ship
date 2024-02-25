import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/applied_refer_code_model.dart';

class AppliedReferCodeProvider extends WrapperConnect {
  AppliedReferCodeProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return AppliedReferCode.fromJson(map);
      if (map is List)
        return map.map((item) => AppliedReferCode.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<AppliedReferCode?> applyCode(String code) async {
    final response = await post(
      'crew/use_referred_code/$code/',
      {},
      decoder: (data) => AppliedReferCode.fromJson(data),
    );
    return response.body;
  }
}
