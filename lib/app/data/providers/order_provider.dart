import 'package:get/get.dart';
import 'package:join_my_ship/main.dart';
import 'package:join_my_ship/utils/shared_preferences.dart';
import 'package:join_my_ship/utils/wrapper_connect.dart';

import '../models/order_model.dart';

class OrderProvider extends WrapperConnect {
  OrderProvider() {
    httpClient.defaultDecoder = (map) {
      if (map is Map<String, dynamic>) return Order.fromJson(map);
      if (map is List) return map.map((item) => Order.fromJson(item)).toList();
    };
    httpClient.baseUrl = baseURL;
  }

  Future<Order?> createOrder(
      {required String currency, required double amount}) async {
    final response = await multipartPost('myadmin_api/api/create_order/',
        {"currency": currency, "amount": "$amount"});
    return Order.fromJson(response);
  }

  Future<Order?> captureOrder(
      {required String razorpayOrderId,
      required int djangoOrderId,
      required String paymentId}) async {
    final response = await multipartPatch(
        'myadmin_api/api/capture_payment/$djangoOrderId/',
        {"payment_id": paymentId, "order_id": razorpayOrderId});
    return Order.fromJson(response);
  }

  Future<List<Order>?> getOrders() async {
    final response = await get(
        "myadmin_api/get_transaction_history/${PreferencesHelper.instance.userId}/");
    return response.body;
  }
}
