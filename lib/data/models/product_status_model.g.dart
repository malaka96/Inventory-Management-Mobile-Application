// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_status_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductStatusModelAdapter extends TypeAdapter<ProductStatusModel> {
  @override
  final int typeId = 2;

  @override
  ProductStatusModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductStatusModel(
      productName: fields[0] as String,
      status: fields[1] as bool,
      timestamp: fields[2] as DateTime,
      value: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ProductStatusModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.productName)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.timestamp)
      ..writeByte(3)
      ..write(obj.value);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductStatusModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
