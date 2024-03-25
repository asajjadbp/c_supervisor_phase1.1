class AddTimeMotionRequestModel {
  String? elId;
  String? companyId;
  String? cityId;
  String? channelId;
  String? noMinutes;

  AddTimeMotionRequestModel({this.elId,this.companyId,this.cityId,this.channelId,this.noMinutes});

  AddTimeMotionRequestModel.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'];
    companyId = json['company_id'];
    cityId = json['city_id'];
    channelId = json['channel_id'];
    noMinutes = json['no_minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    data['company_id'] = companyId;
    data['city_id'] = cityId;
    data['channel_id'] = channelId;
    data['no_minutes'] = noMinutes;

    return data;
  }
}

class UpdateTimeMotionRequestModel {
  String? id;
  String? elId;
  String? companyId;
  String? cityId;
  String? channelId;
  String? noMinutes;

  UpdateTimeMotionRequestModel({this.id,this.elId,this.companyId,this.cityId,this.channelId,this.noMinutes});

  UpdateTimeMotionRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    elId = json['el_id'];
    companyId = json['company_id'];
    cityId = json['city_id'];
    channelId = json['channel_id'];
    noMinutes = json['no_minutes'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['el_id'] = elId;
    data['company_id'] = companyId;
    data['city_id'] = cityId;
    data['channel_id'] = channelId;
    data['no_minutes'] = noMinutes;

    return data;
  }
}

class DeleteTimeMotionRequestModel {
  String? id;
  String? elId;

  DeleteTimeMotionRequestModel({this.id,this.elId});

  DeleteTimeMotionRequestModel.fromJson(Map<String, dynamic> json) {
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