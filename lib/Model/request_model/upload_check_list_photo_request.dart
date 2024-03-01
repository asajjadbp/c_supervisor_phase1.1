class UploadCheckListRequestModel {
  String? elId;
  String? id;

  UploadCheckListRequestModel({this.elId,this.id});

  UploadCheckListRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    id = json['id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['id'] = id!;

    return data;
  }
}