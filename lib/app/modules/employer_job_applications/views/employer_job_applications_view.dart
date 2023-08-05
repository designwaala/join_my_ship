import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/app/data/models/ranks_model.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator_widget.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import '../controllers/employer_job_applications_controller.dart';

class EmployerJobApplicationsView
    extends GetView<EmployerJobApplicationsController> {
  const EmployerJobApplicationsView({Key? key}) : super(key: key);

  _showBottomSheet(BuildContext context) {
    RxInt shortlisted = RxInt(-1);
    String rank = "";
    String gender = "";
    showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      isDismissible: false,
      builder: (context) => Obx(
        () => Container(
          height: 400,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(35),
              topRight: Radius.circular(35),
            ),
          ),
          child: Column(
            children: [
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              height: 4,
                              width: 35,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                            8.verticalSpace,
                            Text(
                              "Filter",
                              style: Get.textTheme.titleLarge
                                  ?.copyWith(fontSize: 22),
                            ),
                          ],
                        ),
                      ],
                    ),
                    15.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: shortlisted.value == 1
                                ? Colors.blue
                                : Colors.black,
                            backgroundColor: shortlisted.value == 1
                                ? const Color.fromARGB(255, 227, 231, 249)
                                : Colors.white,
                            side: const BorderSide(
                                width: 1.5, color: Colors.blue),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            shortlisted.value = shortlisted.value == 1 ? -1 : 1;
                          },
                          child: Row(
                            children: [
                              if (shortlisted.value == 1)
                                const Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                              if (shortlisted.value == 1) 3.horizontalSpace,
                              const Text(
                                "Shortlisted",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        1.horizontalSpace,
                        TextButton(
                          style: TextButton.styleFrom(
                            foregroundColor: shortlisted.value == 0
                                ? Colors.blue
                                : Colors.black,
                            backgroundColor: shortlisted.value == 0
                                ? const Color.fromARGB(255, 227, 231, 249)
                                : Colors.white,
                            side: const BorderSide(
                                width: 1.5, color: Colors.blue),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 10),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                          ),
                          onPressed: () {
                            shortlisted.value = shortlisted.value == 0 ? -1 : 0;
                          },
                          child: Row(
                            children: [
                              if (shortlisted.value == 0)
                                const Icon(
                                  Icons.cancel,
                                  size: 20,
                                ),
                              if (shortlisted.value == 0) 3.horizontalSpace,
                              const Text(
                                "Not Shortlisted",
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Rank",
                          style: Get.textTheme.bodyLarge
                              ?.copyWith(color: Colors.blue, fontSize: 18),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Flexible(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<Rank>(
                                iconStyleData: const IconStyleData(
                                    icon: Icon(Icons.keyboard_arrow_down)),
                                hint: const Text(
                                  "Select Rank",
                                  style: TextStyle(fontSize: 14),
                                ),
                                buttonStyleData: const ButtonStyleData(
                                    height: 40, width: 130),
                                dropdownStyleData: const DropdownStyleData(
                                    maxHeight: 200, width: 130),
                                onChanged: (value) {
                                  controller.filters['rank'] = value;
                                },
                                items: controller.ranks
                                    .map(
                                      (value) => DropdownMenuItem<Rank>(
                                        value: value,
                                        child: Flexible(
                                          child: Text(
                                            value.name ?? "",
                                            maxLines: 2,
                                          ),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    20.verticalSpace,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Gender",
                          style: Get.textTheme.bodyLarge
                              ?.copyWith(color: Colors.blue, fontSize: 18),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1, color: Colors.blue),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Flexible(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton2<String>(
                                iconStyleData: const IconStyleData(
                                    icon: Icon(Icons.keyboard_arrow_down)),
                                hint: const Text(
                                  "Select ",
                                  style: TextStyle(fontSize: 14),
                                ),
                                buttonStyleData: const ButtonStyleData(
                                    height: 40, width: 130),
                                dropdownStyleData: const DropdownStyleData(
                                    maxHeight: 200, width: 130),
                                onChanged: (value) {
                                  controller.filters['gender'] = value;
                                },
                                items: ["Male", "Female"]
                                    .map(
                                      (value) => DropdownMenuItem<String>(
                                        value: value,
                                        onTap: () {
                                          gender = value;
                                        },
                                        child: Text(
                                          value,
                                          maxLines: 2,
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              30.verticalSpace,
              const Divider(
                height: 1,
                color: Colors.black38,
              ),
              20.verticalSpace,
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        side: const BorderSide(width: 1.5, color: Colors.blue),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        controller.filterOn.value = false;
                        Get.back();
                      },
                      child: const Text("Cancel"),
                    ),
                    10.horizontalSpace,
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                      onPressed: () {
                        if (shortlisted.value != -1) {
                          controller.filters['shortlisted'] = shortlisted.value;
                        }
                        if (rank.isNotEmpty) {
                          controller.filters['rank'] = rank;
                        }
                        if (gender.isNotEmpty) {
                          controller.filters['gender'] = gender;
                        }
                        controller.filterOn.value = true;
                        controller.applyFilters();
                        Get.back();
                      },
                      child: const Text("Save"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).then((value) {
      debugPrint("ModalBottomSheet Closed");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text('Applications',
            style: Get.theme.textTheme.headlineSmall?.copyWith(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600)),
        leading: InkWell(
          onTap: Get.back,
          child: Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
                color: Color(0xFFF3F3F3), shape: BoxShape.circle),
            child: const Icon(
              Icons.keyboard_backspace_rounded,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const CircularProgressIndicatorWidget()
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  5.verticalSpace,
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListTile(
                      title: Text(
                        "Job Applications",
                        style: Get.textTheme.bodyLarge?.copyWith(fontSize: 19),
                      ),
                      subtitle: const Text("8 Applications Received"),
                      trailing: IconButton(
                        onPressed: () {
                          if (!controller.filterOn.value) {
                            _showBottomSheet(context);
                          } else {
                            controller.filterOn.value = false;
                            controller.removeFilters();
                          }
                        },
                        icon: ImageIcon(
                          const AssetImage("assets/icons/equalizer.png"),
                          size: 24,
                          color: controller.filterOn.value
                              ? Colors.blue
                              : Colors.black,
                        ),
                      ),
                    ),
                  ),
                  if (controller.filterOn.value)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        children: List.generate(
                          controller.filters.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: TextButton.icon(
                              icon: const Icon(
                                Icons.cancel,
                                size: 18,
                                color: Colors.blue,
                              ),
                              style: TextButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 6),
                                backgroundColor:
                                    const Color.fromARGB(255, 227, 231, 249),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  side: const BorderSide(
                                      width: 1.5, color: Colors.blue),
                                ),
                              ),
                              onPressed: () {
                                controller.filters.removeWhere((key, value) =>
                                    controller.filters.keys.elementAt(index) ==
                                    key);
                                controller.applyFilters();
                              },
                              label: Text(
                                controller.filters.keys.elementAt(index) ==
                                        "shortlisted"
                                    ? controller.filters.values
                                                .elementAt(index) ==
                                            1
                                        ? "Shortlisted"
                                        : "Not Shortlisted"
                                    : controller.filters.values
                                        .elementAt(index),
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.blue),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 8),
                      itemCount: controller.jobApplications.length,
                      itemBuilder: (context, index) => Card(
                        elevation: 3,
                        shadowColor: const Color.fromARGB(255, 237, 233, 241),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 0),
                          leading: Image.network(
                            controller.jobApplications[index].profilePic!,
                            height: 55,
                            width: 55,
                          ),
                          title: Text(
                            controller.jobApplications[index].name!,
                            style:
                                Get.textTheme.bodyLarge?.copyWith(fontSize: 16),
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Master",
                                style: Get.textTheme.bodyMedium,
                              ),
                              RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: "COC: ",
                                        style: Get.textTheme.bodyMedium
                                            ?.copyWith(
                                                fontWeight: FontWeight.bold)),
                                    const TextSpan(text: "National"),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: ImageIcon(
                              AssetImage(
                                  controller.jobApplications[index].shortlisted!
                                      ? 'assets/icons/bookmark_filled.png'
                                      : 'assets/icons/bookmark_outlined.png'),
                              color:
                                  controller.jobApplications[index].shortlisted!
                                      ? Colors.blue
                                      : Colors.black,
                              size:
                                  controller.jobApplications[index].shortlisted!
                                      ? 30
                                      : 29,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
