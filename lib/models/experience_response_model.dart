// To parse this JSON data, do
//
//     final experienceResponseModel = experienceResponseModelFromJson(jsonString);

import 'dart:convert';

ExperienceResponseModel experienceResponseModelFromJson(String str) => ExperienceResponseModel.fromJson(json.decode(str));

String experienceResponseModelToJson(ExperienceResponseModel data) => json.encode(data.toJson());

class ExperienceResponseModel {
  bool? success;
  List<String>? data;

  ExperienceResponseModel({
    this.success,
    this.data,
  });

  ExperienceResponseModel copyWith({
    bool? success,
    List<String>? data,
  }) =>
      ExperienceResponseModel(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory ExperienceResponseModel.fromJson(Map<String, dynamic> json) => ExperienceResponseModel(
    success: json["success"],
    data: json["data"] == null ? [] : List<String>.from(json["data"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x)),
  };
}
