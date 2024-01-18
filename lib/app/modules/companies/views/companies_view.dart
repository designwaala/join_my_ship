import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:get/get.dart';
import 'package:join_my_ship/app/modules/company_detail/controllers/company_detail_controller.dart';
import 'package:join_my_ship/app/routes/app_pages.dart';

import '../controllers/companies_controller.dart';
import 'package:collection/collection.dart';

class CompaniesView extends GetView<CompaniesController> {
  const CompaniesView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          title: const Text('Companies'),
          centerTitle: true,
        ),
        body: Obx(() {
          return controller.isLoading.value
              ? Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.only(top: 16),
                  children: controller.companies
                      .map(
                        (company) => InkWell(
                          onTap: () {
                            Get.toNamed(Routes.COMPANY_DETAIL,
                                arguments:
                                    CompanyDetailArguments(employer: company));
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            margin: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.r),
                                color: Colors.white,
                                boxShadow: const [
                                  BoxShadow(
                                      color: Color.fromRGBO(0, 0, 0, 0.1),
                                      blurRadius: 8,
                                      spreadRadius: 2)
                                ]),
                            child: Row(
                              children: [
                                Container(
                                  height: 50.h,
                                  width: 50.h,
                                  decoration: BoxDecoration(
                                      color: Color(Random().nextInt(0xffffffff))
                                          .withAlpha(0xff),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Center(
                                      child: Text(
                                          company.companyName
                                                  ?.split("")
                                                  .firstOrNull ??
                                              "",
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.white))),
                                ),
                                20.horizontalSpace,
                                Flexible(
                                  child: Text(company.companyName ?? "",
                                      maxLines: 2,
                                      style: Get.textTheme.bodyMedium?.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList());
        }));
  }
}
