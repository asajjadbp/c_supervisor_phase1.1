class ReasonListResponseModel {
  bool? status;
  String? msg;
  List<ReasonListItem>? data;

  ReasonListResponseModel({this.status, this.msg, this.data});

  ReasonListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <ReasonListItem>[];
      json['data'].forEach((v) {
        data!.add(ReasonListItem.fromJson(v));
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

class ReasonListItem {
  int? id;
  String? reason;
  String? isActive;
  String? updatedAt;

  ReasonListItem({this.id, this.reason, this.isActive, this.updatedAt});

  ReasonListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    reason = json['reason'];
    isActive = json['is_active'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['reason'] = reason;
    data['is_active'] = isActive;
    data['updated_at'] = updatedAt;
    return data;
  }
}