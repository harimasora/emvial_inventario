// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'place_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaceItem _$PlaceItemFromJson(Map<String, dynamic> json) {
  return _PlaceItem.fromJson(json);
}

/// @nodoc
mixin _$PlaceItem {
  Place get place => throw _privateConstructorUsedError;
  Item get item => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlaceItemCopyWith<PlaceItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaceItemCopyWith<$Res> {
  factory $PlaceItemCopyWith(PlaceItem value, $Res Function(PlaceItem) then) =
      _$PlaceItemCopyWithImpl<$Res, PlaceItem>;
  @useResult
  $Res call({Place place, Item item});

  $PlaceCopyWith<$Res> get place;
  $ItemCopyWith<$Res> get item;
}

/// @nodoc
class _$PlaceItemCopyWithImpl<$Res, $Val extends PlaceItem>
    implements $PlaceItemCopyWith<$Res> {
  _$PlaceItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? place = null,
    Object? item = null,
  }) {
    return _then(_value.copyWith(
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as Place,
      item: null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as Item,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PlaceCopyWith<$Res> get place {
    return $PlaceCopyWith<$Res>(_value.place, (value) {
      return _then(_value.copyWith(place: value) as $Val);
    });
  }

  @override
  @pragma('vm:prefer-inline')
  $ItemCopyWith<$Res> get item {
    return $ItemCopyWith<$Res>(_value.item, (value) {
      return _then(_value.copyWith(item: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$PlaceItemImplCopyWith<$Res>
    implements $PlaceItemCopyWith<$Res> {
  factory _$$PlaceItemImplCopyWith(
          _$PlaceItemImpl value, $Res Function(_$PlaceItemImpl) then) =
      __$$PlaceItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({Place place, Item item});

  @override
  $PlaceCopyWith<$Res> get place;
  @override
  $ItemCopyWith<$Res> get item;
}

/// @nodoc
class __$$PlaceItemImplCopyWithImpl<$Res>
    extends _$PlaceItemCopyWithImpl<$Res, _$PlaceItemImpl>
    implements _$$PlaceItemImplCopyWith<$Res> {
  __$$PlaceItemImplCopyWithImpl(
      _$PlaceItemImpl _value, $Res Function(_$PlaceItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? place = null,
    Object? item = null,
  }) {
    return _then(_$PlaceItemImpl(
      place: null == place
          ? _value.place
          : place // ignore: cast_nullable_to_non_nullable
              as Place,
      item: null == item
          ? _value.item
          : item // ignore: cast_nullable_to_non_nullable
              as Item,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaceItemImpl implements _PlaceItem {
  const _$PlaceItemImpl({required this.place, required this.item});

  factory _$PlaceItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaceItemImplFromJson(json);

  @override
  final Place place;
  @override
  final Item item;

  @override
  String toString() {
    return 'PlaceItem(place: $place, item: $item)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaceItemImpl &&
            (identical(other.place, place) || other.place == place) &&
            (identical(other.item, item) || other.item == item));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, place, item);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaceItemImplCopyWith<_$PlaceItemImpl> get copyWith =>
      __$$PlaceItemImplCopyWithImpl<_$PlaceItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaceItemImplToJson(
      this,
    );
  }
}

abstract class _PlaceItem implements PlaceItem {
  const factory _PlaceItem(
      {required final Place place, required final Item item}) = _$PlaceItemImpl;

  factory _PlaceItem.fromJson(Map<String, dynamic> json) =
      _$PlaceItemImpl.fromJson;

  @override
  Place get place;
  @override
  Item get item;
  @override
  @JsonKey(ignore: true)
  _$$PlaceItemImplCopyWith<_$PlaceItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
