// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PlaceItemImpl _$$PlaceItemImplFromJson(Map<String, dynamic> json) =>
    _$PlaceItemImpl(
      place: Place.fromJson(json['place'] as Map<String, dynamic>),
      item: Item.fromJson(json['item'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$PlaceItemImplToJson(_$PlaceItemImpl instance) =>
    <String, dynamic>{
      'place': instance.place.toJson(),
      'item': instance.item.toJson(),
    };
