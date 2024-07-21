// To parse this JSON data, do
//
//     final knowledgeShareRequestModel = knowledgeShareRequestModelFromJson(jsonString);

import 'dart:convert';

KnowledgeShareRequestModel knowledgeShareRequestModelFromJson(String str) =>
    KnowledgeShareRequestModel.fromJson(json.decode(str));

String knowledgeShareRequestModelToJson(KnowledgeShareRequestModel data) =>
    json.encode(data.toJson());

class KnowledgeShareRequestModel {
  String elId;
  String chainId;

  KnowledgeShareRequestModel({
    required this.elId,
    required this.chainId,
  });

  factory KnowledgeShareRequestModel.fromJson(Map<String, dynamic> json) =>
      KnowledgeShareRequestModel(
        elId: json["el_id"],
        chainId: json["chain_id"],
      );

  Map<String, dynamic> toJson() => {
        "el_id": elId,
        "chain_id": chainId,
      };
}
