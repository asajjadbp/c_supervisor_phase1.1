class UploadCheckListRequestModel {
  String? elId;
  String? id;
  String? photoName;

  UploadCheckListRequestModel({this.elId, this.id, required this.photoName});

  UploadCheckListRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    id = json['id'];
    photoName = json['photo']!;
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['id'] = id!;
    data['photo'] = photoName!;

    return data;
  }
}
