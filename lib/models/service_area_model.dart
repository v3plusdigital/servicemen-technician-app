// To parse this JSON data, do
//
//     final serviceAreaModel = serviceAreaModelFromJson(jsonString);

import 'dart:convert';

ServiceAreaModel serviceAreaModelFromJson(String str) => ServiceAreaModel.fromJson(json.decode(str));

String serviceAreaModelToJson(ServiceAreaModel data) => json.encode(data.toJson());

class ServiceAreaModel {
  bool? success;
  Data? data;

  ServiceAreaModel({
    this.success,
    this.data,
  });

  ServiceAreaModel copyWith({
    bool? success,
    Data? data,
  }) =>
      ServiceAreaModel(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory ServiceAreaModel.fromJson(Map<String, dynamic> json) => ServiceAreaModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  List<ServiceArea>? serviceAreas;

  Data({
    this.serviceAreas,
  });

  Data copyWith({
    List<ServiceArea>? serviceAreas,
  }) =>
      Data(
        serviceAreas: serviceAreas ?? this.serviceAreas,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    serviceAreas: json["service_areas"] == null ? [] : List<ServiceArea>.from(json["service_areas"]!.map((x) => ServiceArea.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "service_areas": serviceAreas == null ? [] : List<dynamic>.from(serviceAreas!.map((x) => x.toJson())),
  };
}

class ServiceArea {
  int? id;
  String? area;
  String? city;
  String? state;

  ServiceArea({
    this.id,
    this.area,
    this.city,
    this.state,
  });

  ServiceArea copyWith({
    int? id,
    String? area,
    String? city,
    String? state,
  }) =>
      ServiceArea(
        id: id ?? this.id,
        area: area ?? this.area,
        city: city ?? this.city,
        state: state ?? this.state,
      );

  factory ServiceArea.fromJson(Map<String, dynamic> json) => ServiceArea(
    id: json["id"],
    area: json["area"],
    city: json["city"],
    state: json["state"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "area": area,
    "city": city,
    "state": state,
  };
}
