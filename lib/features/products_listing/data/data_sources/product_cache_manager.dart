import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ProductCacheManager extends CacheManager {
  static const key = "customProductCache";

  static final instance = ProductCacheManager._internal();

  ProductCacheManager._internal()
      : super(Config(
          key,
          stalePeriod: const Duration(days: 2),
          maxNrOfCacheObjects: 100,
        ));
}
