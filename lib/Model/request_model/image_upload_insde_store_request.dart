class ImageUploadInStoreRequestModel {
  String? elId;
  String? workingId;
  String? storeId;
  String? checkInGps;
  String? tmrId;
  String? comment;

  ImageUploadInStoreRequestModel({this.elId,this.workingId,this.storeId,this.checkInGps,this.tmrId,this.comment});

  ImageUploadInStoreRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    workingId = json['working_id'];
    storeId = json['store_id'];
    checkInGps = json['check_in_gps'];
    tmrId = json['tmr_id'];
    comment = json['comment'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['working_id'] = workingId!;
    data['store_id'] = storeId!;
    data['check_in_gps'] = checkInGps!;
    data['tmr_id'] = tmrId!;
    data['comment'] = comment!;

    return data;
  }
}

class UploadedImagesRequestModel {
  String? elId;
  String? workingId;
  String? storeId;

  UploadedImagesRequestModel({this.elId,this.workingId,this.storeId});

  UploadedImagesRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    workingId = json['working_id'];
    storeId = json['store_id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['working_id'] = workingId!;
    data['store_id'] = storeId!;

    return data;
  }
}

class DeleteImageRequestModel {
  String? elId;
  String? workingId;
  String? storeId;
  String? imageId;

  DeleteImageRequestModel({this.elId,this.workingId,this.storeId,this.imageId});

  DeleteImageRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    workingId = json['working_id'];
    storeId = json['store_id'];
    imageId = json['id'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['working_id'] = workingId!;
    data['store_id'] = storeId!;
    data['id'] = imageId!;

    return data;
  }
}