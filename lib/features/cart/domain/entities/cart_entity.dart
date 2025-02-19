import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'cart_entity.freezed.dart';
part 'cart_entity.g.dart';

@freezed
@HiveType(typeId: 3)
class CartItem with _$CartItem {
  const factory CartItem({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required double price,
    @HiveField(3) required String image,
    @HiveField(4) required int quantity,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}
