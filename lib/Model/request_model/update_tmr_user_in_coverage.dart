class UpdateTmrUserInCoverage{
  String? elId;
  String? workingId;
  String? tmrId;

  UpdateTmrUserInCoverage({this.elId,this.workingId,this.tmrId});

  UpdateTmrUserInCoverage.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    workingId = json['working_id'];
    tmrId = json['tmr_id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['working_id'] = workingId!;
    data['tmr_id'] = tmrId!;

    return data;
  }
}