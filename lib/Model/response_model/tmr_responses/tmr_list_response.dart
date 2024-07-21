class TmrUserList {
  bool? status;
  String? msg;
  List<TmrUserItem>? data;

  TmrUserList({this.status, this.msg, this.data});

  TmrUserList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <TmrUserItem>[];
      json['data'].forEach((v) {
        data!.add(TmrUserItem.fromJson(v));
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

class TmrUserItem {
  int? id;
  String? fullName;
  String? email;

  TmrUserItem({this.id, this.fullName, this.email});

  TmrUserItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['full_name'].toString();
    email = json['email'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['full_name'] = fullName;
    data['email'] = email;
    return data;
  }
}