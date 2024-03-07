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
  int? userId;
  String? id;
  String? userName;
  int? isPresent;
  int? totalPlanned;
  int? compliance;
  int? productivity;
  int? workingCity;
  int? stores;
  int? workingMinutesNew;
  int? wHOURS;
  int? efficiencyN;

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
    userId = json['user_id'];
    id = json['id'].toString();
    isPresent = json['is_present'];
    userName = json['full_name'];
    totalPlanned = json['total_planned'];
    compliance = json['compliance'] ?? 0;
    productivity = json['productivity'] ?? 0;
    workingCity = json['working_city'];
    stores = json['stores'];
    workingMinutesNew = json['working_minutes_new'];
    wHOURS = json['W_HOURS'];
    efficiencyN = json['efficiency_n'] ?? 0;
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