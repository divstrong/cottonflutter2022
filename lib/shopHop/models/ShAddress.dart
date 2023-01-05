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
  String? phone;

  ShAddressModel({
    required this.name,
    required this.zip,
    required this.region,
    required this.city,
    required this.address,
    required this.country,
    this.phone,
  });

  ShAddressModel.empty()
      : name = '',
        zip = '',
        city = '',
        region = '',
        address = '',
        country = '',
        phone = null;

  @override
  bool operator ==(covariant ShAddressModel other) =>
      other.name == name &&
      other.zip == zip &&
      other.country == country &&
      other.city == city &&
      other.region == region &&
      other.address == address &&
      other.phone == phone;

  @override
  int get hashCode => Object.hash(
        name,
        zip,
        country,
        city,
        region,
        address,
        phone,
      );
}
