// To parse this JSON data, do
//
//     final getAttendenceResponseModel = getAttendenceResponseModelFromJson(jsonString);

import 'dart:convert';

GetAttendenceResponseModel getAttendenceResponseModelFromJson(String str) =>
    GetAttendenceResponseModel.fromJson(json.decode(str));

String getAttendenceResponseModelToJson(GetAttendenceResponseModel data) =>
    json.encode(data.toJson());

class GetAttendenceResponseModel {
  bool status;
  String msg;
  Data data;

  GetAttendenceResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory GetAttendenceResponseModel.fromJson(Map<String, dynamic> json) =>
      GetAttendenceResponseModel(
        status: json["status"],
        msg: json["msg"],
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": data.toJson(),
      };
}

class Data {
  AttendenceSummary summary;
  List<GetAttendenceList> data;

  Data({
    required this.summary,
    required this.data,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        summary: AttendenceSummary.fromJson(json["summary"]),
        data: List<GetAttendenceList>.from(
            json["data"].map((x) => GetAttendenceList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "summary": summary.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class GetAttendenceList {
  int userRecordId;
  String fullName;
  String firstName;
  String lastName;
  int id;
  String tmrPic;
  String checkInTime;
  String attendancePreviousValue;
  int isPresent;
  // int updatedByEl;

  GetAttendenceList(
      {required this.userRecordId,
      required this.fullName,
      required this.firstName,
      required this.lastName,
      required this.id,
      required this.tmrPic,
      required this.checkInTime,
      required this.isPresent,
      required this.attendancePreviousValue
      // required this.updatedByEl,
      });

  factory GetAttendenceList.fromJson(Map<String, dynamic> json) =>
      GetAttendenceList(
          userRecordId: json["user_record_id"],
          fullName: json["full_name"].toString(),
          firstName: json["first_name"].toString(),
          lastName: json["last_name"].toString(),
          id: json["id"],
          tmrPic: json["tmr_pic"],
          checkInTime: json["check_in_time"] ?? "",
          isPresent: json["is_present"],
          attendancePreviousValue: json["att"]
          // updatedByEl: json["updated_by_el"],
          );

  Map<String, dynamic> toJson() => {
        "user_record_id": userRecordId,
        "full_name": fullName,
        "first_name": firstName,
        "last_name": lastName,
        "id": id,
        "tmr_pic": tmrPic.toString(),
        "check_in_time": checkInTime.toString(),
        "is_present": isPresent,
        "att": attendancePreviousValue
        // "updated_by_el": updatedByEl,
      };
}

class AttendenceSummary {
  int total;
  int present;
  int absent;
  int sick;
  int vacation;
  int late;

  AttendenceSummary(
      {required this.total,
      required this.present,
      required this.absent,
      required this.sick,
      required this.vacation,
      required this.late});

  factory AttendenceSummary.fromJson(Map<String, dynamic> json) =>
      AttendenceSummary(
          total: json["total"],
          present: json["present"],
          absent: json["absent"],
          sick: json["sick"],
          vacation: json["vacation"],
          late: json["late"]);

  Map<String, dynamic> toJson() => {
        "total": total,
        "present": present,
        "absent": absent,
        "sick": sick,
        "vacation": vacation,
        "late": late
      };
}
