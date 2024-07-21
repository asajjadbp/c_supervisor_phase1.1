class CommonApiCallRequestModel {
  String? searchBy;
  String? termType;
  String? termTerm;
  String? elId;
  String? companyId;

  CommonApiCallRequestModel({this.searchBy,this.termType,this.termTerm,this.elId,this.companyId});

  CommonApiCallRequestModel.fromJson(Map<String, dynamic> json) {
    searchBy = json['search_by'];
    termType = json['term[_type]'];
    termTerm = json['term[term]'];
    elId = json['el_id'];
    companyId = json['company_id[]'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search_by'] = searchBy;
    data['term[_type]'] = termType;
    data['term[term]'] = termTerm;
    data['el_id'] = elId;
    data['company_id[]'] = companyId;
    return data;
  }
}