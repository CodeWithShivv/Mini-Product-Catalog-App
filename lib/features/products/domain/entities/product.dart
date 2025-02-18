import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
@HiveType(typeId: 1)
class Product with _$Product {
  factory Product({
    @HiveField(0) required int id,
    @HiveField(1) required String title,
    @HiveField(2) required double price,
    @HiveField(3) required String description,
    @HiveField(4) required String category,
    @HiveField(5) required String image,
    @HiveField(6) required Rating rating,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
@HiveType(typeId: 2)
class Rating with _$Rating {
  factory Rating({
    @HiveField(0) required double rate,
    @HiveField(1) required int count,
  }) = _Rating;

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);
}
