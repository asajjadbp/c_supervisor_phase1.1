class AddBusinessTripsRequestModel {
  String? elId;
  String? fromCity;
  String? toCity;
  String? reason;

  AddBusinessTripsRequestModel({this.elId,this.fromCity,this.toCity,this.reason});

  AddBusinessTripsRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    fromCity = json['from_city'];
    toCity = json['to_city'];
    reason = json['reason'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId.toString();
    data['from_city'] = fromCity.toString();
    data['to_city'] = toCity.toString();
    data['reason'] = reason.toString();
    return data;
  }
}

class UpdateBusinessTripsRequestModel {
  String? id;
  String? elId;
  String? fromCity;
  String? toCity;
  String? reason;

  UpdateBusinessTripsRequestModel({this.id,this.elId,this.fromCity,this.toCity,this.reason});

  UpdateBusinessTripsRequestModel.fromJson(Map<String, String> json) {
    id = json['id'];
    elId = json['el_id'];
    fromCity = json['from_city_id'];
    toCity = json['to_city_id'];
    reason = json['reason'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['id'] = id.toString();
    data['el_id'] = elId.toString();
    data['from_city_id'] = fromCity.toString();
    data['to_city_id'] = toCity.toString();
    data['reason'] = reason.toString();
    return data;
  }
}

class DeleteBusinessTripsRequestModel {
  String? id;
  String? elId;

  DeleteBusinessTripsRequestModel({this.id,this.elId});

  DeleteBusinessTripsRequestModel.fromJson(Map<String, dynamic> json) {
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