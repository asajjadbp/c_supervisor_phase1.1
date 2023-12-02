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