class SaveSpecialVisitRequestModel {
  String? elId;
  String? companyId;
  String? storeId;
  String? visitDate;
  String? visitTime;
  String? userId;
  String? reason;

  SaveSpecialVisitRequestModel({this.elId,this.companyId,this.storeId,this.visitDate,this.visitTime,this.userId,this.reason});

  SaveSpecialVisitRequestModel.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'];
    companyId = json['company_id'];
    storeId = json['store_id'];
    visitDate = json['visit_date'];
    visitTime = json['time_of_visit'];
    userId = json['user_id'];
    reason = json['reason'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    data['company_id'] = companyId;
    data['store_id'] = storeId;
    data['visit_date'] = visitDate;
    data['time_of_visit'] = visitTime;
    data['user_id'] = userId;
    data['reason'] = reason;
    return data;
  }
}