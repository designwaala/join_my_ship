import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_cli/extensions/string.dart';
import 'package:join_mp_ship/app/data/models/job_model.dart';
import 'package:join_mp_ship/utils/user_details.dart';

class CrewReferralJobCard extends StatelessWidget {
  final Job job;
  const CrewReferralJobCard({Key? key, required this.job}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(128),
                child: CachedNetworkImage(
                  height: 50,
                  width: 50,
                  imageUrl: job.employerDetails?.profilePic ?? "",
                  fit: BoxFit.cover,
                ),
              ),
              10.horizontalSpace,
              Flexible(
                flex: 15,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${job.employerDetails?.firstName ?? ""} ${job.employerDetails?.lastName ?? ""}",
                      overflow: TextOverflow.ellipsis,
                      style: Get.textTheme.bodyMedium
                          ?.copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text("Referred Job",
                        style: Get.textTheme.bodySmall
                            ?.copyWith(color: Colors.grey.shade700))
                  ],
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            children: [
              8.verticalSpace,
              Column(
                children: [
                  Row(
                    children: [
                      Text("Rank: ", style: Get.textTheme.bodyLarge),
                      Text(
                        UserStates.instance.ranks
                                ?.firstWhereOrNull((rank) =>
                                    job.jobRankWithWages?.firstOrNull
                                        ?.rankNumber ==
                                    rank.id)
                                ?.name ??
                            "",
                        style: Get.textTheme.bodyMedium?.copyWith(fontSize: 14),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Text("Vessel IMO No: ", style: Get.textTheme.bodyLarge),
                      Text(
                        job.vesselIMO?.toString() ?? "",
                        style: Get.textTheme.bodyMedium?.copyWith(fontSize: 14),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text("Vessel Type: ",
                            maxLines: 2, style: Get.textTheme.bodyLarge),
                      ),
                      Text(UserStates.instance.vessels?.vessels
                              ?.map((e) => e.subVessels ?? [])
                              .expand((e) => e)
                              .firstWhereOrNull((e) => e.id == job.vesselId)
                              ?.name ??
                          ""),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text("Flag: ",
                            maxLines: 2, style: Get.textTheme.bodyLarge),
                      ),
                      Text(UserStates.instance.flags
                              ?.firstWhereOrNull((flag) => job.flag == flag.id)
                              ?.flagCode ??
                          ""),
                    ],
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Text("Joining Port: ",
                            maxLines: 2, style: Get.textTheme.bodyLarge),
                      ),
                      Text(job.joiningPort ?? ""),
                    ],
                  ),
                  Row(
                    children: [
                      Text("Tentative Joining Date: ",
                          style: Get.textTheme.bodyLarge),
                      Text(
                        job.tentativeJoining!,
                        style: Get.textTheme.bodyMedium?.copyWith(fontSize: 14),
                      )
                    ],
                  ),
                ],
              ),
              if (job.jobCoc != null && job.jobCoc?.isNotEmpty == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "COC Requirements: ",
                      style: Get.textTheme.bodyLarge,
                    ),
                    Text(job.jobCoc
                            ?.map(
                              (e) =>
                                  "${UserStates.instance.cocs?.firstWhereOrNull((coc) => coc.id == e.cocId)?.name ?? ""} |",
                            )
                            .toString()
                            .removeAll("(")
                            .removeAll(",")
                            .removeAll(" |)") ??
                        ""),
                  ],
                ),
              if (job.jobCop != null && job.jobCop?.isNotEmpty == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "COP Requirements: ",
                      style: Get.textTheme.bodyLarge,
                    ),
                    Text(job.jobCop
                            ?.map(
                              (e) =>
                                  "${UserStates.instance.cops?.firstWhereOrNull((cop) => cop.id == e.copId)?.name ?? ""} |",
                            )
                            .toString()
                            .removeAll("(")
                            .removeAll(",")
                            .removeAll(" |)") ??
                        ""),
                  ],
                ),
              if (job.jobWatchKeeping != null &&
                  job.jobWatchKeeping?.isNotEmpty == true)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Watch-Keeping Requirements: ",
                      style: Get.textTheme.bodyLarge,
                    ),
                    Text(job.jobWatchKeeping
                            ?.map(
                              (e) =>
                                  "${UserStates.instance.watchKeepings?.firstWhereOrNull((watchKeeping) => watchKeeping.id == e.watchKeepingId)?.name ?? ""} |",
                            )
                            .toString()
                            .removeAll("(")
                            .removeAll(",")
                            .removeAll(" |)") ??
                        ""),
                  ],
                ),
              if (job.mailInfo == true)
                Row(
                  children: [
                    Text(
                      "Email: ",
                      style: Get.textTheme.bodyLarge,
                    ),
                    Text(
                      job.employerDetails?.email ?? "",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              if (job.numberInfo == true)
                Row(
                  children: [
                    Text(
                      "Mobile: ",
                      style: Get.textTheme.bodyLarge,
                    ),
                    Text(
                      job.employerDetails?.number ?? "",
                      style: const TextStyle(fontSize: 13),
                    ),
                  ],
                ),
              4.verticalSpace,
              10.verticalSpace,
            ],
          ),
        )
      ],
    );
  }
}
