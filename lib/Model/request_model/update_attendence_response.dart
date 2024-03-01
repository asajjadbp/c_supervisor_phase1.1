// To parse this JSON data, do
//
//     final updateAttendenceRequestModel = updateAttendenceRequestModelFromJson(jsonString);

import 'dart:convert';

UpdateAttendenceRequestModel updateAttendenceRequestModelFromJson(String str) =>
    UpdateAttendenceRequestModel.fromJson(json.decode(str));

String updateAttendenceRequestModelToJson(UpdateAttendenceRequestModel data) =>
    json.encode(data.toJson());

class UpdateAttendenceRequestModel {
  final String elId;
  final String userRecordId;
  final String isPresent;

  UpdateAttendenceRequestModel({
    required this.elId,
    required this.userRecordId,
    required this.isPresent,
  });

  factory UpdateAttendenceRequestModel.fromJson(Map<String, dynamic> json) =>
      UpdateAttendenceRequestModel(
        elId: json["el_id"],
        userRecordId: json["user_record_id"],
        isPresent: json["is_present"],
      );

  Map<String, dynamic> toJson() => {
        "el_id": elId,
        "user_record_id": userRecordId,
        "is_leave": isPresent,
      };
}
