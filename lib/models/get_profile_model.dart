// To parse this JSON data, do
//
//     final getProfileResponseModel = getProfileResponseModelFromJson(jsonString);

import 'dart:convert';

GetProfileResponseModel getProfileResponseModelFromJson(String str) => GetProfileResponseModel.fromJson(json.decode(str));

String getProfileResponseModelToJson(GetProfileResponseModel data) => json.encode(data.toJson());

class GetProfileResponseModel {
  bool? success;
  Data? data;

  GetProfileResponseModel({
    this.success,
    this.data,
  });

  GetProfileResponseModel copyWith({
    bool? success,
    Data? data,
  }) =>
      GetProfileResponseModel(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory GetProfileResponseModel.fromJson(Map<String, dynamic> json) => GetProfileResponseModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  Technician? technician;
  List<ServiceType>? serviceTypes;
  List<ServiceArea>? serviceAreas;
  List<IdProof>? idProofs;

  Data({
    this.technician,
    this.serviceTypes,
    this.serviceAreas,
    this.idProofs,
  });

  Data copyWith({
    Technician? technician,
    List<ServiceType>? serviceTypes,
    List<ServiceArea>? serviceAreas,
    List<IdProof>? idProofs,
  }) =>
      Data(
        technician: technician ?? this.technician,
        serviceTypes: serviceTypes ?? this.serviceTypes,
        serviceAreas: serviceAreas ?? this.serviceAreas,
        idProofs: idProofs ?? this.idProofs,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    technician: json["technician"] == null ? null : Technician.fromJson(json["technician"]),
    serviceTypes: json["service_types"] == null ? [] : List<ServiceType>.from(json["service_types"]!.map((x) => ServiceType.fromJson(x))),
    serviceAreas: json["service_areas"] == null ? [] : List<ServiceArea>.from(json["service_areas"]!.map((x) => ServiceArea.fromJson(x))),
    idProofs: json["id_proofs"] == null ? [] : List<IdProof>.from(json["id_proofs"]!.map((x) => IdProof.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "technician": technician?.toJson(),
    "service_types": serviceTypes == null ? [] : List<dynamic>.from(serviceTypes!.map((x) => x.toJson())),
    "service_areas": serviceAreas == null ? [] : List<dynamic>.from(serviceAreas!.map((x) => x.toJson())),
    "id_proofs": idProofs == null ? [] : List<dynamic>.from(idProofs!.map((x) => x.toJson())),
  };
}

class IdProof {
  int? id;
  String? idProofDocument;
  DateTime? createdAt;

  IdProof({
    this.id,
    this.idProofDocument,
    this.createdAt,
  });

  IdProof copyWith({
    int? id,
    String? idProofDocument,
    DateTime? createdAt,
  }) =>
      IdProof(
        id: id ?? this.id,
        idProofDocument: idProofDocument ?? this.idProofDocument,
        createdAt: createdAt ?? this.createdAt,
      );

  factory IdProof.fromJson(Map<String, dynamic> json) => IdProof(
    id: json["id"],
    idProofDocument: json["id_proof_document"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "id_proof_document": idProofDocument,
    "created_at": createdAt?.toIso8601String(),
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

class Technician {
  int? id;
  String? name;
  String? phone;
  String? email;
  String? skillsDescription;
  String? experience;
  ProfilePhoto? profilePhoto;
  bool? isApproved;
  bool? isBlocked;
  bool? isOnline;
  dynamic currentLatitude;
  dynamic currentLongitude;
  DateTime? lastLoginAt;
  DateTime? createdAt;

  Technician({
    this.id,
    this.name,
    this.phone,
    this.email,
    this.skillsDescription,
    this.experience,
    this.profilePhoto,
    this.isApproved,
    this.isBlocked,
    this.isOnline,
    this.currentLatitude,
    this.currentLongitude,
    this.lastLoginAt,
    this.createdAt,
  });

  Technician copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? skillsDescription,
    String? experience,
    ProfilePhoto? profilePhoto,
    bool? isApproved,
    bool? isBlocked,
    bool? isOnline,
    dynamic currentLatitude,
    dynamic currentLongitude,
    DateTime? lastLoginAt,
    DateTime? createdAt,
  }) =>
      Technician(
        id: id ?? this.id,
        name: name ?? this.name,
        phone: phone ?? this.phone,
        email: email ?? this.email,
        skillsDescription: skillsDescription ?? this.skillsDescription,
        experience: experience ?? this.experience,
        profilePhoto: profilePhoto ?? this.profilePhoto,
        isApproved: isApproved ?? this.isApproved,
        isBlocked: isBlocked ?? this.isBlocked,
        isOnline: isOnline ?? this.isOnline,
        currentLatitude: currentLatitude ?? this.currentLatitude,
        currentLongitude: currentLongitude ?? this.currentLongitude,
        lastLoginAt: lastLoginAt ?? this.lastLoginAt,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Technician.fromJson(Map<String, dynamic> json) => Technician(
    id: json["id"],
    name: json["name"],
    phone: json["phone"],
    email: json["email"],
    skillsDescription: json["skills_description"],
    experience: json["experience"],
    profilePhoto: json["profile_photo"] == null ? null : ProfilePhoto.fromJson(json["profile_photo"]),
    isApproved: json["is_approved"],
    isBlocked: json["is_blocked"],
    isOnline: json["is_online"],
    currentLatitude: json["current_latitude"],
    currentLongitude: json["current_longitude"],
    lastLoginAt: json["last_login_at"] == null ? null : DateTime.parse(json["last_login_at"]),
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "phone": phone,
    "email": email,
    "skills_description": skillsDescription,
    "experience": experience,
    "profile_photo": profilePhoto?.toJson(),
    "is_approved": isApproved,
    "is_blocked": isBlocked,
    "is_online": isOnline,
    "current_latitude": currentLatitude,
    "current_longitude": currentLongitude,
    "last_login_at": lastLoginAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
  };
}

class ProfilePhoto {
  String? original;
  String? thumb;

  ProfilePhoto({
    this.original,
    this.thumb,
  });

  ProfilePhoto copyWith({
    String? original,
    String? thumb,
  }) =>
      ProfilePhoto(
        original: original ?? this.original,
        thumb: thumb ?? this.thumb,
      );

  factory ProfilePhoto.fromJson(Map<String, dynamic> json) => ProfilePhoto(
    original: json["original"],
    thumb: json["thumb"],
  );

  Map<String, dynamic> toJson() => {
    "original": original,
    "thumb": thumb,
  };
}
