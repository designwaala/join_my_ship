import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/data/models/credits_model.dart';
import 'package:join_my_ship/utils/extensions/string_extensions.dart';
import 'package:join_my_ship/widgets/custom_text_form_field.dart';

import '../controllers/add_credits_controller.dart';
import 'package:collection/collection.dart';

class AddCreditsView extends GetView<AddCreditsController> {
  const AddCreditsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Credits'),
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Container(
                      decoration:
                          BoxDecoration(color: Colors.white, boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade300,
                            offset: const Offset(0, 2),
                            spreadRadius: 4,
                            blurRadius: 8)
                      ]),
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Change Currency",
                              style: Get.textTheme.titleMedium),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<CreditCurrency>(
                                hint: controller.selectedCurrency.value == null
                                    ? null
                                    : Text(
                                        "${controller.selectedCurrency.value?.code} (${controller.selectedCurrency.value?.symbol})",
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                                color: Get.theme.colorScheme
                                                    .primary)),
                                icon: Icon(Icons.keyboard_arrow_down,
                                    color: Get.theme.colorScheme.primary),
                                items: controller.creditsModel?.creditCurrencies
                                    ?.map((e) => DropdownMenuItem<
                                            CreditCurrency>(
                                        value: e,
                                        child: Text("${e.code} (${e.symbol})")))
                                    .toList(),
                                onChanged: (value) {
                                  controller.amountController.clear();
                                  controller.selectedCurrency.value = value;
                                }),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: ListView(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Expanded(
                                child: Card(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 22),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Text("Available Credits",
                                                  style: Get
                                                      .textTheme.titleMedium),
                                              const Spacer(),
                                              SvgPicture.asset(
                                                "assets/icons/coins.svg",
                                                height: 32,
                                                width: 32,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                  controller
                                                          .credit.value?.points
                                                          .toString() ??
                                                      "",
                                                  style: Get
                                                      .textTheme.titleMedium
                                                      ?.copyWith(
                                                          fontWeight:
                                                              FontWeight.bold))
                                            ],
                                          ),
                                          const SizedBox(height: 18),
                                          Form(
                                            key: controller.formKey,
                                            child: CustomTextFormField(
                                              borderRadius: 10,
                                              validator: (value) {
                                                if (value?.nullIfEmpty() ==
                                                    null) {
                                                  return "Please enter the amount";
                                                } else if ((double.tryParse(
                                                            value!) ??
                                                        0) <
                                                    (controller
                                                            .selectedCurrency
                                                            .value
                                                            ?.minimumAmount ??
                                                        0)) {
                                                  return "Minimum Amount is ${controller.selectedCurrency.value?.symbol ?? ""} ${controller.selectedCurrency.value?.minimumAmount?.removeZeros ?? ""}";
                                                }
                                                return null;
                                              },
                                              controller:
                                                  controller.amountController,
                                              decoration: InputDecoration(
                                                  fillColor: Colors.white,
                                                  filled: true,
                                                  isDense: true,
                                                  prefix: Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            right: 8),
                                                    child: Text(controller
                                                            .selectedCurrency
                                                            .value
                                                            ?.symbol ??
                                                        ""),
                                                  ),
                                                  suffixIconConstraints:
                                                      const BoxConstraints(
                                                          maxHeight: 32,
                                                          maxWidth: 32),
                                                  contentPadding:
                                                      const EdgeInsets.symmetric(
                                                          horizontal: 16,
                                                          vertical: 16),
                                                  border: OutlineInputBorder(
                                                      borderSide: BorderSide(
                                                          color: Get.theme
                                                              .primaryColor),
                                                      borderRadius: BorderRadius
                                                          .circular(10)),
                                                  labelText: "Enter Amount",
                                                  labelStyle:
                                                      Theme.of(Get.context!)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.copyWith(
                                                              color: Get
                                                                  .theme
                                                                  .colorScheme
                                                                  .tertiary)),
                                              labelText: "Enter Amount",
                                              labelColor: Get
                                                  .theme.colorScheme.tertiary,
                                              icon: Text(controller
                                                      .selectedCurrency
                                                      .value
                                                      ?.symbol ??
                                                  ""),
                                            ),
                                          ),
                                          const SizedBox(height: 18),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children:
                                                  controller.selectedCurrency
                                                          .value?.topUps
                                                          ?.mapIndexed(
                                                              (index, topUp) =>
                                                                  Expanded(
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        InkWell(
                                                                          onTap:
                                                                              () {
                                                                            controller.amountController.text =
                                                                                topUp.amount?.removeZeros.toString() ?? "";
                                                                          },
                                                                          child:
                                                                              Container(
                                                                            padding:
                                                                                const EdgeInsets.symmetric(vertical: 8),
                                                                            margin: index + 1 == controller.selectedCurrency.value?.topUps?.length
                                                                                ? EdgeInsets.zero
                                                                                : const EdgeInsets.only(right: 16),
                                                                            alignment:
                                                                                Alignment.center,
                                                                            decoration: BoxDecoration(
                                                                                color: controller.selectedAmount.value == topUp.amount ? Get.theme.colorScheme.tertiary.withOpacity(0.05) : null,
                                                                                borderRadius: BorderRadius.circular(10),
                                                                                border: Border.all(width: 1, color: controller.selectedAmount.value == topUp.amount ? Get.theme.colorScheme.tertiary : Colors.black)),
                                                                            child:
                                                                                Text(
                                                                              "${controller.selectedCurrency.value?.symbol ?? ""} ${topUp.amount?.removeZeros}",
                                                                              style: Get.textTheme.titleMedium?.copyWith(color: controller.selectedAmount.value == topUp.amount ? Get.theme.colorScheme.tertiary : null),
                                                                            ),
                                                                          ),
                                                                        ),
                                                                        if (topUp.mostPopular ==
                                                                            true) ...[
                                                                          const SizedBox(
                                                                              height: 4),
                                                                          Text(
                                                                              "Most Popular",
                                                                              style: Get.textTheme.bodySmall?.copyWith(color: Get.theme.colorScheme.tertiary))
                                                                        ]
                                                                      ],
                                                                    ),
                                                                  ))
                                                          .toList() ??
                                                      []),
                                          const SizedBox(height: 18),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(top: 2),
                                                child: Icon(
                                                  Icons.info_outline,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                  child: Text(
                                                      controller
                                                              .selectedCurrency
                                                              .value
                                                              ?.footer ??
                                                          "",
                                                      style: Get
                                                          .textTheme.bodySmall
                                                          ?.copyWith(
                                                              color:
                                                                  Colors.grey)))
                                            ],
                                          )
                                        ],
                                      ),
                                    )),
                              ),
                            ],
                          ),
                          const SizedBox(height: 28),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Credits to add",
                                  style: Get.textTheme.titleMedium),
                              Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/icons/coins.svg",
                                        height: 32,
                                        width: 32,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        ((controller.selectedAmount.value ??
                                                    0) *
                                                (controller
                                                        .selectedCurrency
                                                        .value
                                                        ?.conversionToPoints ??
                                                    1))
                                            .removeZeros
                                            .toString(),
                                        style: Get.textTheme.titleMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                      "${controller.selectedCurrency.value?.symbol ?? ""}1 = ${controller.selectedCurrency.value?.conversionToPoints?.removeZeros ?? ""} Point",
                                      style: Get.textTheme.bodyMedium
                                          ?.copyWith(color: Colors.grey))
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 18),
                          Text("Note :",
                              style: Get.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Get.theme.colorScheme.tertiary)),
                          const SizedBox(height: 12),
                          Column(
                              children: controller.creditsModel?.notes
                                      ?.map((e) => Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 2),
                                                child: Icon(
                                                  Icons.check_circle,
                                                  color: Get.theme.colorScheme
                                                      .tertiary
                                                      .withOpacity(0.9),
                                                  size: 16,
                                                ),
                                              ),
                                              const SizedBox(width: 6),
                                              Expanded(
                                                  child: Text(e,
                                                      style: Get
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                              color: Colors.grey
                                                                  .shade600)))
                                            ],
                                          ))
                                      .toList() ??
                                  []),
                          const SizedBox(height: 64)
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: controller.initiatingPayment.value
                          ? const SizedBox(
                              height: 16,
                              width: 16,
                              child: CircularProgressIndicator())
                          : ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 20)),
                              onPressed: controller.selectedAmount.value == null
                                  ? null
                                  : controller.initiatePayment,
                              child: const Text("Proceed to Add Credits")),
                    )
                  ],
                );
        }));
  }
}

extension removeUnnecessary on double {
  num get removeZeros => this - toInt() == 0.0 ? toInt() : this;
}
