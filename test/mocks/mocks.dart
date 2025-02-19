import 'package:hive/hive.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';
import 'package:mockito/annotations.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database.dart';
import 'package:mini_product_catalog_app/core/services/connectivity_service.dart';
// test/mocks/mocks.dart
import 'package:mocktail/mocktail.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database.dart';
import 'package:mini_product_catalog_app/core/services/connectivity_service.dart';

@GenerateMocks([FirebaseService, AppDatabase, ConnectivityService])
void main() {}

// Mock classes
class MockFirebaseService extends Mock implements FirebaseService {}

class MockAppDatabase extends Mock implements AppDatabase {
  @override
  Future<List<T>> getAllData<T>(String boxName) {
    return super.noSuchMethod(
      Invocation.method(#getAllData, [boxName]),
    );
  }
}

class MockConnectivityService extends Mock implements ConnectivityService {}

// Mock Box class for testing
class MockBox extends Mock implements Box<Product> {}
