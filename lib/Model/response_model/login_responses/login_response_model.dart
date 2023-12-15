// class LogInResponseModel {
//   bool? status;
//   String? msg;
//   List<LoginData>? data;
//
//   LogInResponseModel({this.status, this.msg, this.data});
//
//   LogInResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     msg = json['msg'];
//     if (json['data'] != null) {
//       data = <LoginData>[];
//       json['data'].forEach((v) {
//         data!.add(new LoginData.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['status'] = status;
//     data['msg'] = msg;
//     if (this.data != null) {
//       data['data'] = this.data!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class LoginData {
//   String? id;
//   String? email;
//   String? name;
//   String? welcomeMsg;
//
//   LoginData({this.id, this.email, this.name, this.welcomeMsg, });
//
//   LoginData.fromJson(Map<String, dynamic> json) {
//     id = json['id'].toString();
//     email = json['email'].toString();
//     name = json['name'].toString();
//     welcomeMsg = json['welcome_msg'].toString();
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['email'] = email;
//     data['name'] = name;
//     data['welcome_msg'] = welcomeMsg;
//     return data;
//   }
// }

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
        data!.add(LoginData.fromJson(v));
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
  int? name;
  String? welcomeMsg;
  String? fullName;

  LoginData({this.id, this.email, this.name, this.welcomeMsg, this.fullName});

  LoginData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    name = json['name'];
    welcomeMsg = json['welcome_msg'];
    fullName = json['full_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['name'] = name;
    data['welcome_msg'] = welcomeMsg;
    data['full_name'] = fullName;
    return data;
  }
}