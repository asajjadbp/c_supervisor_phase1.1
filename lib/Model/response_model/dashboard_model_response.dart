class DashboardResponseData {
  bool? status;
  String? msg;
  List<Data>? data;

  DashboardResponseData({this.status, this.msg, this.data});

  DashboardResponseData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
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

class Data {
  Mykpi? mykpi;
  Teamkpi? teamkpi;

  Data({this.mykpi, this.teamkpi});

  Data.fromJson(Map<String, dynamic> json) {
    mykpi = json['mykpi'] != null ? Mykpi.fromJson(json['mykpi']) : null;
    teamkpi =
    json['teamkpi'] != null ? Teamkpi.fromJson(json['teamkpi']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (mykpi != null) {
      data['mykpi'] = mykpi!.toJson();
    }
    if (teamkpi != null) {
      data['teamkpi'] = teamkpi!.toJson();
    }
    return data;
  }
}

class Mykpi {
  int? planned;
  int? totalPlanned;
  int? totalJpc;
  int? totalEffeciency;
  int? totalCoverage;
  int? special;
  int? checkins;
  int? totalCheckins;
  int? plannedTime;
  int? specialTime;
  int? checkinTime;

  Mykpi(
      {this.planned,
        this.totalPlanned,
        this.totalJpc,
        this.totalEffeciency,
        this.totalCoverage,
        this.special,
        this.checkins,
        this.totalCheckins,
        this.plannedTime,
        this.specialTime,
        this.checkinTime});

  Mykpi.fromJson(Map<String, dynamic> json) {
    planned = json['planned'] ?? 0;
    totalPlanned = json['total_planned'] ?? 0;
    totalJpc = json['total_jpc'] ?? 0;
    totalEffeciency = json['total_efficiency'] ?? 0;
    totalCoverage = json['total_coverage'] ?? 0;
    special = json['special'] ?? 0;
    checkins = json['checkins'] ?? 0;
    totalCheckins = json['total_checkins'] ?? 0;
    plannedTime = json['planned_time'] ?? 0;
    specialTime = json['special_time'] ?? 0;
    checkinTime = json['checkin_time'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['planned'] = planned;
    data['total_planned'] = totalPlanned;
    data['total_jpc'] = totalJpc;
    data['total_efficiency'] = totalEffeciency;
    data['total_coverage'] = totalCoverage;
    data['special'] = special;
    data['checkins'] = checkins;
    data['total_checkins'] = totalCheckins;
    data['planned_time'] = plannedTime;
    data['special_time'] = specialTime;
    data['checkin_time'] = checkinTime;
    return data;
  }
}

class Teamkpi {
  int? totalUsers;
  int? totalPresent;
  int? totalJpc;
  int? totalProductivity;
  int? totalEffeciency;

  Teamkpi(
      {this.totalUsers,
        this.totalPresent,
        this.totalJpc,
        this.totalProductivity,
        this.totalEffeciency});

  Teamkpi.fromJson(Map<String, dynamic> json) {
    totalUsers = json['total_users'] ?? 0;
    totalPresent = json['total_present'] ?? 0;
    totalJpc = json['total_jpc'] ?? 0;
    totalProductivity = json['total_productivity'] ?? 0;
    totalEffeciency = json['total_efficiency'] ?? 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_users'] = totalUsers;
    data['total_present'] = totalPresent;
    data['total_jpc'] = totalJpc;
    data['total_productivity'] = totalProductivity;
    data['total_efficiency'] = totalEffeciency;
    return data;
  }
}