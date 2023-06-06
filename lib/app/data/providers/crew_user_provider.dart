import 'package:get/get.dart';
import 'package:join_mp_ship/utils/wrapper_connect.dart';

import '../../../main.dart';
import '../models/crew_user_model.dart';
import 'package:http/http.dart' as http;

class CrewUserProvider extends WrapperConnect {
  CrewUserProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return CrewUser.fromJson(map);
      if (map is List)
        return map.map((item) => CrewUser.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<CrewUser?> getCrewUser() async {
    final response = await get('crew/get_user');
    return response.body;
  }

  Future<int> createCrewUser(
      {required CrewUser crewUser,
      String? profilePicPath,
      String? resumePath}) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse('http://designwaala.me/crew/user_create'));
    request.fields.addAll(crewUser.toJson());
    if (resumePath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('resume', resumePath));
    }
    if (profilePicPath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('profilePic', profilePicPath));
    }

    request.headers.addAll({
      "Content-Type": "multipart/form-data; boundary=<calculated when request is sent>"
    });

    http.StreamedResponse response = await request.send();
    if (response.statusCode < 300) {
      print(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
    return response.statusCode;
  }
}
