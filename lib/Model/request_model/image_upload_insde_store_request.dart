class ImageUploadInStoreRequestModel {
  String? elId;
  String? workingId;
  String? storeId;
  String? comment;
  String? isSelfie;
  String? selfieType;

  ImageUploadInStoreRequestModel({this.elId,this.workingId,this.storeId,this.comment,this.isSelfie,this.selfieType});

  ImageUploadInStoreRequestModel.fromJson(Map<String, String> json) {
    elId = json['el_id'];
    workingId = json['working_id'];
    storeId = json['store_id'];
    comment = json['comment'];
    isSelfie = json['is_selfie'];
    selfieType = json['selfie_type'];
  }

  Map<String, String> toJson() {
    final Map<String, String> data = <String, String>{};
    data['el_id'] = elId!;
    data['working_id'] = workingId!;
    data['store_id'] = storeId!;
    data['comment'] = comment!;
    data['is_selfie'] = isSelfie!;
    data['selfie_type'] = selfieType!;

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