// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MeetingsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingsModel _$MeetingsModelFromJson(Map<String, dynamic> json) {
  return MeetingsModel((json['meetings'] as List)
      ?.map((e) =>
          e == null ? null : MeetingDetail.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$MeetingsModelToJson(MeetingsModel instance) =>
    <String, dynamic>{'meetings': instance.meetings};
