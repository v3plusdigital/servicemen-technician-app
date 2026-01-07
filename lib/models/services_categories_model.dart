// To parse this JSON data, do
//
//     final servicesCategoriesModel = servicesCategoriesModelFromJson(jsonString);

import 'dart:convert';

ServicesCategoriesModel servicesCategoriesModelFromJson(String str) => ServicesCategoriesModel.fromJson(json.decode(str));

String servicesCategoriesModelToJson(ServicesCategoriesModel data) => json.encode(data.toJson());

class ServicesCategoriesModel {
  bool? success;
  Data? data;

  ServicesCategoriesModel({
    this.success,
    this.data,
  });

  ServicesCategoriesModel copyWith({
    bool? success,
    Data? data,
  }) =>
      ServicesCategoriesModel(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory ServicesCategoriesModel.fromJson(Map<String, dynamic> json) => ServicesCategoriesModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  List<ServiceType>? serviceTypes;

  Data({
    this.serviceTypes,
  });

  Data copyWith({
    List<ServiceType>? serviceTypes,
  }) =>
      Data(
        serviceTypes: serviceTypes ?? this.serviceTypes,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    serviceTypes: json["service_types"] == null ? [] : List<ServiceType>.from(json["service_types"]!.map((x) => ServiceType.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "service_types": serviceTypes == null ? [] : List<dynamic>.from(serviceTypes!.map((x) => x.toJson())),
  };
}

class ServiceType {
  int? id;
  String? name;
  String? image;
  String? thumbnail;

  ServiceType({
    this.id,
    this.name,
    this.image,
    this.thumbnail,
  });

  ServiceType copyWith({
    int? id,
    String? name,
    String? image,
    String? thumbnail,
  }) =>
      ServiceType(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  factory ServiceType.fromJson(Map<String, dynamic> json) => ServiceType(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "thumbnail": thumbnail,
  };
}
