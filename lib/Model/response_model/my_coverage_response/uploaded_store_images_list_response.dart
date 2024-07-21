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
  String? selfieType;

  StoreImageResponseItem({this.id, this.elId, this.workingId, this.storeId, this.imageName,this.selfieType});

  StoreImageResponseItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    elId = json['el_id'];
    workingId = json['working_id'];
    storeId = json['store_id'];
    imageName = json['image_name'].toString();
    selfieType = json['selfie_type'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['el_id'] = elId;
    data['working_id'] = workingId;
    data['store_id'] = storeId;
    data['image_name'] = imageName;
    data['selfie_type'] = selfieType;
    return data;
  }
}

class StoreSelfieAvailabilityResponseModel {
  bool? status;
  String? msg;
  List<StoreSelfieAvailabilityResponseItem>? data;

  StoreSelfieAvailabilityResponseModel({this.status, this.msg, this.data});

  StoreSelfieAvailabilityResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <StoreSelfieAvailabilityResponseItem>[];
      json['data'].forEach((v) {
        data!.add(StoreSelfieAvailabilityResponseItem.fromJson(v));
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

class StoreSelfieAvailabilityResponseItem {
  int? id;
  int? selfieType;

  StoreSelfieAvailabilityResponseItem({this.id,this.selfieType});

  StoreSelfieAvailabilityResponseItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    selfieType = json['selfie_type'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['selfie_type'] = selfieType;
    return data;
  }
}