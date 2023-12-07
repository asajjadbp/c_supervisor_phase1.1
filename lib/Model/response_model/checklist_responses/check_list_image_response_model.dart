class CheckListImageResponseModel {
  bool? status;
  String? msg;
  List<CheckListImageResponse>? data;

  CheckListImageResponseModel({this.status, this.msg, this.data});

  CheckListImageResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CheckListImageResponse>[];
      json['data'].forEach((v) {
        data!.add(CheckListImageResponse.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['msg'] = msg;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CheckListImageResponse {
  int? elId;
  int? id;
  String? imageName;

  CheckListImageResponse({this.elId, this.id, this.imageName});

  CheckListImageResponse.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'];
    id = json['id'];
    imageName = json['image_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    data['id'] = id;
    data['image_name'] = imageName;
    return data;
  }
}