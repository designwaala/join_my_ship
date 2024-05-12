import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/user_details.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/subscription_model.dart';

class SubscriptionProvider extends WrapperConnect {
  SubscriptionProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Subscription.fromJson(map);
      if (map is List)
        return map.map((item) => Subscription.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<Subscription>?> getSubscriptions({int? planType}) async {
    final response = await get('crew/get_subscripstions',
        query: {if (planType != null) "plan_type": "$planType"});
    UserStates.instance.subscription = response.body;
    return response.body;
  }
}
