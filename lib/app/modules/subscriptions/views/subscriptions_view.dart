import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/subscriptions/views/widgets/active_plans_view.dart';
import 'package:join_my_ship/app/modules/subscriptions/views/widgets/buy_plans_view.dart';
import 'package:join_my_ship/utils/user_details.dart';

import '../controllers/subscriptions_controller.dart';

class SubscriptionsView extends GetView<SubscriptionsController> {
  const SubscriptionsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: controller.parentKey,
        appBar: AppBar(
          title: Text(
            UserStates.instance.crewUser?.userTypeKey == 2 ?
            'My Subscriptions' : 'Subscriptions'),
          centerTitle: true,
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                    ],
                  ),
                )
              : UserStates.instance.crewUser?.userTypeKey != 2
                  ? Column(
                      children: [
                        32.verticalSpace,
                        Container(
                          height: 46,
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          width: double.maxFinite,
                          decoration: BoxDecoration(
                              boxShadow: const [
                                BoxShadow(
                                  color: Color.fromRGBO(60, 162, 255, 0.08),
                                  spreadRadius: 2,
                                  blurRadius: 4,
                                  offset: Offset(0, 4),
                                ),
                              ],
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10)),
                          child: Row(
                              children: SubscriptionViewTypes.values
                                  .map((view) => Expanded(
                                          child: InkWell(
                                        onTap: () =>
                                            controller.view.value = view,
                                        child: Container(
                                          height: double.maxFinite,
                                          decoration: BoxDecoration(
                                              color:
                                                  controller.view.value == view
                                                      ? Get.theme.primaryColor
                                                      : null,
                                              boxShadow: controller
                                                          .view.value ==
                                                      view
                                                  ? [
                                                      const BoxShadow(
                                                          offset: Offset(0, 4),
                                                          blurRadius: 6,
                                                          color: Color.fromRGBO(
                                                              60,
                                                              162,
                                                              255,
                                                              0.10))
                                                    ]
                                                  : null,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(view.name,
                                                  style: Get
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                          color: controller.view
                                                                      .value ==
                                                                  view
                                                              ? Colors.white
                                                              : null)),
                                            ],
                                          ),
                                        ),
                                      )))
                                  .toList()),
                        ),
                        16.verticalSpace,
                        controller.view.value == SubscriptionViewTypes.buyPlans
                            ? const BuyPlansView()
                            : const ActivePlansView()
                      ],
                    )
                  : Column(
                      children: [
                        16.verticalSpace,
                        ActivePlansView(),
                      ],
                    );
        }));
  }
}
