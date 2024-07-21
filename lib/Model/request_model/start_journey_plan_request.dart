class StartJourneyPlanRequestModel {
  String? elId;
  String? workingId;
  String? storeId;
  String? checkInGps;
  String? photoName;
  // String? tmrId;

  StartJourneyPlanRequestModel(
      {this.elId, this.workingId, this.storeId, this.checkInGps, this.photoName
      // this.tmrId
      });

  StartJourneyPlanRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    workingId = json['working_id'];
    storeId = json['store_id'];
    checkInGps = json['check_in_gps'];
    // tmrId = json['tmr_id'];
    photoName = json['photo_name'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['working_id'] = workingId!;
    data['store_id'] = storeId!;
    data['check_in_gps'] = checkInGps!;
    // data['tmr_id'] = tmrId!;
    data['photo_name'] = photoName!;

    return data;
  }
}
