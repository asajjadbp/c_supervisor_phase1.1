// To parse this JSON data, do
//
//     final licenseModel = licenseModelFromJson(jsonString);

import 'dart:convert';

LicenseModel licenseModelFromJson(String str) =>
    LicenseModel.fromJson(json.decode(str));

String licenseModelToJson(LicenseModel data) => json.encode(data.toJson());

class LicenseModel {
  int id;
  String licenseKey;
  String client;
  String baseUrl;
  String imageBaseUrl;
  String updatedAt;
  String active;

  LicenseModel({
    required this.id,
    required this.licenseKey,
    required this.client,
    required this.baseUrl,
    required this.imageBaseUrl,
    required this.updatedAt,
    required this.active,
  });

  factory LicenseModel.fromJson(Map<String, dynamic> json) => LicenseModel(
        id: json["id"],
        licenseKey: json["license_key"],
        client: json["client"],
        baseUrl: json["base_url"],
        imageBaseUrl: json["image_base_url"],
        updatedAt: json["updated_at"],
        active: json["active"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "license_key": licenseKey,
        "client": client,
        "base_url": baseUrl,
        "image_base_url": imageBaseUrl,
        "updated_at": updatedAt,
        "active": active,
      };
}
