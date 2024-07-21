class RecruitSuggestListModel {
  bool? status;
  String? msg;
  List<RecruitSuggest>? data;

  RecruitSuggestListModel({this.status, this.msg, this.data});

  RecruitSuggestListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <RecruitSuggest>[];
      json['data'].forEach((v) {
        data!.add(RecruitSuggest.fromJson(v));
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

class RecruitSuggest {
  String? id;
  String? elId;
  String? name;
  String? cityId;
  String? cityName;
  String? iqama;
  String? phone;
  String? yearsOfExp;
  String? comment;
  String? cv;
  String? hired;
  String? hiredBy;
  String? updatedAt;

  RecruitSuggest(
      {this.id,
        this.elId,
        this.name,
        this.cityId,
        this.cityName,
        this.iqama,
        this.phone,
        this.yearsOfExp,
        this.comment,
        this.cv,
        this.hired,
        this.hiredBy,
        this.updatedAt});

  RecruitSuggest.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    elId = json['el_id'].toString();
    name = json['name'].toString();
    cityId = json['city_id'].toString();
    cityName = json['city_name'].toString();
    iqama = json['iqama'].toString();
    phone = json['phone'].toString();
    yearsOfExp = json['years_of_exp'].toString();
    comment = json['comment'].toString();
    cv = json['cv'].toString();
    hired = json['hired'].toString();
    hiredBy = json['hired_by'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['el_id'] = elId;
    data['name'] = name;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['iqama'] = iqama;
    data['phone'] = phone;
    data['years_of_exp'] = yearsOfExp;
    data['comment'] = comment;
    data['cv'] = cv;
    data['hired'] = hired;
    data['hired_by'] = hiredBy;
    data['updated_at'] = updatedAt;
    return data;
  }
}