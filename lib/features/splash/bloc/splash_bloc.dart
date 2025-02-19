import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/features/products_listing/data/repositories/product_repository.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final ProductRepository productRepository;

  SplashBloc({
    required this.productRepository,
  }) : super(SplashInitial()) {
    on<AppInitialized>(_onAppInitialized);
  }

  Future<void> _onAppInitialized(
      AppInitialized event, Emitter<SplashState> emit) async {
    emit(SplashLoading());

    try {
      // await getIt<FirebaseService>().uploadProductsFromAssets();

      await productRepository.fetchProducts();

      emit(SplashSuccess());
    } catch (e) {
      emit(SplashFailure("Initialization failed: ${e.toString()}"));
    }
  }
}
