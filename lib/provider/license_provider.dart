import 'dart:convert';

import 'package:c_supervisor/Model/response_model/licence_model.dart';
import 'package:c_supervisor/Network/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LicenseProvider with ChangeNotifier {
  //BASE URL FOR LIVE AND DEV
  static String basePathForLive = "https://cstore.catalist-me.com/CSupervisor/";
  static String basePathForDev = "https://cstoredev.catalist-me.com/";
  static String basepath = "";
  static String imageBasePath = "";
  bool isLicense = false;

  bool get isLicenseGet {
    return isLicense;
  }

  // String get getBasePath {
  //   return basepath;
  // }

  Future<Map<String, dynamic>> getAppLicence(String licenceKey) async {
    final url = Uri.parse(
        "https://cstoredev.catalist-me.com/CSupervisor/getClientLicense");

    final response = await http.post(url, body: {"license_key": licenceKey});
    print(url);
    if (response.body.isNotEmpty) {
      final responseData = jsonDecode(response.body);
      print(responseData);
      if (responseData["data"].isNotEmpty) {
        final extractedData = responseData["data"][0];
        // ApplicationURLs().setBaseUrl(extractedData["base_url"]);
        basepath = extractedData["base_url"] + "CSupervisor/";
        imageBasePath = extractedData["image_base_url"];
        storeLicenseAtLocal(LicenseModel.fromJson(extractedData));
        isLicense = true;
        notifyListeners();
        print(responseData);
        return responseData;
      }
      return {"status": false, "msg": "Invalid license key", "data": []};
    }
    return {"status": false, "msg": "Something went wrong", "data": []};
  }

  Future<void> storeLicenseAtLocal(LicenseModel licenseData) async {
    final prefs = await SharedPreferences.getInstance();
    final userLicense = licenseModelToJson(licenseData);
    prefs.setString("UserLicense", userLicense);
  }

  Future<bool> fetchLicenseAtLocal() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("UserLicense")) {
      return false;
    }
    final extractedLicense =
        json.decode(prefs.getString('UserLicense')!) as Map<String, dynamic>;
    // ApplicationURLs().setBaseUrl(extractedLicense["base_url"] as String);
    basepath = extractedLicense["base_url"] as String;
    imageBasePath = extractedLicense["image_base_url"] as String;
    basepath = "${basepath}CSupervisor/";
    imageBasePath = "${imageBasePath}";

    print("The base path is  ");
    print(basepath);
    print("the image base path is");
    print(imageBasePath);

    isLicense = true;
    notifyListeners();
    return true;
  }
}
