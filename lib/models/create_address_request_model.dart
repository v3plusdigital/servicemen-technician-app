// To parse this JSON data, do
//
//     final createAddressModel = createAddressModelFromJson(jsonString);

import 'dart:convert';

CreateAddressModel createAddressModelFromJson(String str) => CreateAddressModel.fromJson(json.decode(str));

String createAddressModelToJson(CreateAddressModel data) => json.encode(data.toJson());

class CreateAddressModel {
  int? customerAddressId;
  String addressType;
  String houseFlatNo;
  String buildingSocietyName;
  String landmark;
  String area;
  String city;
  String state;
  String pinCode;
  double latitude;
  double longitude;

  CreateAddressModel({
    required this.addressType,
     this.customerAddressId,
    required this.houseFlatNo,
    required this.buildingSocietyName,
    required this.landmark,
    required this.area,
    required this.city,
    required this.state,
    required this.pinCode,
    required this.latitude,
    required this.longitude,
  });

  factory CreateAddressModel.fromJson(Map<String, dynamic> json) => CreateAddressModel(
    addressType: json["address_type"],
    customerAddressId: json["customer_address_id"],
    houseFlatNo: json["house_flat_no"],
    buildingSocietyName: json["building_society_name"],
    landmark: json["landmark"],
    area: json["area"],
    city: json["city"],
    state: json["state"],
    pinCode: json["pincode"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "address_type": addressType,
    "customer_address_id": customerAddressId,
    "house_flat_no": houseFlatNo,
    "building_society_name": buildingSocietyName,
    "landmark": landmark,
    "area": area,
    "city": city,
    "state": state,
    "pincode": pinCode,
    "latitude": latitude,
    "longitude": longitude,
  };
}
