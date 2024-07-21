class UpdateEfficiencyFeedbackRequestModel {
  String? userId;
  String? id;
  String? effComment;

  UpdateEfficiencyFeedbackRequestModel({this.userId,this.id,this.effComment});

  UpdateEfficiencyFeedbackRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    id = json['id'];
    effComment = json['eff_comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['id'] = id;
    data['eff_comment'] = effComment;
    return data;
  }
}

class UpdateProductivityFeedbackRequestModel {
  String? userId;
  String? id;
  String? proComment;

  UpdateProductivityFeedbackRequestModel({this.userId,this.id,this.proComment});

  UpdateProductivityFeedbackRequestModel.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    id = json['id'];
    proComment = json['pro_comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['id'] = id;
    data['pro_comment'] = proComment;
    return data;
  }
}