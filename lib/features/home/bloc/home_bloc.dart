import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/features/home/data/home_repository.dart';

class HomeBloc extends Cubit<int> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(0);

  void fetchProducts() {
    repository.fetchProducts();
    emit(1);
  }
}
