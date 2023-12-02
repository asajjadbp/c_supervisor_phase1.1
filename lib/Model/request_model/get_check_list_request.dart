class GetCheckListRequest {
  String? elId;
  String? workingId;
  String? storeId;
  String? tmrId;

  GetCheckListRequest({this.elId, this.workingId, this.storeId, this.tmrId});

  GetCheckListRequest.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    workingId = json['working_id'];
    storeId = json['store_id'];
    tmrId = json['tmr_id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['working_id'] = workingId!;
    data['store_id'] = storeId!;
    data['tmr_id'] = tmrId!;

    return data;
  }
}