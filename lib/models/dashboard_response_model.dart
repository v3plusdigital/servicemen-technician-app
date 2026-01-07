// To parse this JSON data, do
//
//     final dashboardResponseModel = dashboardResponseModelFromJson(jsonString);

import 'dart:convert';

DashboardResponseModel dashboardResponseModelFromJson(String str) => DashboardResponseModel.fromJson(json.decode(str));

String dashboardResponseModelToJson(DashboardResponseModel data) => json.encode(data.toJson());

class DashboardResponseModel {
  bool? success;
  Data? data;

  DashboardResponseModel({
    this.success,
    this.data,
  });

  DashboardResponseModel copyWith({
    bool? success,
    Data? data,
  }) =>
      DashboardResponseModel(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) => DashboardResponseModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  List<Service>? serviceTypes;
  List<MediaGallery>? mediaGallery;

  Data({
    this.serviceTypes,
    this.mediaGallery,
  });

  Data copyWith({
    List<Service>? serviceTypes,
    List<MediaGallery>? mediaGallery,
  }) =>
      Data(
        serviceTypes: serviceTypes ?? this.serviceTypes,
        mediaGallery: mediaGallery ?? this.mediaGallery,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    serviceTypes: json["service_types"] == null ? [] : List<Service>.from(json["service_types"]!.map((x) => Service.fromJson(x))),
    mediaGallery: json["media_gallery"] == null ? [] : List<MediaGallery>.from(json["media_gallery"]!.map((x) => MediaGallery.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "service_types": serviceTypes == null ? [] : List<dynamic>.from(serviceTypes!.map((x) => x.toJson())),
    "media_gallery": mediaGallery == null ? [] : List<dynamic>.from(mediaGallery!.map((x) => x.toJson())),
  };
}

class MediaGallery {
  int? id;
  String? title;
  String? type;
  String? fileUrl;
  dynamic thumbnail;

  MediaGallery({
    this.id,
    this.title,
    this.type,
    this.fileUrl,
    this.thumbnail,
  });

  MediaGallery copyWith({
    int? id,
    String? title,
    String? type,
    String? fileUrl,
    dynamic thumbnail,
  }) =>
      MediaGallery(
        id: id ?? this.id,
        title: title ?? this.title,
        type: type ?? this.type,
        fileUrl: fileUrl ?? this.fileUrl,
        thumbnail: thumbnail ?? this.thumbnail,
      );

  factory MediaGallery.fromJson(Map<String, dynamic> json) => MediaGallery(
    id: json["id"],
    title: json["title"],
    type: json["type"],
    fileUrl: json["file_url"],
    thumbnail: json["thumbnail"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "type": type,
    "file_url": fileUrl,
    "thumbnail": thumbnail,
  };
}

class Service {
  int? id;
  String? name;
  String? image;
  String? thumbnail;
  List<Service>? services;
  String? price;

  Service({
    this.id,
    this.name,
    this.image,
    this.thumbnail,
    this.services,
    this.price,
  });

  Service copyWith({
    int? id,
    String? name,
    String? image,
    String? thumbnail,
    List<Service>? services,
    String? price,
  }) =>
      Service(
        id: id ?? this.id,
        name: name ?? this.name,
        image: image ?? this.image,
        thumbnail: thumbnail ?? this.thumbnail,
        services: services ?? this.services,
        price: price ?? this.price,
      );

  factory Service.fromJson(Map<String, dynamic> json) => Service(
    id: json["id"],
    name: json["name"],
    image: json["image"],
    thumbnail: json["thumbnail"],
    services: json["services"] == null ? [] : List<Service>.from(json["services"]!.map((x) => Service.fromJson(x))),
    price: json["price"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "image": image,
    "thumbnail": thumbnail,
    "services": services == null ? [] : List<dynamic>.from(services!.map((x) => x.toJson())),
    "price": price,
  };
}
