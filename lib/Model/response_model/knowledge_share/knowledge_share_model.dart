// To parse this JSON data, do
//
//     final knowledgeShareResponseModel = knowledgeShareResponseModelFromJson(jsonString);

import 'dart:convert';

KnowledgeShareResponseModel knowledgeShareResponseModelFromJson(String str) =>
    KnowledgeShareResponseModel.fromJson(json.decode(str));

String knowledgeShareResponseModelToJson(KnowledgeShareResponseModel data) =>
    json.encode(data.toJson());

class KnowledgeShareResponseModel {
  bool status;
  String msg;
  List<KnowledgeList> data;

  KnowledgeShareResponseModel({
    required this.status,
    required this.msg,
    required this.data,
  });

  factory KnowledgeShareResponseModel.fromJson(Map<String, dynamic> json) =>
      KnowledgeShareResponseModel(
        status: json["status"],
        msg: json["msg"],
        data: List<KnowledgeList>.from(
            json["data"].map((x) => KnowledgeList.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "msg": msg,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class KnowledgeList {
  String? type;
  int? clientId;
  String title;
  String description;
  String? fileName;
  String companyName;

  KnowledgeList({
    required this.type,
    required this.clientId,
    required this.title,
    required this.description,
    required this.fileName,
    required this.companyName,
  });

  factory KnowledgeList.fromJson(Map<String, dynamic> json) => KnowledgeList(
        type: json["type"].toString(),
        clientId: json["client_id"],
        title: json["title"].toString(),
        description: json["description"].toString(),
        fileName: json["file_name"].toString(),
        companyName: json["company_name"].toString(),
      );

  Map<String, dynamic> toJson() => {
        "client_id": clientId,
        "title": title,
        "description": description,
        "file_name": fileName,
        "company_name": companyName,
        "type": type
      };
}
