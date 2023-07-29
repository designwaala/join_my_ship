import 'package:collection/collection.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/app/modules/job_post/controllers/job_post_controller.dart';
import 'package:join_mp_ship/utils/styles.dart';
import 'package:join_mp_ship/widgets/custom_elevated_button.dart';
import 'package:join_mp_ship/widgets/custom_text_form_field.dart';
import 'package:join_mp_ship/utils/extensions/date_time.dart';
import 'package:join_mp_ship/widgets/dropdown_decoration.dart';

class JobPostStep1 extends GetView<JobPostController> {
  const JobPostStep1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  24.verticalSpace,
                  Text("Post a new job", style: Get.textTheme.titleLarge),
                  28.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text("Tentative Joining",
                            style: Get.textTheme.titleSmall
                                ?.copyWith(color: Get.theme.primaryColor)),
                      ),
                      20.horizontalSpace,
                      Expanded(
                          flex: 3,
                          child: CustomTextFormField(
                            isDate: true,
                            hintText: "dd-mm-yyyy",
                            onTap: () async {
                              DateTime? selectedDateTime = await showDatePicker(
                                  context: Get.context!,
                                  initialDate: DateTime.parse("1990-01-01"),
                                  firstDate: DateTime.parse("1950-01-01"),
                                  lastDate: DateTime.now());
                              controller.tentativeJoining.text =
                                  selectedDateTime?.getServerDate() ?? "";
                            },
                            icon: const Icon(
                              Icons.calendar_month,
                            ),
                            controller: controller.tentativeJoining,
                          ))
                    ],
                  ),
                  if (controller.step1Misses
                      .contains(Step1Miss.tentativeJoining)) ...[
                    8.verticalSpace,
                    Text(Step1Miss.tentativeJoining.errorMessage,
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Colors.red)),
                  ],
                  12.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text("Vessel Type",
                            style: Get.textTheme.titleSmall
                                ?.copyWith(color: Get.theme.primaryColor)),
                      ),
                      20.horizontalSpace,
                      Expanded(
                        flex: 3,
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<int>(
                            value: controller.recordVesselType.value,
                            isExpanded: true,
                            style: Get.textTheme.bodySmall,
                            items: controller.vesselList?.vessels
                                    ?.map((e) => [
                                          DropdownMenuItem<int>(
                                              enabled: false,
                                              child: Text(
                                                e.vesselName ?? "",
                                                maxLines: 1,
                                                style: Get.textTheme.titleSmall
                                                    ?.copyWith(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                overflow: TextOverflow.ellipsis,
                                              )),
                                          ...?e.subVessels?.map((e) =>
                                              DropdownMenuItem<int>(
                                                  value: e.id,
                                                  child: Text(e.name ?? "",
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: Get
                                                          .textTheme.bodyMedium
                                                          ?.copyWith(
                                                              fontSize: 12))))
                                        ])
                                    .expand((element) => element)
                                    .toList() ??
                                [],

                            // .map((e) => DropdownMenuItem(
                            //     value: e.name,
                            //     child: Text(e.name ?? "",
                            //         style: Get.textTheme.titleMedium)))
                            // .toList(),
                            onChanged: (value) {
                              controller.recordVesselType.value = value;
                            },
                            hint: const Text("Select Vessel"),
                            buttonStyleData: ButtonStyleData(
                                height: 40,
                                width: 200,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(64),
                                  border:
                                      Border.all(color: Get.theme.primaryColor),
                                )),
                          ),
                        ),
                      )
                    ],
                  ),
                  if (controller.step1Misses
                      .contains(Step1Miss.vesselType)) ...[
                    8.verticalSpace,
                    Text(Step1Miss.vesselType.errorMessage,
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Colors.red)),
                  ],
                  12.verticalSpace,
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text("GRT",
                            style: Get.textTheme.titleSmall
                                ?.copyWith(color: Get.theme.primaryColor)),
                      ),
                      20.horizontalSpace,
                      Expanded(
                          flex: 3,
                          child: CustomTextFormField(
                            hintText: "Enter GRT",
                            controller: controller.grt,
                          ))
                    ],
                  ),
                  if (controller.step1Misses.contains(Step1Miss.grt)) ...[
                    8.verticalSpace,
                    Text(Step1Miss.grt.errorMessage,
                        style: Get.textTheme.bodyMedium
                            ?.copyWith(color: Colors.red)),
                  ],
                  18.verticalSpace,
                  Text("Crew Requirements",
                      style: Get.textTheme.titleSmall
                          ?.copyWith(color: Get.theme.primaryColor)),
                  18.verticalSpace,
                  ...CrewRequirements.values.map((e) => Obx(() {
                        RxList<MapEntry<Rank?, double>> rankWithWages;
                        switch (e) {
                          case CrewRequirements.deckNavigation:
                            rankWithWages = controller.deckRankWithWages;
                            break;
                          case CrewRequirements.engine:
                            rankWithWages = controller.engineRankWithWages;
                            break;
                          case CrewRequirements.galley:
                            rankWithWages = controller.galleyRankWithWages;
                            break;
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                    value:
                                        controller.crewRequirements.contains(e),
                                    onChanged: (_) {
                                      if (controller.crewRequirements
                                          .contains(e)) {
                                        controller.crewRequirements.remove(e);
                                      } else {
                                        controller.crewRequirements.add(e);
                                      }
                                    }),
                                Text(e.name, style: Get.textTheme.bodyMedium)
                              ],
                            ),
                            ...rankWithWages.map((MapEntry<Rank?, double>
                                    rankWithWage) =>
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 8),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<Rank>(
                                            value: rankWithWage.key,
                                            isExpanded: true,
                                            style: Get.textTheme.bodySmall,
                                            items: controller.ranks
                                                .where((p0) =>
                                                    rankWithWages.none((e) =>
                                                        e.key?.id == p0.id &&
                                                        e.key?.id !=
                                                            rankWithWage
                                                                .key?.id))
                                                .map((e) =>
                                                    DropdownMenuItem<Rank>(
                                                        value: e,
                                                        child: Text(
                                                            e.name ?? "",
                                                            maxLines: 1,
                                                            overflow: TextOverflow
                                                                .ellipsis,
                                                            style: Get.textTheme
                                                                .titleMedium)))
                                                .toList(),
                                            onChanged: (Rank? newRank) {
                                              int index = rankWithWages
                                                  .indexWhere((e) =>
                                                      e.key?.id ==
                                                      rankWithWage.key?.id);
                                              MapEntry<Rank?, double> e =
                                                  rankWithWages.removeAt(index);
                                              rankWithWages.insert(index,
                                                  MapEntry(newRank, e.value));
                                              /* double wage = 0.0;
                                    controller.rankWithWages
                                      ..removeWhere((key, value) {
                                        if (key?.id == rank?.id) {
                                          wage = value;
                                          return true;
                                        }
                                        return false;
                                      })
                                      ..addAll({newRank: wage}); */
                                            },
                                            hint: const Text("Select Rank"),
                                            buttonStyleData: ButtonStyleData(
                                                height: 40,
                                                width: 200,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8),
                                                decoration:
                                                    DropdownDecoration()),
                                          ),
                                        ),
                                      ),
                                      16.horizontalSpace,
                                      Expanded(
                                          child: Builder(builder: (context) {
                                        TextEditingController wage =
                                            TextEditingController();
                                        wage.text = rankWithWages
                                                .firstWhereOrNull((e) =>
                                                    e.key?.id ==
                                                    rankWithWage.key?.id)
                                                ?.value
                                                .toString() ??
                                            "";
                                        return CustomTextFormField(
                                          controller: wage,
                                          onChanged: (value) {
                                            int index =
                                                rankWithWages.indexWhere((e) =>
                                                    e.key?.id ==
                                                    rankWithWage.key?.id);

                                            rankWithWages
                                              ..removeAt(index)
                                              ..insert(
                                                  index,
                                                  MapEntry(rankWithWage.key,
                                                      double.parse(value)));
                                          },
                                        );
                                      })),
                                      IconButton(
                                          onPressed: () {
                                            rankWithWages.removeWhere(
                                                (MapEntry<Rank?, double> e) =>
                                                    e.key?.id ==
                                                    rankWithWage.key?.id);
                                          },
                                          padding: EdgeInsets.zero,
                                          icon: const Icon(Icons.remove))
                                    ],
                                  ),
                                )),
                            // 12.verticalSpace,
                            if (controller.crewRequirements.contains(e))
                              TextButton(
                                  onPressed: () {
                                    rankWithWages
                                        .add(const MapEntry(null, 0.0));
                                  },
                                  child: const Text("Add new rank +")),
                            if ((e == CrewRequirements.deckNavigation &&
                                    controller.step1Misses
                                        .contains(Step1Miss.deckRank)) ||
                                (e == CrewRequirements.engine &&
                                    controller.step1Misses
                                        .contains(Step1Miss.engineRank)) ||
                                (e == CrewRequirements.galley &&
                                    controller.step1Misses
                                        .contains(Step1Miss.galleyRank)))
                              Text(
                                  controller.step1Misses
                                          .firstWhereOrNull((e) => [
                                                Step1Miss.deckRank,
                                                Step1Miss.engineRank,
                                                Step1Miss.galleyRank
                                              ].contains(e))
                                          ?.errorMessage ??
                                      "",
                                  style: Get.textTheme.bodyMedium
                                      ?.copyWith(color: Colors.red)),
                          ],
                        );
                      })),
                  32.verticalSpace,
                  Center(
                    child: SizedBox(
                      width: 232,
                      child: CustomElevatedButon(
                          onPressed: () {
                            controller.validateStep1();
                          },
                          child: const Text("SAVE & CONTINUE")),
                    ),
                  ),
                  32.verticalSpace,
                ],
              ),
            );
    });
  }
}

class TitledTextFormField extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  const TitledTextFormField(
      {Key? key, required this.title, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title,
            style: Get.textTheme.titleSmall
                ?.copyWith(color: Get.theme.primaryColor)),
        20.horizontalSpace,
        Expanded(
            child: CustomTextFormField(
          controller: controller,
        ))
      ],
    );
  }
}
