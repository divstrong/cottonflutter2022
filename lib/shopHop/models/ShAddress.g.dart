// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShAddress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ShAddressModelAdapter extends TypeAdapter<ShAddressModel> {
  @override
  final int typeId = 1;

  @override
  ShAddressModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ShAddressModel(
      name: fields[0] as String,
      zip: fields[1] as String,
      region: fields[4] as String,
      city: fields[3] as String,
      address: fields[5] as String,
      country: fields[2] as String,
      email: fields[6] as String,
      phone: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ShAddressModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.zip)
      ..writeByte(2)
      ..write(obj.country)
      ..writeByte(3)
      ..write(obj.city)
      ..writeByte(4)
      ..write(obj.region)
      ..writeByte(5)
      ..write(obj.address)
      ..writeByte(6)
      ..write(obj.email)
      ..writeByte(7)
      ..write(obj.phone);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShAddressModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
