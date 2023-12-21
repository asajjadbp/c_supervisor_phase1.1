class EndVisitRequestModel {
  String? elId;
  String? workingId;
  String? checkInGps;

  EndVisitRequestModel({this.elId,this.workingId,this.checkInGps});

  EndVisitRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    workingId = json['working_id'];
    checkInGps = json['check_out_gps'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['working_id'] = workingId!;
    data['check_out_gps'] = checkInGps!;

    return data;
  }
}