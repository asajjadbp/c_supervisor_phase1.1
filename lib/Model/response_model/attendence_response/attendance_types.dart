// To parse this JSON data, do
//
//     final attendanceTypeResponseModel = attendanceTypeResponseModelFromJson(jsonString);

import 'dart:convert';

AttendanceTypeResponseModel attendanceTypeResponseModelFromJson(String str) =>
    AttendanceTypeResponseModel.fromJson(json.decode(str));

String attendanceTypeResponseModelToJson(AttendanceTypeResponseModel data) =>
    json.encode(data.toJson());

class AttendanceTypeResponseModel {
  bool status;
  String msg;
  List<AttendanceTypeData> attendanceData;

  AttendanceTypeResponseModel({
    required this.status,
    required this.msg,
    required this.attendanceData,
  });

  factory AttendanceTypeResponseModel.fromJson(Map<String, dynamic> json) =>
      AttendanceTypeResponseModel(
        status: json["status"],
        msg: json["msg"],
        attendanceData: List<AttendanceTypeData>.from(
            json["data"].map((x) => AttendanceTypeData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(attendanceData.map((x) => x.toJson())),
      };
}

class AttendanceTypeData {
  String attDescription;
  String attValue;

  AttendanceTypeData({
    required this.attDescription,
    required this.attValue,
  });

  factory AttendanceTypeData.fromJson(Map<String, dynamic> json) =>
      AttendanceTypeData(
        attDescription: json["att_description"],
        attValue: json["att_value"],
      );

  Map<String, dynamic> toJson() => {
        "att_description": attDescription,
        "att_value": attValue,
      };
}
