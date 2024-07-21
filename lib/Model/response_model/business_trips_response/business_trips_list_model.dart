class BusinessTripsListModel {
  bool? status;
  String? msg;
  List<BusinessTrips>? data;

  BusinessTripsListModel({this.status, this.msg, this.data});

  BusinessTripsListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <BusinessTrips>[];
      json['data'].forEach((v) {
        data!.add(BusinessTrips.fromJson(v));
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

class BusinessTrips {
  int? id;
  int? elId;
  String? fromCity;
  String? toCity;
  String? reason;
  String? voucher;
  String? isApproved;
  String? approvedBy;

  BusinessTrips(
      {this.id,
        this.elId,
        this.fromCity,
        this.toCity,
        this.reason,
        this.voucher,
        this.isApproved,
        this.approvedBy});

  BusinessTrips.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    elId = json['el_id'];
    fromCity = json['from_city'] ?? "";
    toCity = json['to_city'] ?? "";
    reason = json['reason'].toString() ?? "";
    voucher = json['voucher'].toString();
    isApproved = json['is_approved'];
    approvedBy = json['approved_by'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['el_id'] = elId;
    data['from_city'] = fromCity;
    data['to_city'] = toCity;
    data['reason'] = reason;
    data['voucher'] = voucher;
    data['is_approved'] = isApproved;
    data['approved_by'] = approvedBy;
    return data;
  }
}