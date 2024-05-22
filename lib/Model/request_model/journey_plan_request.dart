class JourneyPlanRequestModel {
  String? elId;

  JourneyPlanRequestModel({this.elId});

  JourneyPlanRequestModel.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    return data;
  }
}

class TmrUserListRequestModel {
  String? elId;
  String? cityId;
  String? chainId;

  TmrUserListRequestModel({this.elId,this.cityId,this.chainId});

  TmrUserListRequestModel.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'];
    cityId = json['city_id'];
    chainId = json['chain_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    data['city_id'] = cityId;
    data['chain_id'] = chainId;
    return data;
  }
}

class CityListRequestModel {
  String? elId;
  String? regionId;

  CityListRequestModel({this.elId,this.regionId,});

  CityListRequestModel.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'];
    regionId = json['region_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    data['region_id'] = regionId;
    return data;
  }
}