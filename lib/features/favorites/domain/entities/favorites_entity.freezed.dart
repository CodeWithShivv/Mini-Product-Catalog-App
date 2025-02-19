// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'favorites_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

FavoritesEntity _$FavoritesEntityFromJson(Map<String, dynamic> json) {
  return _FavoritesEntity.fromJson(json);
}

/// @nodoc
mixin _$FavoritesEntity {
  @HiveField(0)
  String get id => throw _privateConstructorUsedError;
  @HiveField(1)
  Product get product => throw _privateConstructorUsedError;

  /// Serializes this FavoritesEntity to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of FavoritesEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $FavoritesEntityCopyWith<FavoritesEntity> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FavoritesEntityCopyWith<$Res> {
  factory $FavoritesEntityCopyWith(
          FavoritesEntity value, $Res Function(FavoritesEntity) then) =
      _$FavoritesEntityCopyWithImpl<$Res, FavoritesEntity>;
  @useResult
  $Res call({@HiveField(0) String id, @HiveField(1) Product product});

  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class _$FavoritesEntityCopyWithImpl<$Res, $Val extends FavoritesEntity>
    implements $FavoritesEntityCopyWith<$Res> {
  _$FavoritesEntityCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of FavoritesEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? product = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
    ) as $Val);
  }

  /// Create a copy of FavoritesEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ProductCopyWith<$Res> get product {
    return $ProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$FavoritesEntityImplCopyWith<$Res>
    implements $FavoritesEntityCopyWith<$Res> {
  factory _$$FavoritesEntityImplCopyWith(_$FavoritesEntityImpl value,
          $Res Function(_$FavoritesEntityImpl) then) =
      __$$FavoritesEntityImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({@HiveField(0) String id, @HiveField(1) Product product});

  @override
  $ProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$FavoritesEntityImplCopyWithImpl<$Res>
    extends _$FavoritesEntityCopyWithImpl<$Res, _$FavoritesEntityImpl>
    implements _$$FavoritesEntityImplCopyWith<$Res> {
  __$$FavoritesEntityImplCopyWithImpl(
      _$FavoritesEntityImpl _value, $Res Function(_$FavoritesEntityImpl) _then)
      : super(_value, _then);

  /// Create a copy of FavoritesEntity
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? product = null,
  }) {
    return _then(_$FavoritesEntityImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      product: null == product
          ? _value.product
          : product // ignore: cast_nullable_to_non_nullable
              as Product,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$FavoritesEntityImpl implements _FavoritesEntity {
  const _$FavoritesEntityImpl(
      {@HiveField(0) required this.id, @HiveField(1) required this.product});

  factory _$FavoritesEntityImpl.fromJson(Map<String, dynamic> json) =>
      _$$FavoritesEntityImplFromJson(json);

  @override
  @HiveField(0)
  final String id;
  @override
  @HiveField(1)
  final Product product;

  @override
  String toString() {
    return 'FavoritesEntity(id: $id, product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$FavoritesEntityImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.product, product) || other.product == product));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, product);

  /// Create a copy of FavoritesEntity
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$FavoritesEntityImplCopyWith<_$FavoritesEntityImpl> get copyWith =>
      __$$FavoritesEntityImplCopyWithImpl<_$FavoritesEntityImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$FavoritesEntityImplToJson(
      this,
    );
  }
}

abstract class _FavoritesEntity implements FavoritesEntity {
  const factory _FavoritesEntity(
      {@HiveField(0) required final String id,
      @HiveField(1) required final Product product}) = _$FavoritesEntityImpl;

  factory _FavoritesEntity.fromJson(Map<String, dynamic> json) =
      _$FavoritesEntityImpl.fromJson;

  @override
  @HiveField(0)
  String get id;
  @override
  @HiveField(1)
  Product get product;

  /// Create a copy of FavoritesEntity
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$FavoritesEntityImplCopyWith<_$FavoritesEntityImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
