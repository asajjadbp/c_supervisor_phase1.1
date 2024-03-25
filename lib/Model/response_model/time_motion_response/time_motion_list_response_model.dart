class TimeMotionListModel {
  bool? status;
  String? msg;
  List<TimeMotion>? data;

  TimeMotionListModel({this.status, this.msg, this.data});

  TimeMotionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <TimeMotion>[];
      json['data'].forEach((v) {
        data!.add(TimeMotion.fromJson(v));
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

class TimeMotion {
  String? elId;
  String? id;
  String? companyName;
  String? cityName;
  String? channelName;
  String? noMinutes;
  String? updatedAt;

  TimeMotion(
      {this.elId,
        this.id,
        this.companyName,
        this.cityName,
        this.channelName,
        this.noMinutes,
        this.updatedAt});

  TimeMotion.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'].toString() ?? "";
    id = json['id'].toString() ?? "";
    companyName = json['company_name'].toString() ?? "";
    cityName = json['city_name'].toString();
    channelName = json['channel_name'].toString() ?? "";
    noMinutes = json['no_minutes'].toString() ?? "";
    updatedAt = json['updated_at'].toString() ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    data['id'] = id;
    data['company_name'] = companyName;
    data['city_name'] = cityName;
    data['channel_name'] = channelName;
    data['no_minutes'] = noMinutes;
    data['updated_at'] = updatedAt;
    return data;
  }
}