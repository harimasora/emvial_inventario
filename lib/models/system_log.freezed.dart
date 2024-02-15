// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'system_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SystemLog _$SystemLogFromJson(Map<String, dynamic> json) {
  return _SystemLog.fromJson(json);
}

/// @nodoc
mixin _$SystemLog {
  String get text => throw _privateConstructorUsedError;
  String get itemId => throw _privateConstructorUsedError;
  String get placeId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  @ServerTimestampConverter()
  DateTime get timestamp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $SystemLogCopyWith<SystemLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SystemLogCopyWith<$Res> {
  factory $SystemLogCopyWith(SystemLog value, $Res Function(SystemLog) then) =
      _$SystemLogCopyWithImpl<$Res, SystemLog>;
  @useResult
  $Res call(
      {String text,
      String itemId,
      String placeId,
      String userId,
      @ServerTimestampConverter() DateTime timestamp});
}

/// @nodoc
class _$SystemLogCopyWithImpl<$Res, $Val extends SystemLog>
    implements $SystemLogCopyWith<$Res> {
  _$SystemLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? itemId = null,
    Object? placeId = null,
    Object? userId = null,
    Object? timestamp = null,
  }) {
    return _then(_value.copyWith(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SystemLogImplCopyWith<$Res>
    implements $SystemLogCopyWith<$Res> {
  factory _$$SystemLogImplCopyWith(
          _$SystemLogImpl value, $Res Function(_$SystemLogImpl) then) =
      __$$SystemLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String text,
      String itemId,
      String placeId,
      String userId,
      @ServerTimestampConverter() DateTime timestamp});
}

/// @nodoc
class __$$SystemLogImplCopyWithImpl<$Res>
    extends _$SystemLogCopyWithImpl<$Res, _$SystemLogImpl>
    implements _$$SystemLogImplCopyWith<$Res> {
  __$$SystemLogImplCopyWithImpl(
      _$SystemLogImpl _value, $Res Function(_$SystemLogImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? text = null,
    Object? itemId = null,
    Object? placeId = null,
    Object? userId = null,
    Object? timestamp = null,
  }) {
    return _then(_$SystemLogImpl(
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      itemId: null == itemId
          ? _value.itemId
          : itemId // ignore: cast_nullable_to_non_nullable
              as String,
      placeId: null == placeId
          ? _value.placeId
          : placeId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SystemLogImpl implements _SystemLog {
  const _$SystemLogImpl(
      {this.text = '',
      this.itemId = '',
      this.placeId = '',
      this.userId = '',
      @ServerTimestampConverter() required this.timestamp});

  factory _$SystemLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$SystemLogImplFromJson(json);

  @override
  @JsonKey()
  final String text;
  @override
  @JsonKey()
  final String itemId;
  @override
  @JsonKey()
  final String placeId;
  @override
  @JsonKey()
  final String userId;
  @override
  @ServerTimestampConverter()
  final DateTime timestamp;

  @override
  String toString() {
    return 'SystemLog(text: $text, itemId: $itemId, placeId: $placeId, userId: $userId, timestamp: $timestamp)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SystemLogImpl &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.itemId, itemId) || other.itemId == itemId) &&
            (identical(other.placeId, placeId) || other.placeId == placeId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, text, itemId, placeId, userId, timestamp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SystemLogImplCopyWith<_$SystemLogImpl> get copyWith =>
      __$$SystemLogImplCopyWithImpl<_$SystemLogImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SystemLogImplToJson(
      this,
    );
  }
}

abstract class _SystemLog implements SystemLog {
  const factory _SystemLog(
          {final String text,
          final String itemId,
          final String placeId,
          final String userId,
          @ServerTimestampConverter() required final DateTime timestamp}) =
      _$SystemLogImpl;

  factory _SystemLog.fromJson(Map<String, dynamic> json) =
      _$SystemLogImpl.fromJson;

  @override
  String get text;
  @override
  String get itemId;
  @override
  String get placeId;
  @override
  String get userId;
  @override
  @ServerTimestampConverter()
  DateTime get timestamp;
  @override
  @JsonKey(ignore: true)
  _$$SystemLogImplCopyWith<_$SystemLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
