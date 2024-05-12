import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/subscription_plan_model.dart';

class SubscriptionPlanProvider extends WrapperConnect {
  SubscriptionPlanProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return SubscriptionPlan.fromJson(map);
      if (map is List)
        return map.map((item) => SubscriptionPlan.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<List<SubscriptionPlan>?> getSubscriptionPlans() async {
    final response = await get('myadmin_api/subscription_plans/get/');
    return response.body;
  }

  Future<SubscriptionPlan?> getSubscriptionPlan(int id) async {
    final response = await get('myadmin_api/subscription_plans/get/$id/');
    return response.body;
  }

  Future<SubscriptionPlan> updateSubscriptionPlan(
      SubscriptionPlan subscriptionPlan) async {
    final response = await multipartPatch(
        "myadmin_api/subscription_plans/update/${subscriptionPlan.id}/",
        subscriptionPlan.toJson());
    return SubscriptionPlan.fromJson(response);
  }

  Future<Response<SubscriptionPlan>> createSubscriptionPlan(
          SubscriptionPlan subscriptionplan) async =>
      await post(
          'myadmin_api/subscription_plans/create/', subscriptionplan.toJson(),
          decoder: (data) => SubscriptionPlan.fromJson(data));
  Future<Response> deleteSubscriptionPlan(int id) async =>
      await delete('myadmin_api/subscription_plans/delete/$id/');
}
