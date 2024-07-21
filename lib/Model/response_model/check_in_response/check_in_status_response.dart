class CheckInSuccessResponseModel {
  bool? status;
  String? msg;
  List<CheckInStatusItem>? data;

  CheckInSuccessResponseModel({this.status, this.msg, this.data});

  CheckInSuccessResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CheckInStatusItem>[];
      json['data'].forEach((v) {
        data!.add(CheckInStatusItem.fromJson(v));
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

class CheckInStatusItem {
  int? id;
  int? elId;
  String? comment;
  String? checkinGps;

  CheckInStatusItem({this.id, this.elId, this.comment, this.checkinGps});

  CheckInStatusItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    elId = json['el_id'];
    comment = json['comment'].toString();
    checkinGps = json['checkin_gps'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['el_id'] = elId;
    data['comment'] = comment;
    data['checkin_gps'] = checkinGps;
    return data;
  }
}