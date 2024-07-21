// class JourneyPlanResponseModel {
//   bool? status;
//   String? msg;
//   List<JourneyResponseListItem>? data;
//
//   JourneyPlanResponseModel({this.status, this.msg, this.data});
//
//   JourneyPlanResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     msg = json['msg'];
//     if (json['data'] != null) {
//       data = <JourneyResponseListItem>[];
//       json['data'].forEach((v) {
//         data!.add(new JourneyResponseListItem.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['msg'] = msg;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class JourneyResponseListItem {
//   int? workingId;
//   int? tmrId;
//   String? workingDate;
//   String? storeName;
//   int? storeId;
//   String? gcode;
//   int? companyName;
//   int? companyId;
//   int? userId;
//   String? checkIn;
//   String? checkInGps;
//   String? checkOut;
//   int? checkInPhoto;
//   String? checkoutGps;
//   int? workingMinutes;
//   String? visitStatus;
//
//   JourneyResponseListItem(
//       {this.workingId,
//         this.tmrId,
//         this.workingDate,
//         this.storeName,
//         this.storeId,
//         this.gcode,
//         this.companyName,
//         this.companyId,
//         this.userId,
//         this.checkIn,
//         this.checkInGps,
//         this.checkOut,
//         this.checkInPhoto,
//         this.checkoutGps,
//         this.workingMinutes,
//         this.visitStatus});
//
//   JourneyResponseListItem.fromJson(Map<String, dynamic> json) {
//     workingId = json['working_id'];
//     tmrId = json['tmr_id'];
//     workingDate = json['working_date'];
//     storeName = json['store_name'];
//     storeId = json['store_id'];
//     gcode = json['gcode'];
//     companyName = json['company_name'];
//     companyId = json['company_id'];
//     userId = json['user_id'];
//     checkIn = json['check_in'];
//     checkInGps = json['check_in_gps'];
//     checkOut = json['check_out'];
//     checkInPhoto = json['check_in_photo'];
//     checkoutGps = json['checkout_gps'];
//     workingMinutes = json['working_minutes'];
//     visitStatus = json['visit_status'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['working_id'] = workingId;
//     data['tmr_id'] = tmrId;
//     data['working_date'] = workingDate;
//     data['store_name'] = storeName;
//     data['store_id'] = storeId;
//     data['gcode'] = gcode;
//     data['company_name'] = companyName;
//     data['company_id'] = companyId;
//     data['user_id'] = userId;
//     data['check_in'] = checkIn;
//     data['check_in_gps'] = checkInGps;
//     data['check_out'] = checkOut;
//     data['check_in_photo'] = checkInPhoto;
//     data['checkout_gps'] = checkoutGps;
//     data['working_minutes'] = workingMinutes;
//     data['visit_status'] = visitStatus;
//     return data;
//   }
// }


class JourneyPlanResponseModel {
  bool? status;
  String? msg;
  JourneyResponseListItem? data;

  JourneyPlanResponseModel({this.status, this.msg, this.data});

  JourneyPlanResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    data = json['data'] != null ? JourneyResponseListItem.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class JourneyResponseListItem {
  List<JourneyResponseListItemDetails>? planned;
  List<JourneyResponseListItemDetails>? special;

  JourneyResponseListItem({this.planned, this.special});

  JourneyResponseListItem.fromJson(Map<String, dynamic> json) {
    if (json['planned'] != null) {
      planned = <JourneyResponseListItemDetails>[];
      json['planned'].forEach((v) {
        planned!.add(JourneyResponseListItemDetails.fromJson(v));
      });
    }
    if (json['special'] != null) {
      special = <JourneyResponseListItemDetails>[];
      json['special'].forEach((v) {
        special!.add(JourneyResponseListItemDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (planned != null) {
      data['planned'] = planned!.map((v) => v.toJson()).toList();
    }
    if (special != null) {
      data['special'] = special!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class JourneyResponseListItemDetails {
  int? workingId;
  int? tmrId;
  String? tmrName;
  String? workingDate;
  String? storeName;
  String? chainName;
  int? storeId;
  String? gcode;
  int? elId;
  String? checkIn;
  String? checkOut;
  String? checkinGps;
  String? checkoutGps;
  int? visitStatus;

  JourneyResponseListItemDetails(
      {this.workingId,
        this.tmrId,
        this.tmrName,
        this.workingDate,
        this.storeName,
        this.storeId,
        this.gcode,
        this.elId,
        this.checkIn,
        this.checkOut,
        this.checkinGps,
        this.checkoutGps,
        this.chainName,
        this.visitStatus});

  JourneyResponseListItemDetails.fromJson(Map<String, dynamic> json) {
    workingId = json['working_id'];
    tmrId = json['tmr_id'];
    tmrName = json['tmr_name'].toString();
    workingDate = json['working_date'].toString();
    storeName = json['store_name'].toString();
    storeId = json['store_id'];
    gcode = json['gcode'].toString();
    elId = json['el_id'];
    checkIn = json['check_in'].toString();
    checkOut = json['check_out'].toString();
    checkinGps = json['checkin_gps'].toString();
    checkoutGps = json['checkout_gps'].toString();
    chainName = json['chain_name'].toString();
    visitStatus = json['visit_status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['working_id'] = workingId;
    data['tmr_id'] = tmrId;
    data['tmr_name'] = tmrName;
    data['working_date'] = workingDate;
    data['store_name'] = storeName;
    data['store_id'] = storeId;
    data['gcode'] = gcode;
    data['el_id'] = elId;
    data['check_in'] = checkIn;
    data['check_out'] = checkOut;
    data['checkin_gps'] = checkinGps;
    data['checkout_gps'] = checkoutGps;
    data['chain_name'] = chainName;
    data['visit_status'] = visitStatus;
    return data;
  }
}