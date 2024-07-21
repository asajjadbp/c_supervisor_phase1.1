class CommonListModel {
  List<CommonListItem>? results;

  CommonListModel({this.results});

  CommonListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      results = <CommonListItem>[];
      json['data'].forEach((v) {
        results!.add(CommonListItem.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (results != null) {
      data['data'] = results!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class CommonListItem {
  String? id;
  String? text;

  CommonListItem({this.id, this.text});

  CommonListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString() ?? "";
    text = json['text'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['text'] = text;
    return data;
  }
}