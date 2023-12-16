import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/notification_model.dart';
import 'package:join_mp_ship/app/data/providers/notification_provider.dart';
import 'package:join_mp_ship/main.dart';

class NotificationController extends GetxController {
  List<Notification> notifications = [];
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    getNotifications();
  }

  Future<void> getNotifications() async {
    isLoading.value = true;
    notifications =
        (await getIt<NotificationProvider>().getNotifications()) ?? [];
    isLoading.value = false;
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
