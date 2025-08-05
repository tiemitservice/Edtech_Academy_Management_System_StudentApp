import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:get/get.dart';

class AddressService {
  late List<dynamic> _provinces;
  late List<dynamic> _districts;
  late List<dynamic> _communes;
  late List<dynamic> _villages;

  Future<void> loadAddressData() async {
    final provinceString =
        await rootBundle.loadString('assets/data/province.json');
    _provinces = json.decode(provinceString);

    final districtString =
        await rootBundle.loadString('assets/data/district.json');
    _districts = json.decode(districtString);

    final communeString =
        await rootBundle.loadString('assets/data/commune.json');
    _communes = json.decode(communeString);

    final villageString =
        await rootBundle.loadString('assets/data/village.json');
    _villages = json.decode(villageString);
  }

  String getProvinceName(String provinceCode) {
    final province = _provinces.firstWhere(
      (p) => p['properties']['ADMIN_ID1'] == provinceCode,
      orElse: () => {
        'properties': {'NAME1': 'N/A', 'NAME_ENG1': 'N/A'}
      },
    );
    final isKhmer = Get.locale?.languageCode == 'km';
    return isKhmer
        ? province['properties']['NAME1']
        : province['properties']['NAME_ENG1'];
  }

  String getDistrictName(String districtCode) {
    final district = _districts.firstWhere(
      (d) => d['properties']['ADMIN_ID2'] == districtCode,
      orElse: () => {
        'properties': {'NAME2': 'N/A', 'NAME_ENG2': 'N/A'}
      },
    );
    final isKhmer = Get.locale?.languageCode == 'km';
    return isKhmer
        ? district['properties']['NAME2']
        : district['properties']['NAME_ENG2'];
  }

  String getCommuneName(String communeCode) {
    final commune = _communes.firstWhere(
      (c) => c['properties']['ADMIN_ID3'] == communeCode,
      orElse: () => {
        'properties': {'NAME3': 'N/A', 'NAME_ENG3': 'N/A'}
      },
    );
    final isKhmer = Get.locale?.languageCode == 'km';
    return isKhmer
        ? commune['properties']['NAME3']
        : commune['properties']['NAME_ENG3'];
  }

  String getVillageName(String villageCode) {
    final village = _villages.firstWhere(
      (v) => v['properties']['ADMIN_ID'] == villageCode,
      orElse: () => {
        'properties': {'NAME': 'N/A', 'NAME_ENG': 'N/A'}
      },
    );
    final isKhmer = Get.locale?.languageCode == 'km';
    return isKhmer
        ? village['properties']['NAME']
        : village['properties']['NAME_ENG'];
  }

  String getFamilyProvinceName(String provinceCode) {
    return getProvinceName(provinceCode);
  }

  String getFamilyDistrictName(String districtCode) {
    return getDistrictName(districtCode);
  }

  String getFamilyCommuneName(String communeCode) {
    return getCommuneName(communeCode);
  }

  String getFamilyVillageName(String villageCode) {
    return getVillageName(villageCode);
  }
}
