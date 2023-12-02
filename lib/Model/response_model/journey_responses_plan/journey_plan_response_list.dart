class JourneyPlanResponseModel {
  bool? status;
  String? msg;
  List<JourneyResponseListItem>? data;

  JourneyPlanResponseModel({this.status, this.msg, this.data});

  JourneyPlanResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <JourneyResponseListItem>[];
      json['data'].forEach((v) {
        data!.add(new JourneyResponseListItem.fromJson(v));
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

class JourneyResponseListItem {
  int? workingId;
  int? tmrId;
  String? workingDate;
  String? storeName;
  int? storeId;
  String? gcode;
  int? companyName;
  int? companyId;
  int? userId;
  String? checkIn;
  String? checkInGps;
  String? checkOut;
  int? checkInPhoto;
  String? checkoutGps;
  int? workingMinutes;
  String? visitStatus;

  JourneyResponseListItem(
      {this.workingId,
        this.tmrId,
        this.workingDate,
        this.storeName,
        this.storeId,
        this.gcode,
        this.companyName,
        this.companyId,
        this.userId,
        this.checkIn,
        this.checkInGps,
        this.checkOut,
        this.checkInPhoto,
        this.checkoutGps,
        this.workingMinutes,
        this.visitStatus});

  JourneyResponseListItem.fromJson(Map<String, dynamic> json) {
    workingId = json['working_id'];
    tmrId = json['tmr_id'];
    workingDate = json['working_date'];
    storeName = json['store_name'];
    storeId = json['store_id'];
    gcode = json['gcode'];
    companyName = json['company_name'];
    companyId = json['company_id'];
    userId = json['user_id'];
    checkIn = json['check_in'];
    checkInGps = json['check_in_gps'];
    checkOut = json['check_out'];
    checkInPhoto = json['check_in_photo'];
    checkoutGps = json['checkout_gps'];
    workingMinutes = json['working_minutes'];
    visitStatus = json['visit_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['working_id'] = workingId;
    data['tmr_id'] = tmrId;
    data['working_date'] = workingDate;
    data['store_name'] = storeName;
    data['store_id'] = storeId;
    data['gcode'] = gcode;
    data['company_name'] = companyName;
    data['company_id'] = companyId;
    data['user_id'] = userId;
    data['check_in'] = checkIn;
    data['check_in_gps'] = checkInGps;
    data['check_out'] = checkOut;
    data['check_in_photo'] = checkInPhoto;
    data['checkout_gps'] = checkoutGps;
    data['working_minutes'] = workingMinutes;
    data['visit_status'] = visitStatus;
    return data;
  }
}