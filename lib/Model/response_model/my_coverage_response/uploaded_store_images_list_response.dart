class StoreImageResponseModel {
  bool? status;
  String? msg;
  List<StoreImageResponseItem>? data;

  StoreImageResponseModel({this.status, this.msg, this.data});

  StoreImageResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <StoreImageResponseItem>[];
      json['data'].forEach((v) {
        data!.add(StoreImageResponseItem.fromJson(v));
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

class StoreImageResponseItem {
  int? id;
  int? elId;
  int? workingId;
  int? storeId;
  String? imageName;

  StoreImageResponseItem({this.id, this.elId, this.workingId, this.storeId, this.imageName});

  StoreImageResponseItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    elId = json['el_id'];
    workingId = json['working_id'];
    storeId = json['store_id'];
    imageName = json['image_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['el_id'] = elId;
    data['working_id'] = workingId;
    data['store_id'] = storeId;
    data['image_name'] = imageName;
    return data;
  }
}