// To parse this JSON data, do
//
//     final getAttendenceRequestModel = getAttendenceRequestModelFromJson(jsonString);

import 'dart:convert';

GetAttendenceRequestModel getAttendenceRequestModelFromJson(String str) =>
    GetAttendenceRequestModel.fromJson(json.decode(str));

String getAttendenceRequestModelToJson(GetAttendenceRequestModel data) =>
    json.encode(data.toJson());

class GetAttendenceRequestModel {
  String elId;

  GetAttendenceRequestModel({
    required this.elId,
  });

  factory GetAttendenceRequestModel.fromJson(Map<String, dynamic> json) =>
      GetAttendenceRequestModel(
        elId: json["el_id"],
      );

  Map<String, dynamic> toJson() => {
        "el_id": elId,
      };
}
