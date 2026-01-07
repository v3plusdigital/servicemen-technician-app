// To parse this JSON data, do
//
//     final getAddressListModel = getAddressListModelFromJson(jsonString);

import 'dart:convert';

GetAddressListModel getAddressListModelFromJson(String str) => GetAddressListModel.fromJson(json.decode(str));

String getAddressListModelToJson(GetAddressListModel data) => json.encode(data.toJson());

class GetAddressListModel {
  bool? success;
  Data? data;

  GetAddressListModel({
    this.success,
    this.data,
  });

  GetAddressListModel copyWith({
    bool? success,
    Data? data,
  }) =>
      GetAddressListModel(
        success: success ?? this.success,
        data: data ?? this.data,
      );

  factory GetAddressListModel.fromJson(Map<String, dynamic> json) => GetAddressListModel(
    success: json["success"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "data": data?.toJson(),
  };
}

class Data {
  List<Address>? addresses;
  int? total;

  Data({
    this.addresses,
    this.total,
  });

  Data copyWith({
    List<Address>? addresses,
    int? total,
  }) =>
      Data(
        addresses: addresses ?? this.addresses,
        total: total ?? this.total,
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    addresses: json["addresses"] == null ? [] : List<Address>.from(json["addresses"]!.map((x) => Address.fromJson(x))),
    total: json["total"],
  );

  Map<String, dynamic> toJson() => {
    "addresses": addresses == null ? [] : List<dynamic>.from(addresses!.map((x) => x.toJson())),
    "total": total,
  };
}

class Address {
  int? id;
  String? addressType;
  String? houseFlatNo;
  String? buildingSocietyName;
  String? landmark;
  String? area;
  String? city;
  String? state;
  String? pincode;
  String? latitude;
  String? longitude;
  bool? isDefault;
  DateTime? createdAt;

  Address({
    this.id,
    this.addressType,
    this.houseFlatNo,
    this.buildingSocietyName,
    this.landmark,
    this.area,
    this.city,
    this.state,
    this.pincode,
    this.latitude,
    this.longitude,
    this.isDefault,
    this.createdAt,
  });

  Address copyWith({
    int? id,
    String? addressType,
    String? houseFlatNo,
    String? buildingSocietyName,
    String? landmark,
    String? area,
    String? city,
    String? state,
    String? pincode,
    String? latitude,
    String? longitude,
    bool? isDefault,
    DateTime? createdAt,
  }) =>
      Address(
        id: id ?? this.id,
        addressType: addressType ?? this.addressType,
        houseFlatNo: houseFlatNo ?? this.houseFlatNo,
        buildingSocietyName: buildingSocietyName ?? this.buildingSocietyName,
        landmark: landmark ?? this.landmark,
        area: area ?? this.area,
        city: city ?? this.city,
        state: state ?? this.state,
        pincode: pincode ?? this.pincode,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        isDefault: isDefault ?? this.isDefault,
        createdAt: createdAt ?? this.createdAt,
      );

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    id: json["id"],
    addressType: json["address_type"],
    houseFlatNo: json["house_flat_no"],
    buildingSocietyName: json["building_society_name"],
    landmark: json["landmark"],
    area: json["area"],
    city: json["city"],
    state: json["state"],
    pincode: json["pincode"],
    latitude: json["latitude"],
    longitude: json["longitude"],
    isDefault: json["is_default"],
    createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "address_type": addressType,
    "house_flat_no": houseFlatNo,
    "building_society_name": buildingSocietyName,
    "landmark": landmark,
    "area": area,
    "city": city,
    "state": state,
    "pincode": pincode,
    "latitude": latitude,
    "longitude": longitude,
    "is_default": isDefault,
    "created_at": createdAt?.toIso8601String(),
  };
}
