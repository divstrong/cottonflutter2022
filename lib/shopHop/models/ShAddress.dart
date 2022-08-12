class ShAddressModel {
  String name;
  String zip;
  String country;
  String city;
  String region;
  String address;
  String email;

  ShAddressModel({ required this.name, required this.zip, required this.region, required this.city, required this.address, required this.country,required this.email});

  factory ShAddressModel.fromJson(Map<String, dynamic> json) {
    return ShAddressModel(
      name: json['company']??'',
      zip: json['zip']??'',
      city: json['city']??'',
      region: json['region']??'',
      address: json['phone']??'',
      country: json['country']??'',
      email: json['email']??'',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['company'] = this.name;
    data['zip'] = this.zip;
    data['country'] = this.country;
    data['city'] = this.city;
    data['region'] = this.region;
    data['phone'] = this.address;
    data['email'] = this.email;
    return data;
  }
}
