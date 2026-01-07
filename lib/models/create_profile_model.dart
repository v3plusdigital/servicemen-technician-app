// To parse this JSON data, do
//
//     final experienceResponseModel = experienceResponseModelFromJson(jsonString);

import 'dart:convert';

ProfileCreateRequest experienceResponseModelFromJson(String str) => ProfileCreateRequest.fromJson(json.decode(str));

String experienceResponseModelToJson(ProfileCreateRequest data) => json.encode(data.toJson());

class ProfileCreateRequest {
  String? name;
  String? email;
  String? skillsDescription;
  String? experience;
  List<int>? serviceTypeIds;
  List<int>? serviceAreaIds;

  ProfileCreateRequest({
    this.name,
    this.email,
    this.skillsDescription,
    this.experience,
    this.serviceTypeIds,
    this.serviceAreaIds,
  });

  factory ProfileCreateRequest.fromJson(Map<String, dynamic> json) => ProfileCreateRequest(
    name: json["name"],
    email: json["email"],
    skillsDescription: json["skills_description"],
    experience: json["experience"],
    serviceTypeIds: json["service_type_ids"] == null ? [] : List<int>.from(json["service_type_ids"]!.map((x) => x)),
    serviceAreaIds: json["service_area_ids"] == null ? [] : List<int>.from(json["service_area_ids"]!.map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "email": email,
    "skills_description": skillsDescription,
    "experience": experience,
    "service_type_ids": serviceTypeIds == null ? [] : List<dynamic>.from(serviceTypeIds!.map((x) => x)),
    "service_area_ids": serviceAreaIds == null ? [] : List<dynamic>.from(serviceAreaIds!.map((x) => x)),
  };
}
