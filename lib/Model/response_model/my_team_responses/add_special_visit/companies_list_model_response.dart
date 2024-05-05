class CompaniesListResponseModel {
  bool? status;
  String? msg;
  List<CompaniesListItem>? data;

  CompaniesListResponseModel({this.status, this.msg, this.data});

  CompaniesListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CompaniesListItem>[];
      json['data'].forEach((v) {
        data!.add(CompaniesListItem.fromJson(v));
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

class CompaniesListItem {
  int? id;
  int? companyId;
  String? companyName;

  CompaniesListItem({this.id, this.companyId, this.companyName});

  CompaniesListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    companyId = json['company_id'];
    companyName = json['company_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    return data;
  }
}