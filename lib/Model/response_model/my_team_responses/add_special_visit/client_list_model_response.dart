class ClientListResponseModel {
  bool? status;
  String? msg;
  List<ClientListItem>? data;

  ClientListResponseModel({this.status, this.msg, this.data});

  ClientListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <ClientListItem>[];
      json['data'].forEach((v) {
        data!.add(ClientListItem.fromJson(v));
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

class ClientListItem {
  String? companyName;
  String? businessModel;
  int? companyId;
  int? freqWeek;
  int? uniqueStores;
  int? uniqueTmrs;
  int? productCount;
  int? brandCount;
  int? categroyCount;

  ClientListItem(
      {this.companyName,
        this.businessModel,
        this.companyId,
        this.freqWeek,
        this.uniqueStores,
        this.uniqueTmrs,
        this.productCount,
        this.brandCount,
        this.categroyCount});

  ClientListItem.fromJson(Map<String, dynamic> json) {
    companyName = json['company_name'].toString();
    businessModel = json['business_model'].toString();
    companyId = json['company_id'];
    freqWeek = json['freq_week'];
    uniqueStores = json['unique_stores'];
    uniqueTmrs = json['unique_tmrs'];
    productCount = json['product_count'];
    brandCount = json['brand_count'];
    categroyCount = json['categroy_count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_name'] = companyName;
    data['business_model'] = businessModel;
    data['company_id'] = companyId;
    data['freq_week'] = freqWeek;
    data['unique_stores'] = uniqueStores;
    data['unique_tmrs'] = uniqueTmrs;
    data['product_count'] = productCount;
    data['brand_count'] = brandCount;
    data['categroy_count'] = categroyCount;
    return data;
  }
}