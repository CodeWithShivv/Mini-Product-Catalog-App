import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favourites_event.dart';
import 'package:mini_product_catalog_app/features/favorites/blocs/favourites_state.dart';
import 'package:mini_product_catalog_app/features/favorites/domain/entities/favorites_entity.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  final Box<FavoritesEntity> favoriteBox;

  FavoriteBloc(this.favoriteBox) : super(FavoriteInitial()) {
    on<LoadFavorites>(_onLoadFavorites);
    on<AddToFavorites>(_onAddToFavorites);
    on<RemoveFromFavorites>(_onRemoveFromFavorites);
    on<ClearFavorites>(_onClearFavorites);
  }

  void _onLoadFavorites(LoadFavorites event, Emitter<FavoriteState> emit) {
    emit(FavoriteLoaded(favoriteBox.values.toList()));
  }

  void _onAddToFavorites(AddToFavorites event, Emitter<FavoriteState> emit) {
    final updatedFavorites = List<FavoritesEntity>.from(favoriteBox.values);
    if (!updatedFavorites.any((item) => item.id == event.item.id)) {
      updatedFavorites.add(event.item);
      favoriteBox.put(event.item.id, event.item);
    }
    emit(FavoritesAdded());
    emit(FavoriteLoaded(updatedFavorites));
  }

  void _onRemoveFromFavorites(
      RemoveFromFavorites event, Emitter<FavoriteState> emit) {
    favoriteBox.delete(event.productId);
    emit(FavoriteLoaded(favoriteBox.values.toList()));
  }

  void _onClearFavorites(ClearFavorites event, Emitter<FavoriteState> emit) {
    favoriteBox.clear();
    emit(FavoriteLoaded([]));
  }
}
