class LogInResponseModel {
  bool? status;
  String? msg;
  List<LoginData>? data;

  LogInResponseModel({this.status, this.msg, this.data});

  LogInResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <LoginData>[];
      json['data'].forEach((v) {
        data!.add(new LoginData.fromJson(v));
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

class LoginData {
  int? id;
  String? email;
  String? name;
  String? welcomeMsg;
  String? companyName;

  LoginData({this.id, this.email, this.name, this.welcomeMsg, this.companyName});

  LoginData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    welcomeMsg = json['welcome_msg'];
    companyName = json['company_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['welcome_msg'] = welcomeMsg;
    data['company_name'] = companyName;
    return data;
  }
}