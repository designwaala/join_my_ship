import 'package:get/get.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/employer_user_model.dart';

class EmployerUserProvider extends WrapperConnect {
  @override
  void onInit() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return EmployerUser.fromJson(map);
      if (map is List)
        return map.map((item) => EmployerUser.fromJson(item)).toList();
    };
    httpClient.baseUrl = 'YOUR-API-URL';
  }

  Future<EmployerUser?> getEmployerUser(int id) async {
    final response = await get('employeruser/$id');
    return response.body;
  }

  Future<Response<EmployerUser>> postEmployerUser(
          EmployerUser employeruser) async =>
      await post('employeruser', employeruser);
  Future<Response> deleteEmployerUser(int id) async =>
      await delete('employeruser/$id');
}
