class AddRecruitSuggestRequestModel {
  String? elId;
  String? name;
  String? cityId;
  String? iqama;
  String? phone;
  String? yearOfExperience;
  String? comment;

  AddRecruitSuggestRequestModel({this.elId,this.name,this.cityId,this.iqama,this.phone,this.yearOfExperience,this.comment});

  AddRecruitSuggestRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    name = json['name'];
    cityId = json['city_id'];
    iqama = json['iqama'];
    phone = json['phone'];
    yearOfExperience = json['years_of_exp'];
    comment = json['comment'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId.toString();
    data['name'] = name.toString();
    data['city_id'] = cityId.toString();
    data['iqama'] = iqama.toString();
    data['phone'] = phone.toString();
    data['years_of_exp'] = yearOfExperience.toString();
    data['comment'] = comment.toString();

    return data;
  }
}

class UpdateRecruitSuggestRequestModel {
  String? id;
  String? elId;
  String? name;
  String? cityId;
  String? iqama;
  String? phone;
  String? yearOfExperience;
  String? comment;

  UpdateRecruitSuggestRequestModel({this.id,this.elId,this.name,this.cityId,this.iqama,this.phone,this.yearOfExperience,this.comment});

  UpdateRecruitSuggestRequestModel.fromJson(Map<String, String> json) {
    id = json['id'];
    elId = json['el_id'];
    name = json['name'];
    cityId = json['city_id'];
    iqama = json['iqama'];
    phone = json['phone'];
    yearOfExperience = json['years_of_exp'];
    comment = json['comment'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['id'] = id.toString();
    data['el_id'] = elId.toString();
    data['name'] = name.toString();
    data['city_id'] = cityId.toString();
    data['iqama'] = iqama.toString();
    data['phone'] = phone.toString();
    data['years_of_exp'] = yearOfExperience.toString();
    data['comment'] = comment.toString();
    return data;
  }
}

class DeleteRecruitSuggestRequestModel {
  String? id;
  String? elId;

  DeleteRecruitSuggestRequestModel({this.id,this.elId});

  DeleteRecruitSuggestRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    elId = json['el_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['el_id'] = elId;
    return data;
  }
}