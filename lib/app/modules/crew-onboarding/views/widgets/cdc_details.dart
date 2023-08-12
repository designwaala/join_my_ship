import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/user_details_model.dart';
import 'package:join_mp_ship/app/modules/crew-onboarding/controllers/crew_onboarding_controller.dart';
import 'package:join_mp_ship/utils/extensions/toast_extension.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
import 'package:join_mp_ship/utils/extensions/date_time.dart';
import 'package:join_mp_ship/widgets/toasts/toast.dart';

class CDCDetails extends GetView<CrewOnboardingController> {
  const CDCDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(child: Text("Issuing Authority")),
              20.horizontalSpace,
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2<String>(
                    value: null,
                    isExpanded: true,
                    style: Get.textTheme.bodySmall,
                    items: controller.cdcIssuingAuthorities
                        .map((e) => e.name)
                        .map((e) => DropdownMenuItem(
                            value: e,
                            onTap: () {
                              controller.cdcIssuingAuthority.value =
                                  IssuingAuthority(issuingAuthority: e);
                            },
                            child: Obx(() {
                              return Row(
                                children: [
                                  Radio<String?>(
                                      value: e,
                                      groupValue: controller.cdcIssuingAuthority
                                          .value?.issuingAuthority,
                                      onChanged: (_) {
                                        controller.cdcIssuingAuthority.value =
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
              .contains(Step2FormMiss.cdcIssuingAuthority))
            Align(
                alignment: Alignment.centerLeft,
                child: Text("Please select this field",
                    style: Get.textTheme.bodySmall
                        ?.copyWith(color: Get.theme.colorScheme.error))),
          16.verticalSpace,
          if (controller.cdcIssuingAuthority.value != null) ...[
            Row(
              children: [
                Expanded(
                  child: controller
                              .cdcIssuingAuthority.value?.issuingAuthority ==
                          "Others"
                      ? Builder(builder: (context) {
                          TextEditingController custom =
                              TextEditingController();
                          custom.text = controller
                                  .cdcIssuingAuthority.value?.customName ??
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
                              controller.cdcIssuingAuthority.value?.customName =
                                  value;
                            },
                          );
                        })
                      : Text(controller
                              .cdcIssuingAuthority.value?.issuingAuthority ??
                          ""),
                ),
                20.horizontalSpace,
                Expanded(
                  child: CustomTextFormField(
                      controller: controller.cdcSeamanNumberValidTill,
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
                            initialDate: DateTime.parse("1990-01-01"),
                            firstDate: DateTime.parse("1950-01-01"),
                            lastDate: DateTime.parse("2050-01-01"));
                        controller.cdcSeamanNumberValidTill.text =
                            selectedDateTime?.getServerDate() ?? "";
                      },
                      hintText: "Valid Till",
                      icon: const Icon(
                        Icons.calendar_month,
                      )),
                )
              ],
            ),
            20.verticalSpace,
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: CustomTextFormField(
                    controller: controller.cdcSeamanNumber,
                    validator: (value) {
                      if (value == null || value.isEmpty == true) {
                        return "Please enter this field";
                      }
                      return null;
                    },
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp(r'^[a-zA-Z0-9]+'))
                    ],
                    hintText: "CDC Number"),
              ),
            ],
          ),
        ],
      );
    });
  }
}
