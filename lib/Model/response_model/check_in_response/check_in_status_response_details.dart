class CheckInStatusResponseModel {
  bool? status;
  String? msg;
  List<CheckInStatusDetailsItem>? data;

  CheckInStatusResponseModel({this.status, this.msg, this.data});

  CheckInStatusResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CheckInStatusDetailsItem>[];
      json['data'].forEach((v) {
        data!.add(CheckInStatusDetailsItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CheckInStatusDetailsItem {
  String? id;
  String? elId;
  String? workingDate;
  String? checkinGps;
  String? checkoutGps;
  String? imageName;
  String? comment;
  String? checkinTime;
  String? checkoutTime;
  String? workingMinutes;
  bool? checkinStatus;
  bool? checkoutStatus;

  CheckInStatusDetailsItem(
      {this.id,
        this.elId,
        this.workingDate,
        this.checkinGps,
        this.checkoutGps,
        this.imageName,
        this.comment,
        this.checkinTime,
        this.checkoutTime,
        this.workingMinutes,
        this.checkinStatus,
        this.checkoutStatus});

  CheckInStatusDetailsItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    elId = json['el_id'].toString();
    workingDate = json['working_date'].toString();
    checkinGps = json['checkin_gps'].toString();
    checkoutGps = json['checkout_gps'].toString();
    imageName = json['image_name'].toString();
    comment = json['comment'].toString();
    checkinTime = json['checkin_time'].toString();
    checkoutTime = json['checkout_time'].toString();
    workingMinutes = json['working_minutes'].toString();
    checkinStatus = json['checkin_status'];
    checkoutStatus = json['checkout_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['el_id'] = elId;
    data['working_date'] = workingDate;
    data['checkin_gps'] = checkinGps;
    data['checkout_gps'] = checkoutGps;
    data['image_name'] = imageName;
    data['comment'] = comment;
    data['checkin_time'] = checkinTime;
    data['checkout_time'] = checkoutTime;
    data['working_minutes'] = workingMinutes;
    data['checkin_status'] = checkinStatus;
    data['checkout_status'] = checkoutStatus;
    return data;
  }
}