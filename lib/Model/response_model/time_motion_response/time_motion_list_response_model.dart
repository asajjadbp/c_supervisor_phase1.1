class TimeMotionListModel {
  bool? status;
  String? msg;
  List<TimeMotionItem>? data;

  TimeMotionListModel({this.status, this.msg, this.data});

  TimeMotionListModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <TimeMotionItem>[];
      json['data'].forEach((v) {
        data!.add(TimeMotionItem.fromJson(v));
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

class TimeMotionItem {
  String? id;
  String? elId;
  String? companyId;
  String? companyName;
  String? storeName;
  String? cityName;
  String? channelName;
  String? storeId;
  String? cityId;
  String? channelId;
  String? netMinutes;
  String? updatedAt;
  List<Categories>? categories;

  TimeMotionItem(
      {this.id,
        this.elId,
        this.companyId,
        this.companyName,
        this.storeName,
        this.cityName,
        this.channelName,
        this.storeId,
        this.cityId,
        this.channelId,
        this.netMinutes,
        this.updatedAt,
        this.categories});

  TimeMotionItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    elId = json['el_id'].toString();
    companyId = json['company_id'].toString();
    companyName = json['company_name'].toString();
    storeName = json['store_name'].toString();
    cityName = json['city_name'].toString();
    channelName = json['channel_name'].toString();
    storeId = json['store_id'].toString();
    cityId = json['city_id'].toString();
    channelId = json['channel_id'].toString();
    netMinutes = json['net_minutes'].toString();
    updatedAt = json['updated_at'].toString();
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['el_id'] = elId;
    data['company_id'] = companyId;
    data['company_name'] = companyName;
    data['store_name'] = storeName;
    data['city_name'] = cityName;
    data['channel_name'] = channelName;
    data['store_id'] = storeId;
    data['city_id'] = cityId;
    data['channel_id'] = channelId;
    data['net_minutes'] = netMinutes;
    data['updated_at'] = updatedAt;
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  int? categoryId;
  String? categoryName;
  String? noMinutes;

  Categories({this.categoryId, this.categoryName, this.noMinutes});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'].toString();
    noMinutes = json['no_minutes'].toString() == "null" ? "" : json['no_minutes'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['category_id'] = categoryId;
    data['category_name'] = categoryName;
    data['no_minutes'] = noMinutes;
    return data;
  }
}