import 'package:hive/hive.dart';

part 'ShAddress.g.dart';

@HiveType(typeId: 1)
class ShAddressModel {
  @HiveField(0)
  String name;
  @HiveField(1)
  String zip;
  @HiveField(2)
  String country;
  @HiveField(3)
  String city;
  @HiveField(4)
  String region;
  @HiveField(5)
  String address;
  @HiveField(6)
  String email;
  @HiveField(7)
  String phone;

  ShAddressModel({
    required this.name,
    required this.zip,
    required this.region,
    required this.city,
    required this.address,
    required this.country,
    required this.email,
    required this.phone,
  });

  ShAddressModel.empty()
      : name = '',
        zip = '',
        city = '',
        region = '',
        address = '',
        country = '',
        email = '',
        phone = '';

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['zip'] = this.zip;
    data['city'] = this.city;
    data['region'] = this.region;
    data['address'] = this.address;
    data['country'] = this.country;
    data['email'] = this.email;
    data['phone'] = this.phone;
    return data;
  }

  @override
  bool operator ==(covariant ShAddressModel other) =>
      other.name == name &&
      other.zip == zip &&
      other.country == country &&
      other.city == city &&
      other.region == region &&
      other.address == address &&
      other.email == email &&
      other.phone == phone;

  @override
  int get hashCode => Object.hash(
    name,
        zip,
        country,
        city,
        region,
        address,
        email,
        phone,
      );
}
