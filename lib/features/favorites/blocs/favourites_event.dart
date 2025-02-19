import 'package:equatable/equatable.dart';
import 'package:mini_product_catalog_app/features/favorites/domain/entities/favorites_entity.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class LoadFavorites extends FavoriteEvent {}

class AddToFavorites extends FavoriteEvent {
  final FavoritesEntity item;

  const AddToFavorites(this.item);

  @override
  List<Object> get props => [item];
}

class RemoveFromFavorites extends FavoriteEvent {
  final String productId;

  const RemoveFromFavorites(this.productId);

  @override
  List<Object> get props => [productId];
}

class ClearFavorites extends FavoriteEvent {}
