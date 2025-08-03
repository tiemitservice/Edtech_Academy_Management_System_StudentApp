import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LanguageController extends GetxController {
  final _storage = GetStorage();
  late final RxBool isEnglish;

  @override
  void onInit() {
    super.onInit();
    final savedValue = _storage.read('isEnglish') ?? true;
    // Use the constructor directly for a more robust fix
    isEnglish = RxBool(savedValue);
  }

  void toggleLanguage(bool value) {
    isEnglish.value = value;
    _storage.write('isEnglish', value);
    if (isEnglish.value) {
      Get.updateLocale(const Locale('en'));
    } else {
      Get.updateLocale(const Locale('km'));
    }
  }
}