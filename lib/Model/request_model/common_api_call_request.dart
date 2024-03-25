class CommonApiCallRequestModel {
  String? searchBy;
  String? termType;
  String? termTerm;

  CommonApiCallRequestModel({this.searchBy,this.termType,this.termTerm});

  CommonApiCallRequestModel.fromJson(Map<String, dynamic> json) {
    searchBy = json['search_by'];
    termType = json['term[_type]'];
    termTerm = json['term[term]'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['search_by'] = searchBy;
    data['term[_type]'] = termType;
    data['term[term]'] = termTerm;
    return data;
  }
}