class DeleteSpecialVisitRequestModel {
  String? elId;
  String? id;

  DeleteSpecialVisitRequestModel({this.elId,this.id,});

  DeleteSpecialVisitRequestModel.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    data['id'] = id;
    return data;
  }
}