import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_mp_ship/widgets/circular_progress_indicator_widget.dart';

import '../controllers/employer_job_applications_controller.dart';

class EmployerJobApplicationsView
    extends GetView<EmployerJobApplicationsController> {
  const EmployerJobApplicationsView({Key? key}) : super(key: key);

  // _showBottomSheet(BuildContext context) {
  //   RxInt shortlisted = RxInt(-1);
  //   String rank = "";
  //   String gender = "";
  //   showModalBottomSheet(
  //     backgroundColor: Colors.transparent,
  //     context: context,
  //     isDismissible: false,
  //     builder: (context) => Obx(
  //       () => Container(
  //         height: 400,
  //         decoration: const BoxDecoration(
  //           color: Colors.white,
  //           borderRadius: BorderRadius.only(
  //             topLeft: Radius.circular(35),
  //             topRight: Radius.circular(35),
  //           ),
  //         ),
  //         child: Column(
  //           children: [
  //             20.verticalSpace,
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 35),
  //               child: Column(
  //                 children: [
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.center,
  //                     children: [
  //                       Column(
  //                         children: [
  //                           Container(
  //                             height: 4,
  //                             width: 35,
  //                             decoration: BoxDecoration(
  //                               color: Colors.grey,
  //                               borderRadius: BorderRadius.circular(5),
  //                             ),
  //                           ),
  //                           8.verticalSpace,
  //                           Text(
  //                             "Filter",
  //                             style: Get.textTheme.titleLarge
  //                                 ?.copyWith(fontSize: 22),
  //                           ),
  //                         ],
  //                       ),
  //                     ],
  //                   ),
  //                   14.verticalSpace,
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //                     children: [
  //                       TextButton(
  //                         style: TextButton.styleFrom(
  //                           foregroundColor: shortlisted.value == 1
  //                               ? Colors.blue
  //                               : Colors.black,
  //                           backgroundColor: shortlisted.value == 1
  //                               ? const Color.fromARGB(255, 227, 231, 249)
  //                               : Colors.white,
  //                           side: const BorderSide(
  //                               width: 1.5, color: Colors.blue),
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 15, vertical: 10),
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(20)),
  //                         ),
  //                         onPressed: () {
  //                           shortlisted.value = shortlisted.value == 1 ? -1 : 1;
  //                         },
  //                         child: Row(
  //                           children: [
  //                             if (shortlisted.value == 1)
  //                               const Icon(
  //                                 Icons.cancel,
  //                                 size: 20,
  //                               ),
  //                             if (shortlisted.value == 1) 3.horizontalSpace,
  //                             const Text(
  //                               "Shortlisted",
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       1.horizontalSpace,
  //                       TextButton(
  //                         style: TextButton.styleFrom(
  //                           foregroundColor: shortlisted.value == 0
  //                               ? Colors.blue
  //                               : Colors.black,
  //                           backgroundColor: shortlisted.value == 0
  //                               ? const Color.fromARGB(255, 227, 231, 249)
  //                               : Colors.white,
  //                           side: const BorderSide(
  //                               width: 1.5, color: Colors.blue),
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: 15, vertical: 10),
  //                           shape: RoundedRectangleBorder(
  //                               borderRadius: BorderRadius.circular(20)),
  //                         ),
  //                         onPressed: () {
  //                           shortlisted.value = shortlisted.value == 0 ? -1 : 0;
  //                         },
  //                         child: Row(
  //                           children: [
  //                             if (shortlisted.value == 0)
  //                               const Icon(
  //                                 Icons.cancel,
  //                                 size: 20,
  //                               ),
  //                             if (shortlisted.value == 0) 3.horizontalSpace,
  //                             const Text(
  //                               "Not Shortlisted",
  //                               style: TextStyle(
  //                                 fontSize: 12,
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                   15.verticalSpace,
  //                   Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [
  //                       Text(
  //                         "Rank",
  //                         style: Get.textTheme.bodyLarge
  //                             ?.copyWith(color: Colors.blue, fontSize: 18),
  //                       ),
  //                       Container(
  //                         padding: const EdgeInsets.all(0),
  //                         decoration: BoxDecoration(
  //                             border:
  //                                 Border.all(width: 1.5, color: Colors.blue),
  //                             borderRadius: BorderRadius.circular(20)),
  //                         // // shape: RoundedRectangleBorder(),
  //                         // style: TextButton.styleFrom(
  //                         //   side: const BorderSide(
  //                         //       width: 1.5, color: Colors.blue),
  //                         //   padding: const EdgeInsets.symmetric(
  //                         //       horizontal: 20, vertical: 10),
  //                         //   shape: RoundedRectangleBorder(
  //                         //       borderRadius: BorderRadius.circular(20)),
  //                         // ),
  //                         // child: DropdownButtonHideUnderline(
  //                         //   child: DropdownButton2<String>(
  //                         //     value: null,
  //                         //     isDense: true,
  //                         //     isExpanded: true,
  //                         //     hint: const Text(
  //                         //       "Select Rank",
  //                         //       style: TextStyle(fontSize: 14),
  //                         //     ),
  //                         //     onChanged: (value) {
  //                         //       rank.value = value ?? "";
  //                         //     },
  //                         //     items: controller.rankTypes.values
  //                         //         .map((value) => DropdownMenuItem<String>(
  //                         //             child: Text(value)))
  //                         //         .toList(),
  //                         //   ),
  //                         // ),
  //                       ),
  //                     ],
  //                   ),
  //                   const Row(
  //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                     children: [Text("Gender"), Text("data")],
  //                   ),
  //                 ],
  //               ),
  //             ),
  //             20.verticalSpace,
  //             const Divider(
  //               height: 1,
  //               color: Colors.black38,
  //             ),
  //             20.verticalSpace,
  //             Padding(
  //               padding: const EdgeInsets.symmetric(horizontal: 40),
  //               child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.end,
  //                 children: [
  //                   TextButton(
  //                     style: TextButton.styleFrom(
  //                       side: const BorderSide(width: 1.5, color: Colors.blue),
  //                       padding: const EdgeInsets.symmetric(
  //                           horizontal: 20, vertical: 10),
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(20)),
  //                     ),
  //                     onPressed: () {
  //                       controller.filterOn.value = false;
  //                       Get.back();
  //                     },
  //                     child: const Text("Cancel"),
  //                   ),
  //                   10.horizontalSpace,
  //                   TextButton(
  //                     style: TextButton.styleFrom(
  //                       backgroundColor: Colors.blue,
  //                       foregroundColor: Colors.white,
  //                       padding: const EdgeInsets.symmetric(
  //                           horizontal: 25, vertical: 10),
  //                       shape: RoundedRectangleBorder(
  //                           borderRadius: BorderRadius.circular(25)),
  //                     ),
  //                     onPressed: () {
  //                       if (shortlisted.value != -1) {
  //                         controller.filterOptions['shortlisted'] =
  //                             shortlisted.value;
  //                       }
  //                       if (rank.isNotEmpty) {
  //                         controller.filterOptions['rank'] = rank;
  //                       }
  //                       if (gender.isNotEmpty) {
  //                         controller.filterOptions['gender'] = gender;
  //                       }
  //                       controller.filterOn.value = true;
  //                       Get.back();
  //                     },
  //                     child: const Text("Save"),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   ).then((value) {
  //     debugPrint("ModalBottomSheet Closed");
  //   });
  // }

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
                            // _showBottomSheet(context);
                          } else {
                            controller.filterOn.value = false;
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
                        children: List.generate(
                          controller.filterOptions.length,
                          (index) => Chip(
                            avatar: IconButton(
                              icon: const Icon(Icons.cancel),
                              onPressed: () {
                                controller.filterOptions
                                    .update("shortlisted", (value) => false);
                                // controller.filterOptions['shortlisted'] = false;
                              },
                            ),
                            label: Text(
                              controller.filterOptions.keys.elementAt(index) ==
                                      "shortlisted"
                                  ? controller.filterOptions.values
                                              .elementAt(index) ==
                                          1
                                      ? "Shortlisted"
                                      : "Not Shortlisted"
                                  : controller.filterOptions.values
                                      .elementAt(index),
                            ),
                          ),
                        ),
                        // TextButton(
                        //   style: TextButton.styleFrom(
                        //     foregroundColor: controller.filterOptions
                        //                 .value.shortlisted ==
                        //             1
                        //         ? Colors.blue
                        //         : Colors.black,
                        //     backgroundColor: controller.filterOptions
                        //                 .value.shortlisted ==
                        //             1
                        //         ? const Color.fromARGB(255, 227, 231, 249)
                        //         : Colors.white,
                        //     side: const BorderSide(
                        //         width: 1.5, color: Colors.blue),
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 15, vertical: 10),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20)),
                        //   ),
                        //   onPressed: () {},
                        //   child: Row(
                        //     children: [
                        //       if (controller
                        //               .filterOptions.value.shortlisted ==
                        //           1)
                        //         const Icon(
                        //           Icons.cancel,
                        //           size: 20,
                        //         ),
                        //       if (controller
                        //               .filterOptions.value.shortlisted ==
                        //           1)
                        //         3.horizontalSpace,
                        //       const Text(
                        //         "Shortlisted",
                        //         style: TextStyle(
                        //           fontSize: 12,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        // 20.horizontalSpace,
                        // TextButton(
                        //   style: TextButton.styleFrom(
                        //     foregroundColor: controller.filterOptions
                        //                 .value.shortlisted ==
                        //             0
                        //         ? Colors.blue
                        //         : Colors.black,
                        //     backgroundColor: controller.filterOptions
                        //                 .value.shortlisted ==
                        //             0
                        //         ? const Color.fromARGB(255, 227, 231, 249)
                        //         : Colors.white,
                        //     side: const BorderSide(
                        //         width: 1.5, color: Colors.blue),
                        //     padding: const EdgeInsets.symmetric(
                        //         horizontal: 15, vertical: 10),
                        //     shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20)),
                        //   ),
                        //   onPressed: () {},
                        //   child: Row(
                        //     children: [
                        //       if (controller
                        //               .filterOptions.value.shortlisted ==
                        //           0)
                        //         const Icon(
                        //           Icons.cancel,
                        //           size: 20,
                        //         ),
                        //       if (controller
                        //               .filterOptions.value.shortlisted ==
                        //           0)
                        //         3.horizontalSpace,
                        //       const Text(
                        //         "Not Shortlisted",
                        //         style: TextStyle(
                        //           fontSize: 12,
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        // ),
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
                              const Text("ABCD"),
                              // Text(controller.rankTypes[
                              //         controller.jobApplications[index].rank] ??
                              //     ""),
                              Expanded(
                                child: Row(
                                  children: [
                                    Text(
                                      "COC: ",
                                      style: Get.textTheme.bodyLarge,
                                    ),
                                    // const Spacer(),
                                    const Text("India")
                                    // Text(controller.rankTypes[
                                    //         controller.jobApplications[index].coc] ??
                                    //     ""),
                                  ],
                                ),
                              )
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
