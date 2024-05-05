class VisitsHistoryResponseModel {
  bool? status;
  String? msg;
  List<VisitsHistoryResponseItem>? data;

  VisitsHistoryResponseModel({this.status, this.msg, this.data});

  VisitsHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <VisitsHistoryResponseItem>[];
      json['data'].forEach((v) {
        data!.add(VisitsHistoryResponseItem.fromJson(v));
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

class VisitsHistoryResponseItem {
  String? storeName;
  String? companyName;
  String? fullName;
  int? id;
  String? checkInTime;
  String? checkOutTime;
  String? workingHours;
  int? workingId;
  int? isAvailability;
  int? isPrice;
  int? isSos;
  int? isPlanogram;
  int? isFreshness;
  int? isStock;
  int? isRtv;
  int? isPhoto;

  VisitsHistoryResponseItem(
      {this.storeName,
        this.companyName,
        this.fullName,
        this.id,
        this.checkInTime,
        this.checkOutTime,
        this.workingHours,
        this.workingId,
        this.isAvailability,
        this.isPrice,
        this.isSos,
        this.isPlanogram,
        this.isFreshness,
        this.isStock,
        this.isRtv,
        this.isPhoto});

  VisitsHistoryResponseItem.fromJson(Map<String, dynamic> json) {
    storeName = json['store_name'].toString();
    companyName = json['company_name'].toString();
    fullName = json['full_name'].toString();
    id = json['id'];
    checkInTime = json['check_in_time'].toString();
    checkOutTime = json['check_out_time'].toString();
    workingHours = json['working_hours'].toString();
    workingId = json['working_id'];
    isAvailability = json['is_availability'];
    isPrice = json['is_price'];
    isSos = json['is_sos'];
    isPlanogram = json['is_planogram'];
    isFreshness = json['is_freshness'];
    isStock = json['is_stock'];
    isRtv = json['is_rtv'];
    isPhoto = json['is_photo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['store_name'] = storeName;
    data['company_name'] = companyName;
    data['full_name'] = fullName;
    data['id'] = id;
    data['check_in_time'] = checkInTime;
    data['check_out_time'] = checkOutTime;
    data['working_hours'] = workingHours;
    data['working_id'] = workingId;
    data['is_availability'] = isAvailability;
    data['is_price'] = isPrice;
    data['is_sos'] = isSos;
    data['is_planogram'] = isPlanogram;
    data['is_freshness'] = isFreshness;
    data['is_stock'] = isStock;
    data['is_rtv'] = isRtv;
    data['is_photo'] = isPhoto;
    return data;
  }
}