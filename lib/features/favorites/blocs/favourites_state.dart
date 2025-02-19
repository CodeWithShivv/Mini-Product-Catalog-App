import 'package:equatable/equatable.dart';
import 'package:mini_product_catalog_app/features/favorites/domain/entities/favorites_entity.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class FavoriteLoading extends FavoriteState {}

class FavoriteLoaded extends FavoriteState {
  final List<FavoritesEntity> favoriteItems;

  const FavoriteLoaded(this.favoriteItems);

  @override
  List<Object> get props => [favoriteItems];
}

class FavoriteError extends FavoriteState {
  final String message;

  const FavoriteError(this.message);

  @override
  List<Object> get props => [message];
}

class FavoritesAdded extends FavoriteState {}
