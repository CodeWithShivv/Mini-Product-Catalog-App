// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CartItemAdapter extends TypeAdapter<CartItem> {
  @override
  final int typeId = 3;

  @override
  CartItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CartItem(
      id: fields[0] as int,
      title: fields[1] as String,
      price: fields[2] as double,
      image: fields[3] as String,
      quantity: fields[4] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CartItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.quantity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartItemImpl _$$CartItemImplFromJson(Map<String, dynamic> json) =>
    _$CartItemImpl(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      price: (json['price'] as num).toDouble(),
      image: json['image'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$$CartItemImplToJson(_$CartItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'price': instance.price,
      'image': instance.image,
      'quantity': instance.quantity,
    };
