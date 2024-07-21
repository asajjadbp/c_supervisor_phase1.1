class TeamKpiResponseModel {
  bool? status;
  String? msg;
  List<TeamKpiResponseItem>? data;

  TeamKpiResponseModel({this.status, this.msg, this.data});

  TeamKpiResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <TeamKpiResponseItem>[];
      json['data'].forEach((v) {
        data!.add(TeamKpiResponseItem.fromJson(v));
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

class TeamKpiResponseItem {
  String? userId;
  String? id;
  String? userName;
  String? isPresent;
  String? totalPlanned;
  String? compliance;
  String? productivity;
  String? workingCity;
  String? stores;
  String? workingMinutesNew;
  String? wHOURS;
  String? efficiencyN;

  TeamKpiResponseItem(
      {this.userId,
        this.id,
        this.userName,
        this.isPresent,
        this.totalPlanned,
        this.compliance,
        this.productivity,
        this.workingCity,
        this.stores,
        this.workingMinutesNew,
        this.wHOURS,
        this.efficiencyN});

  TeamKpiResponseItem.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'].toString();
    id = json['id'].toString();
    isPresent = json['is_present'].toString();
    userName = json['full_name'].toString();
    totalPlanned = json['total_planned'].toString();
    compliance = json['compliance'].toString();
    productivity = json['productivity'].toString();
    workingCity = json['working_city'].toString();
    stores = json['stores'].toString();
    workingMinutesNew = json['working_minutes_new'].toString();
    wHOURS = json['W_HOURS'].toString();
    efficiencyN = json['efficiency_n'].toString() == "null" ?  "0" : json['efficiency_n'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['id'] = id;
    data['is_present'] = isPresent;
    data['full_name'] = userName;
    data['total_planned'] = totalPlanned;
    data['compliance'] = compliance;
    data['productivity'] = productivity;
    data['working_city'] = workingCity;
    data['stores'] = stores;
    data['working_minutes_new'] = workingMinutesNew;
    data['W_HOURS'] = wHOURS;
    data['efficiency_n'] = efficiencyN;
    return data;
  }
}