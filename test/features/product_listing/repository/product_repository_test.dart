import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database.dart';
import 'package:mini_product_catalog_app/core/data/local/app_database_constants.dart';
import 'package:mini_product_catalog_app/core/services/connectivity_service.dart';
import 'package:mini_product_catalog_app/core/services/dependency_locator.dart';
import 'package:mini_product_catalog_app/core/services/firebase_service.dart';
import 'package:mini_product_catalog_app/features/products_listing/data/repositories/product_repository.dart';
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart';
import '../../../mocks/mocks.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  late ProductRepository productRepository;
  late MockFirebaseService mockFirebaseService;
  late MockAppDatabase mockAppDatabase;
  late MockConnectivityService mockConnectivityService;

  setUp(() {
    mockFirebaseService = MockFirebaseService();
    mockAppDatabase = MockAppDatabase();
    mockConnectivityService = MockConnectivityService();

    // Registering mocked services in dependency injection
    getIt.registerSingleton<FirebaseService>(mockFirebaseService);
    getIt.registerSingleton<Logger>(Logger());
    getIt.registerSingleton<AppDatabase>(mockAppDatabase);
    getIt.registerSingleton<ConnectivityService>(mockConnectivityService);

    productRepository = ProductRepository();
  });

  tearDown(() {
    getIt.reset();
  });

  final testProducts = [
    Product(
      id: 3,
      title: "Mens Cotton Jacket",
      price: 55.99,
      description: "Great outerwear jackets for Spring/Autumn/Winter...",
      category: "men's clothing",
      image: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
      rating: Rating(rate: 4.7, count: 500),
    ),
    Product(
      id: 4,
      title: "Mens Casual Slim Fit",
      price: 15.99,
      description: "The color could be slightly different...",
      category: "men's clothing",
      image: "https://fakestoreapi.com/img/71YXzeOuslL._AC_UY879_.jpg",
      rating: Rating(rate: 2.1, count: 430),
    ),
    Product(
      id: 5,
      title:
          "John Hardy Women's Legends Naga Gold & Silver Dragon Station Chain Bracelet",
      price: 695,
      description: "From our Legends Collection, the Naga was inspired...",
      category: "jewelry",
      image: "https://fakestoreapi.com/img/71pWzhdJNwL._AC_UL640_QL65_ML3_.jpg",
      rating: Rating(rate: 4.6, count: 400),
    ),
  ];

  group('ProductRepository Tests', () {
    test('Fetch products when online', () async {
      // Arrange
      when(() => mockConnectivityService.isConnected())
          .thenAnswer((_) async => true);
      when(() => mockFirebaseService.fetchProducts())
          .thenAnswer((_) async => testProducts); // Stubbed fetchProducts

      // Act
      final products = await productRepository.fetchProducts();

      // Assert
      expect(products, isNotEmpty);
      expect(products.length, 3);
      expect(products[0].title, "Mens Cotton Jacket");
    });

    test('Fetch local products when offline', () async {
      // Arrange
      when(() => mockConnectivityService.isConnected())
          .thenAnswer((_) async => false);
      when(() => mockAppDatabase.getAllData(any()))
          .thenAnswer((_) async => testProducts);

      // Act
      final products = await productRepository.fetchProducts();

      // Assert
      expect(products, isNotEmpty);
      expect(products.length, 3);
      expect(products[1].title, "Mens Casual Slim Fit");
    });

    test('Sync products with local database', () async {
      // Arrange
      when(() => mockFirebaseService.fetchProducts())
          .thenAnswer((_) async => testProducts);
      when(() => mockAppDatabase.openBox<Product>(any()))
          .thenAnswer((_) async => MockBox());
      when(() => mockAppDatabase.getAllData(any())).thenAnswer((_) async => []);

      // Act
      await productRepository.syncProducts(testProducts);

      // Assert
      verify(() => mockAppDatabase
          .openBox<Product>(AppDataBaseConstants.productsBox)).called(1);
    });
  });
}
