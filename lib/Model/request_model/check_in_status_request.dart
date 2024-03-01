class CheckInRequestModel {
  String? elId;

  CheckInRequestModel({this.elId});

  CheckInRequestModel.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    return data;
  }
}

class CheckInStatusUpdateRequestModel {
  String? elId;
  String? checkInGps;
  String? comment;

  CheckInStatusUpdateRequestModel({this.elId,this.checkInGps,this.comment});

  CheckInStatusUpdateRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    checkInGps = json['checkin_gps'];
    comment = json['comment'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['checkin_gps'] = checkInGps!;
    data['comment'] = comment!;
    return data;
  }
}

class CheckOutStatusUpdateRequestModel {
  String? elId;
  String? checkOutGps;
  String? id;

  CheckOutStatusUpdateRequestModel({this.elId,this.checkOutGps,this.id});

  CheckOutStatusUpdateRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    checkOutGps = json['checkout_gps'];
    id = json['id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['checkout_gps'] = checkOutGps!;
    data['id'] = id!;
    return data;
  }
}