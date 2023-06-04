import 'package:get/get.dart';
import 'package:join_mp_ship/main.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../models/user_details_model.dart';

class UserDetailsProvider extends WrapperConnect {
  UserDetailsProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return UserDetails.fromJson(map);
      if (map is List)
        return map.map((item) => UserDetails.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<UserDetails?> postUserDetails(UserDetails userDetails) async {
    final response = await post('crew/crew_details_create', userDetails);
    return response.body;
  }

}
