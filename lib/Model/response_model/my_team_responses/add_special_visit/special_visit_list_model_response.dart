class SpecialVisitListResponseModel {
  bool? status;
  String? msg;
  List<SpecialVisitListItem>? data;

  SpecialVisitListResponseModel({this.status, this.msg, this.data});

  SpecialVisitListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <SpecialVisitListItem>[];
      json['data'].forEach((v) {
        data!.add(SpecialVisitListItem.fromJson(v));
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

class SpecialVisitListItem {
  String? companyName;
  String? id;
  int? companyId;
  String? region;
  String? store;
  String? city;
  String? chain;
  String? channel;
  String? visitDate;
  String? visitTime;
  String? addedBy;
  String? reason;
  String? tmr;
  int? tmrId;
  int? storeId;

  SpecialVisitListItem(
      {this.companyName,
        this.id,
        this.companyId,
        this.region,
        this.store,
        this.city,
        this.chain,
        this.channel,
        this.visitDate,
        this.visitTime,
        this.addedBy,
        this.reason,
        this.tmr,
        this.tmrId,
        this.storeId});

  SpecialVisitListItem.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name'];
    id = json['id'].toString();
    companyId = json['company_id'];
    region = json['region'];
    store = json['store'];
    city = json['city'];
    chain = json['chain'];
    channel = json['channel'];
    visitDate = json['visit-date'];
    visitTime = json['visit-time'];
    addedBy = json['added-by'];
    reason = json['reason'];
    tmr = json['tmr'];
    tmrId = json['tmr_id'];
    storeId = json['store_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_name'] = companyName;
    data['id'] = id;
    data['company_id'] = companyId;
    data['region'] = region;
    data['store'] = store;
    data['city'] = city;
    data['chain'] = chain;
    data['channel'] = channel;
    data['visit-date'] = visitDate;
    data['visit-time'] = visitTime;
    data['added-by'] = addedBy;
    data['reason'] = reason;
    data['tmr'] = tmr;
    data['tmr_id'] = tmrId;
    data['store_id'] = storeId;
    return data;
  }
}