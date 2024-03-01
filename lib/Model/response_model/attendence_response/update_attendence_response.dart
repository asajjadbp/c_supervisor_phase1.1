// To parse this JSON data, do
//
//     final updateAttendenceResponseModel = updateAttendenceResponseModelFromJson(jsonString);

import 'dart:convert';

UpdateAttendenceResponseModel updateAttendenceResponseModelFromJson(
        String str) =>
    UpdateAttendenceResponseModel.fromJson(json.decode(str));

String updateAttendenceResponseModelToJson(
        UpdateAttendenceResponseModel data) =>
    json.encode(data.toJson());

class UpdateAttendenceResponseModel {
  bool status;
  String msg;
  List<dynamic> data;

  UpdateAttendenceResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory UpdateAttendenceResponseModel.fromJson(Map<String, dynamic> json) =>
      UpdateAttendenceResponseModel(
        status: json["status"],
        msg: json["msg"],
        data: List<dynamic>.from(json["data"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x)),
      };
}
