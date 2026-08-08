// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'member_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MemberModel _$MemberModelFromJson(Map<String, dynamic> json) => _MemberModel(
  id: (json['id'] as num).toInt(),
  memberName: json['member_name'] as String,
  imageUrls:
      (json['image_url'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$MemberModelToJson(_MemberModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'member_name': instance.memberName,
      'image_url': instance.imageUrls,
    };
