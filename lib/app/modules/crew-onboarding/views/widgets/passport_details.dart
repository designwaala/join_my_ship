import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
import 'package:join_mp_ship/utils/extensions/date_time.dart';

class PassportDetails extends GetView<CrewOnboardingController> {
  const PassportDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          Row(
            children: [
              const Expanded(child: Text("Issuing Authority")),
              20.horizontalSpace,
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: null,
                    isExpanded: true,
                    style: Get.textTheme.bodySmall,
                    items: controller.passportIssuingAuthorities
                        .map((e) => e.name)
                        .map((e) => DropdownMenuItem(
                            value: e,
                            onTap: () {
                              controller.passportIssuingAuthority.value =
                                  IssuingAuthority(issuingAuthority: e);
                            },
                            child: Obx(() {
                              return Row(
                                children: [
                                  Radio<String?>(
                                      value: e,
                                      groupValue: controller
                                          .passportIssuingAuthority
                                          .value
                                          ?.issuingAuthority,
                                      onChanged: (_) {
                                        controller.passportIssuingAuthority
                                                .value =
                                            IssuingAuthority(
                                                issuingAuthority: e);
                                      }),
                                  Text(e ?? "", style: Get.textTheme.titleMedium),
                                ],
                              );
                            })))
                        .toList(),
                    onChanged: (value) {},
                    hint: const Text("Select"),
                    buttonStyleData: ButtonStyleData(
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(64),
                          border: Border.all(color: Get.theme.primaryColor),
                        )),
                  ),
                ),
              ),
            ],
          ),
          if (controller.step2FormMisses
              .contains(Step2FormMiss.passportIssuingAuthority))
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Please select this field",
                    style: Get.textTheme.bodySmall
                        ?.copyWith(color: Get.theme.colorScheme.error))),
          20.verticalSpace,
          if (controller.passportIssuingAuthority.value != null) ...[
            Row(
              children: [
                Expanded(
                    child: controller.passportIssuingAuthority.value
                                ?.issuingAuthority ==
                            "Others"
                        ? Builder(builder: (context) {
                            TextEditingController custom =
                                TextEditingController();
                            custom.text = controller.passportIssuingAuthority
                                    .value?.customName ??
                                "";
                            return CustomTextFormField(
                              hintText: "Issuing Authority",
                              controller: custom,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter Issuing Authority";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                controller.passportIssuingAuthority.value
                                    ?.customName = value;
                              },
                            );
                          })
                        : Text(controller.passportIssuingAuthority.value
                                ?.issuingAuthority ??
                            "")),
                20.horizontalSpace,
                Expanded(
                  child: CustomTextFormField(
                      controller: controller.passportValidTill,
                      validator: (value) {
                        if (value == null || value.isEmpty == true) {
                          return "Please enter this field";
                        }
                        return null;
                      },
                      isDate: true,
                      onTap: () async {
                        DateTime? selectedDateTime = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.parse("2050-01-01"));

                        controller.passportValidTill.text =
                            selectedDateTime?.getServerDate() ?? "";
                      },
                      hintText: "Valid Till",
                      icon: const Icon(
                        Icons.calendar_month,
                      )),
                ),
              ],
            ),
            20.verticalSpace,
          ],
          CustomTextFormField(
              controller: controller.passportNumber,
              validator: (value) {
                if (value == null || value.isEmpty == true) {
                  return "Please enter this field";
                }
                return null;
              },
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z0-9,-/]+'))
              ],
              hintText: "Passport Number"),
        ],
      );
    });
  }
}
