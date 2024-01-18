import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';

import '../models/ranks_model.dart';

class RanksProvider extends GetConnect {
  RanksProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Rank.fromJson(map);
      if (map is List) return map.map((item) => Rank.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<Rank>?> getRankList() async {
    final response = await get('employer/rank_list', headers: {});
    return response.body;
  }

  Future<Response<Rank>> postRanks(Rank ranks) async =>
      await post('ranks', ranks);
  Future<Response> deleteRanks(int id) async => await delete('ranks/$id');
}
