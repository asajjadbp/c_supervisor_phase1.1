class FeedbackListResponseModel {
  bool? status;
  String? msg;
  List<FeedbackListItem>? data;

  FeedbackListResponseModel({this.status, this.msg, this.data});

  FeedbackListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <FeedbackListItem>[];
      json['data'].forEach((v) {
        data!.add(FeedbackListItem.fromJson(v));
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

class FeedbackListItem {
  int? id;
  String? name;

  FeedbackListItem({this.id, this.name});

  FeedbackListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}