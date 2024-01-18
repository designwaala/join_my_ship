import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/country_model.dart';

class CountryProvider extends WrapperConnect {
  CountryProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Country.fromJson(map);
      if (map is List)
        return map.map((item) => Country.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<Country>?> getCountry() async {
    final response = await get('employer/country_list', headers: {});
    return response.body;
  }

  Future<Response<Country>> postCountry(Country country) async =>
      await post('country', country);
  Future<Response> deleteCountry(int id) async => await delete('country/$id');
}
