import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hive/hive.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';

part 'favorites_entity.freezed.dart';
part 'favorites_entity.g.dart';

@freezed
@HiveType(typeId: 4)
class FavoritesEntity with _$FavoritesEntity {
  const factory FavoritesEntity({
    @HiveField(0) required String id,
    @HiveField(1) required Product product,
  }) = _FavoritesEntity;

  factory FavoritesEntity.fromJson(Map<String, dynamic> json) =>
      _$FavoritesEntityFromJson(json);
}
