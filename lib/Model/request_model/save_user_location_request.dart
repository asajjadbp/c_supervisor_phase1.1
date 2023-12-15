class SaveUserLocationRequestModel {
  String? elId;
  String? latLong;

  SaveUserLocationRequestModel({this.elId,this.latLong});

  SaveUserLocationRequestModel.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'];
    latLong = json['lat_lon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    data['lat_lon'] = latLong;
    return data;
  }
}