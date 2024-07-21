import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:c_supervisor/Model/response_model/licence_model.dart';
import 'package:c_supervisor/Network/api_urls.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LicenseProvider with ChangeNotifier {
  //BASE URL FOR LIVE AND DEV
  static String basepath = "";
  static String imageBasePath = "";
  static String gcsPath = "";
  static String bucketName = "";
  String apiVersion = "CSupervisorv2/";
  bool isLicense = false;

  bool get isLicenseGet {
    return isLicense;
  }

  // String get getBasePath {
  //   return basepath;
  // }

  Future<Map<String, dynamic>> getAppLicence(String licenceKey) async {
    try {
      final url = Uri.parse(
          "https://cstore.catalist-me.com/${apiVersion}getClientLicense"
          // "https://cstoredev.catalist-me.com/CSupervisorv1/getClientLicense"
          );

      final response = await http.post(url, body: {
        "license_key": licenceKey
      }).timeout(const Duration(seconds: 45));
      // print(url);
      if (response.body.isNotEmpty) {
        final responseData = jsonDecode(response.body);
        // print(responseData);
        if (responseData["data"].isNotEmpty) {
          final extractedData = responseData["data"][0];
          // ApplicationURLs().setBaseUrl(extractedData["base_url"]);
          basepath = extractedData["base_url"] + apiVersion;
          imageBasePath = extractedData["image_base_url"];
          gcsPath = extractedData["gcs_path"];
          bucketName = extractedData["bucket_name"];
          storeLicenseAtLocal(LicenseModel.fromJson(extractedData));
          isLicense = true;
          notifyListeners();
          // print(responseData);
          return responseData;
        }
        return {"status": false, "msg": "Invalid license key", "data": []};
      }
      return {"status": false, "msg": "Something went wrong", "data": []};
    } on TimeoutException {
      throw "There is something wrong with your internet connection";
    } on SocketException {
      throw 'Please turn on your data or connect wifi network';
    } catch (error) {
      rethrow;
    }
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
    basepath = "$basepath$apiVersion";
    imageBasePath = imageBasePath;

    gcsPath = extractedLicense["gcs_path"] as String;
    bucketName = extractedLicense["bucket_name"] as String;
    // print("++++++++++++++++++");
    // print(extractedLicense["gcs_path"] as String);

    // print("The base path is  ");
    // print(basepath);
    // print(bucketName);
    // print("the image base path is");
    // print(imageBasePath);

    isLicense = true;
    notifyListeners();
    return true;
  }
}
