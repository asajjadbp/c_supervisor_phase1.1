class StoresListResponseModel {
  bool? status;
  String? msg;
  List<StoresListItem>? data;

  StoresListResponseModel({this.status, this.msg, this.data});

  StoresListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <StoresListItem>[];
      json['data'].forEach((v) {
        data!.add(StoresListItem.fromJson(v));
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

class StoresListItem {
  int? id;
  String? name;

  StoresListItem({this.id, this.name});

  StoresListItem.fromJson(Map<String, dynamic> json) {
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