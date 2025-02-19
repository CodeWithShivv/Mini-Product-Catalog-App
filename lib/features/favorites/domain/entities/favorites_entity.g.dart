// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_entity.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritesEntityAdapter extends TypeAdapter<FavoritesEntity> {
  @override
  final int typeId = 4;

  @override
  FavoritesEntity read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoritesEntity(
      id: fields[0] as String,
      product: fields[1] as Product,
    );
  }

  @override
  void write(BinaryWriter writer, FavoritesEntity obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.product);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritesEntityAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$FavoritesEntityImpl _$$FavoritesEntityImplFromJson(
        Map<String, dynamic> json) =>
    _$FavoritesEntityImpl(
      id: json['id'] as String,
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$FavoritesEntityImplToJson(
        _$FavoritesEntityImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'product': instance.product,
    };
