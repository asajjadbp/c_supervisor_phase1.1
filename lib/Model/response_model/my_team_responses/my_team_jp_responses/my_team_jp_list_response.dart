class MyTeamJpResponseModel {
  bool? status;
  String? msg;
  List<MyTeamJpResponseItem>? data;

  MyTeamJpResponseModel({this.status, this.msg, this.data});

  MyTeamJpResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <MyTeamJpResponseItem>[];
      json['data'].forEach((v) {
        data!.add(MyTeamJpResponseItem.fromJson(v));
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

class MyTeamJpResponseItem {
  int? companyId;
  String? client;
  String? region;
  String? city;
  String? chain;
  String? channel;
  String? store;
  int? storeId;
  int? odoo;
  int? tmrPhone;
  int? sat;
  int? sun;
  int? mon;
  int? tue;
  int? wed;
  int? thu;
  int? fri;
  String? username;
  String? fullName;
  int? userId;
  int? tmr;
  int? id;
  int? sumOfDays;
  String? stp;
  String? salesman;
  String? salesmanCode;
  String? segment;
  String? locationId;
  String? subChannel;
  String? route;
  String? salesSupervisor;
  String? salesManager;

  MyTeamJpResponseItem(
      {this.companyId,
        this.client,
        this.region,
        this.city,
        this.chain,
        this.channel,
        this.store,
        this.storeId,
        this.odoo,
        this.tmrPhone,
        this.sat,
        this.sun,
        this.mon,
        this.tue,
        this.wed,
        this.thu,
        this.fri,
        this.username,
        this.fullName,
        this.userId,
        this.tmr,
        this.id,
        this.sumOfDays,
        this.stp,
        this.salesman,
        this.salesmanCode,
        this.segment,
        this.locationId,
        this.subChannel,
        this.route,
        this.salesSupervisor,
        this.salesManager});

  MyTeamJpResponseItem.fromJson(Map<String, dynamic> json) {
    companyId = json['company_id'];
    client = json['CLIENT'];
    region = json['region'];
    city = json['city'];
    chain = json['chain'];
    channel = json['channel'];
    store = json['store'];
    storeId = json['store_id'];
    odoo = json['odoo'];
    tmrPhone = json['tmr_phone'];
    sat = json['sat'];
    sun = json['sun'];
    mon = json['mon'];
    tue = json['tue'];
    wed = json['wed'];
    thu = json['thu'];
    fri = json['fri'];
    username = json['username'];
    fullName = json['full_name'];
    userId = json['user_id'];
    tmr = json['tmr'];
    id = json['id'];
    sumOfDays = json['sum_of_days'];
    stp = json['stp'];
    salesman = json['salesman'];
    salesmanCode = json['salesman_code'];
    segment = json['segment'];
    locationId = json['location_id'];
    subChannel = json['sub_channel'];
    route = json['route'];
    salesSupervisor = json['sales_supervisor'];
    salesManager = json['sales_manager'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['company_id'] = companyId;
    data['CLIENT'] = client;
    data['region'] = region;
    data['city'] = city;
    data['chain'] = chain;
    data['channel'] = channel;
    data['store'] = store;
    data['store_id'] = storeId;
    data['odoo'] = odoo;
    data['tmr_phone'] = tmrPhone;
    data['sat'] = sat;
    data['sun'] = sun;
    data['mon'] = mon;
    data['tue'] = tue;
    data['wed'] = wed;
    data['thu'] = thu;
    data['fri'] = fri;
    data['username'] = username;
    data['full_name'] = fullName;
    data['user_id'] = userId;
    data['tmr'] = tmr;
    data['id'] = id;
    data['sum_of_days'] = sumOfDays;
    data['stp'] = stp;
    data['salesman'] = salesman;
    data['salesman_code'] = salesmanCode;
    data['segment'] = segment;
    data['location_id'] = locationId;
    data['sub_channel'] = subChannel;
    data['route'] = route;
    data['sales_supervisor'] = salesSupervisor;
    data['sales_manager'] = salesManager;
    return data;
  }
}