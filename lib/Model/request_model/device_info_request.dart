class DeviceInfoRequestModel {
  String? elId;
  String? serialNumber;
  String? deviceId;
  String? model;
  String? manufacture;
  String? brand;
  String? sdk;
  String? osVersion;
  String? simNumber;
  String? mobileDataUsage;
  String? wifiDataUsage;
  String? latLong;

  DeviceInfoRequestModel({
    this.elId,
    this.serialNumber,
    this.deviceId,
    this.model,
    this.manufacture,
    this.brand,
    this.sdk,
    this.osVersion,
    this.simNumber,
    this.mobileDataUsage,
    this.wifiDataUsage,
    this.latLong,
  });

  DeviceInfoRequestModel.fromJson(Map<String, dynamic> json) {
    elId = json['el_id'];
    serialNumber = json['serial_number'];
    deviceId = json['device_id'];
    model = json['model'];
    manufacture = json['manufacture'];
    brand = json['brand'];
    sdk = json['sdk'];
    osVersion = json['os_version'];
    simNumber = json['sim_number'];
    mobileDataUsage = json['mobile_data_usage'];
    wifiDataUsage = json['wifi_data_usage'];
    latLong = json['login_gps'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['el_id'] = elId;
    data['serial_number'] = serialNumber;
    data['device_id'] = deviceId;
    data['model'] = model;
    data['manufacture'] = manufacture;
    data['brand'] = brand;
    data['sdk'] = sdk;
    data['os_version'] = osVersion;
    data['sim_number'] = simNumber;
    data['mobile_data_usage'] = mobileDataUsage;
    data['wifi_data_usage'] = wifiDataUsage;
    data['login_gps'] = latLong;
    return data;
  }
}