// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_history.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ItemHistory _$ItemHistoryFromJson(Map<String, dynamic> json) {
  return _ItemHistory.fromJson(json);
}

/// @nodoc
mixin _$ItemHistory {
  String get imageUrl => throw _privateConstructorUsedError;
  List<SystemLog> get logs => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ItemHistoryCopyWith<ItemHistory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ItemHistoryCopyWith<$Res> {
  factory $ItemHistoryCopyWith(
          ItemHistory value, $Res Function(ItemHistory) then) =
      _$ItemHistoryCopyWithImpl<$Res, ItemHistory>;
  @useResult
  $Res call({String imageUrl, List<SystemLog> logs});
}

/// @nodoc
class _$ItemHistoryCopyWithImpl<$Res, $Val extends ItemHistory>
    implements $ItemHistoryCopyWith<$Res> {
  _$ItemHistoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = null,
    Object? logs = null,
  }) {
    return _then(_value.copyWith(
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      logs: null == logs
          ? _value.logs
          : logs // ignore: cast_nullable_to_non_nullable
              as List<SystemLog>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ItemHistoryImplCopyWith<$Res>
    implements $ItemHistoryCopyWith<$Res> {
  factory _$$ItemHistoryImplCopyWith(
          _$ItemHistoryImpl value, $Res Function(_$ItemHistoryImpl) then) =
      __$$ItemHistoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String imageUrl, List<SystemLog> logs});
}

/// @nodoc
class __$$ItemHistoryImplCopyWithImpl<$Res>
    extends _$ItemHistoryCopyWithImpl<$Res, _$ItemHistoryImpl>
    implements _$$ItemHistoryImplCopyWith<$Res> {
  __$$ItemHistoryImplCopyWithImpl(
      _$ItemHistoryImpl _value, $Res Function(_$ItemHistoryImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? imageUrl = null,
    Object? logs = null,
  }) {
    return _then(_$ItemHistoryImpl(
      imageUrl: null == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String,
      logs: null == logs
          ? _value._logs
          : logs // ignore: cast_nullable_to_non_nullable
              as List<SystemLog>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ItemHistoryImpl implements _ItemHistory {
  const _$ItemHistoryImpl(
      {required this.imageUrl, required final List<SystemLog> logs})
      : _logs = logs;

  factory _$ItemHistoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ItemHistoryImplFromJson(json);

  @override
  final String imageUrl;
  final List<SystemLog> _logs;
  @override
  List<SystemLog> get logs {
    if (_logs is EqualUnmodifiableListView) return _logs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_logs);
  }

  @override
  String toString() {
    return 'ItemHistory(imageUrl: $imageUrl, logs: $logs)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ItemHistoryImpl &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            const DeepCollectionEquality().equals(other._logs, _logs));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType, imageUrl, const DeepCollectionEquality().hash(_logs));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ItemHistoryImplCopyWith<_$ItemHistoryImpl> get copyWith =>
      __$$ItemHistoryImplCopyWithImpl<_$ItemHistoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ItemHistoryImplToJson(
      this,
    );
  }
}

abstract class _ItemHistory implements ItemHistory {
  const factory _ItemHistory(
      {required final String imageUrl,
      required final List<SystemLog> logs}) = _$ItemHistoryImpl;

  factory _ItemHistory.fromJson(Map<String, dynamic> json) =
      _$ItemHistoryImpl.fromJson;

  @override
  String get imageUrl;
  @override
  List<SystemLog> get logs;
  @override
  @JsonKey(ignore: true)
  _$$ItemHistoryImplCopyWith<_$ItemHistoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
