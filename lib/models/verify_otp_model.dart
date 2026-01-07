// To parse this JSON data, do
//
//     final verifyOtpModel = verifyOtpModelFromJson(jsonString);

import 'dart:convert';

VerifyOtpModel verifyOtpModelFromJson(String str) => VerifyOtpModel.fromJson(json.decode(str));

String verifyOtpModelToJson(VerifyOtpModel data) => json.encode(data.toJson());

class VerifyOtpModel {
  bool? success;
  Data? data;

  VerifyOtpModel({
    this.success,
    this.data,
  });

  VerifyOtpModel copyWith({
    bool? success,
    Data? data,
  }) =>
      VerifyOtpModel(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory VerifyOtpModel.fromJson(Map<String, dynamic> json) => VerifyOtpModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  String? accessToken;
  String? refreshToken;
  String? tokenType;
  int? expiresIn;
  bool? isNewUser;
  Technician? technician;

  Data({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
    this.isNewUser,
    this.technician,
  });

  Data copyWith({
    String? accessToken,
    String? refreshToken,
    String? tokenType,
    int? expiresIn,
    bool? isNewUser,
    Technician? technician,
  }) =>
      Data(
        accessToken: accessToken ?? this.accessToken,
        refreshToken: refreshToken ?? this.refreshToken,
        tokenType: tokenType ?? this.tokenType,
        expiresIn: expiresIn ?? this.expiresIn,
        isNewUser: isNewUser ?? this.isNewUser,
        technician: technician ?? this.technician,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    accessToken: json["access_token"],
    refreshToken: json["refresh_token"],
    tokenType: json["token_type"],
    expiresIn: json["expires_in"],
    isNewUser: json["is_new_user"],
    technician: json["technician"] == null ? null : Technician.fromJson(json["technician"]),
  );

  Map<String, dynamic> toJson() => {
    "access_token": accessToken,
    "refresh_token": refreshToken,
    "token_type": tokenType,
    "expires_in": expiresIn,
    "is_new_user": isNewUser,
    "technician": technician?.toJson(),
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
  String? currentLatitude;
  String? currentLongitude;
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
    String? currentLatitude,
    String? currentLongitude,
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
