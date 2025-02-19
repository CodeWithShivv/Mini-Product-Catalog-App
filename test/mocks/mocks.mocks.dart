// Mocks generated by Mockito 5.4.5 from annotations
// in mini_product_catalog_app/test/mocks/mocks.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i6;

import 'package:cloud_firestore/cloud_firestore.dart' as _i2;
import 'package:hive/hive.dart' as _i4;
import 'package:logger/logger.dart' as _i3;
import 'package:mini_product_catalog_app/core/data/local/app_database.dart'
    as _i8;
import 'package:mini_product_catalog_app/core/services/connectivity_service.dart'
    as _i9;
import 'package:mini_product_catalog_app/core/services/firebase_service.dart'
    as _i5;
import 'package:mini_product_catalog_app/features/products_listing/domain/entities/product.dart'
    as _i7;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeFirebaseFirestore_0 extends _i1.SmartFake
    implements _i2.FirebaseFirestore {
  _FakeFirebaseFirestore_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeLogger_1 extends _i1.SmartFake implements _i3.Logger {
  _FakeLogger_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeBox_2<E> extends _i1.SmartFake implements _i4.Box<E> {
  _FakeBox_2(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [FirebaseService].
///
/// See the documentation for Mockito's code generation for more information.
class MockFirebaseService extends _i1.Mock implements _i5.FirebaseService {
  MockFirebaseService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.FirebaseFirestore get firestore => (super.noSuchMethod(
        Invocation.getter(#firestore),
        returnValue: _FakeFirebaseFirestore_0(
          this,
          Invocation.getter(#firestore),
        ),
      ) as _i2.FirebaseFirestore);

  @override
  _i6.Future<void> initialize() => (super.noSuchMethod(
        Invocation.method(
          #initialize,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<List<_i7.Product>> fetchProducts() => (super.noSuchMethod(
        Invocation.method(
          #fetchProducts,
          [],
        ),
        returnValue: _i6.Future<List<_i7.Product>>.value(<_i7.Product>[]),
      ) as _i6.Future<List<_i7.Product>>);

  @override
  _i6.Future<List<_i7.Product>> searchProducts(String? query) =>
      (super.noSuchMethod(
        Invocation.method(
          #searchProducts,
          [query],
        ),
        returnValue: _i6.Future<List<_i7.Product>>.value(<_i7.Product>[]),
      ) as _i6.Future<List<_i7.Product>>);

  @override
  _i6.Future<void> uploadProductsFromAssets() => (super.noSuchMethod(
        Invocation.method(
          #uploadProductsFromAssets,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> uploadProducts(List<_i7.Product>? products) =>
      (super.noSuchMethod(
        Invocation.method(
          #uploadProducts,
          [products],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [AppDatabase].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppDatabase extends _i1.Mock implements _i8.AppDatabase {
  MockAppDatabase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Logger get logger => (super.noSuchMethod(
        Invocation.getter(#logger),
        returnValue: _FakeLogger_1(
          this,
          Invocation.getter(#logger),
        ),
      ) as _i3.Logger);

  @override
  _i6.Future<void> initialize() => (super.noSuchMethod(
        Invocation.method(
          #initialize,
          [],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<_i4.Box<T>> openBox<T>(String? boxName) => (super.noSuchMethod(
        Invocation.method(
          #openBox,
          [boxName],
        ),
        returnValue: _i6.Future<_i4.Box<T>>.value(_FakeBox_2<T>(
          this,
          Invocation.method(
            #openBox,
            [boxName],
          ),
        )),
      ) as _i6.Future<_i4.Box<T>>);

  @override
  _i6.Future<void> saveData<T>(
    String? boxName,
    String? key,
    T? data,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #saveData,
          [
            boxName,
            key,
            data,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<T?> getData<T>(
    String? boxName,
    String? key,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #getData,
          [
            boxName,
            key,
          ],
        ),
        returnValue: _i6.Future<T?>.value(),
      ) as _i6.Future<T?>);

  @override
  _i6.Future<List<T>> getAllData<T>(String? boxName) => (super.noSuchMethod(
        Invocation.method(
          #getAllData,
          [boxName],
        ),
        returnValue: _i6.Future<List<T>>.value(<T>[]),
      ) as _i6.Future<List<T>>);

  @override
  _i6.Future<void> deleteData(
    String? boxName,
    String? key,
  ) =>
      (super.noSuchMethod(
        Invocation.method(
          #deleteData,
          [
            boxName,
            key,
          ],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);

  @override
  _i6.Future<void> clearBox(String? boxName) => (super.noSuchMethod(
        Invocation.method(
          #clearBox,
          [boxName],
        ),
        returnValue: _i6.Future<void>.value(),
        returnValueForMissingStub: _i6.Future<void>.value(),
      ) as _i6.Future<void>);
}

/// A class which mocks [ConnectivityService].
///
/// See the documentation for Mockito's code generation for more information.
class MockConnectivityService extends _i1.Mock
    implements _i9.ConnectivityService {
  MockConnectivityService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i6.Stream<bool> get connectivityStream => (super.noSuchMethod(
        Invocation.getter(#connectivityStream),
        returnValue: _i6.Stream<bool>.empty(),
      ) as _i6.Stream<bool>);

  @override
  _i6.Future<bool> isConnected() => (super.noSuchMethod(
        Invocation.method(
          #isConnected,
          [],
        ),
        returnValue: _i6.Future<bool>.value(false),
      ) as _i6.Future<bool>);

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );
}
