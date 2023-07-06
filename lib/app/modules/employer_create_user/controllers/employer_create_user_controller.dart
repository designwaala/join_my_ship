import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../data/models/country_model.dart';
import '../../../data/models/state_model.dart';

class EmployerCreateUserController extends GetxController {
  //TODO: Implement EmployerCreateUserController
  Rxn<StateModel> state = Rxn();
  Rxn<Country> country = Rxn();
  List<Country> countries = [];
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController designationController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController addressLine1Controller = TextEditingController();
  TextEditingController addressLine2Controller = TextEditingController();
  TextEditingController zipCodeController = TextEditingController();
final Rxn<XFile> pickedImage = Rxn();
  final ImagePicker imagePicker = ImagePicker();
  RxnString uploadedImagePath = RxnString();
  RxnString uploadedResumePath = RxnString();
  RxList<StateModel> states = RxList.empty();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }
Future<void> pickSource() async {
    return showDialog(
        context: Get.context!,
        builder: (context) => AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Pick Image from"),
                  IconButton(onPressed: Get.back, icon: Icon(Icons.close))
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actionsPadding: EdgeInsets.symmetric(vertical: 16),
              titlePadding: EdgeInsets.only(left: 16, right: 16, top: 16),
              actions: [
                ElevatedButton(
                    onPressed: () async {
                      pickedImage.value = await imagePicker.pickImage(
                          source: ImageSource.gallery);
                      Get.back();
                    },
                    child: Text("Gallery")),
                // Spacer(),
                ElevatedButton(
                    onPressed: () async {
                      Get.back();
                      pickedImage.value = await imagePicker.pickImage(
                          source: ImageSource.camera);
                    },
                    child: Text("Image"))
              ],
            ));
  }
  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  void increment() => count.value++;
}
