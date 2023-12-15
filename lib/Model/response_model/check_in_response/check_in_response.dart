class IpcLocationResponseModel {
  bool? status;
  String? msg;
  List<IpcLocationResponseItem>? data;

  IpcLocationResponseModel({this.status, this.msg, this.data});

  IpcLocationResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <IpcLocationResponseItem>[];
      json['data'].forEach((v) {
        data!.add(IpcLocationResponseItem.fromJson(v));
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

class IpcLocationResponseItem {
  String? id;
  String? gps;

  IpcLocationResponseItem({this.id, this.gps});

  IpcLocationResponseItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    gps = json['gps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['gps'] = gps;
    return data;
  }
}