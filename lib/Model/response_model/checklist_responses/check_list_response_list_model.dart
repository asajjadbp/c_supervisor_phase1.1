// class CheckListResponseModel {
//   bool? status;
//   String? msg;
//   List<CheckListItem>? data;
//
//   CheckListResponseModel({this.status, this.msg, this.data});
//
//   CheckListResponseModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     msg = json['msg'];
//     if (json['data'] != null) {
//       data = <CheckListItem>[];
//       json['data'].forEach((v) {
//         data!.add(CheckListItem.fromJson(v));
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
// class CheckListItem {
//   int? id;
//   String? checkList;
//   int? checklistResultId;
//   int? score;
//   String? comment;
//
//   CheckListItem(
//       {this.id,
//         this.checkList,
//         this.checklistResultId,
//         this.score,
//         this.comment});
//
//   CheckListItem.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     checkList = json['check_list'];
//     checklistResultId = json['checklist_result_id'];
//     score = json['score'] ?? 0.0;
//     comment = json['comment'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['check_list'] = checkList;
//     data['checklist_result_id'] = checklistResultId;
//     data['score'] = score;
//     data['comment'] = comment;
//     return data;
//   }
// }

class CheckListResponseModel {
  bool? status;
  String? msg;
  List<CheckListItem>? data;

  CheckListResponseModel({this.status, this.msg, this.data});

  CheckListResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    msg = json['msg'];
    if (json['data'] != null) {
      data = <CheckListItem>[];
      json['data'].forEach((v) {
        data!.add(CheckListItem.fromJson(v));
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

class CheckListItem {
  int? id;
  String? checkList;
  int? checklistResultId;
  int? score;
  String? comment;
  String? imageName;
  String? isApplicable;

  CheckListItem(
      {this.id,
        this.checkList,
        this.checklistResultId,
        this.score,
        this.comment,
        this.imageName,
        this.isApplicable,
      });

  CheckListItem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    checkList = json['check_list'].toString();
    checklistResultId = json['checklist_result_id'];
    score = json['score'];
    comment = json['comment'].toString();
    imageName = json['image_name'].toString();
    isApplicable = json['applicable'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['check_list'] = checkList;
    data['checklist_result_id'] = checklistResultId;
    data['score'] = score;
    data['comment'] = comment;
    data['image_name'] = imageName;
    data['applicable'] = isApplicable;
    return data;
  }
}