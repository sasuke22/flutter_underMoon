// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'MeetingDetail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MeetingDetail _$MeetingDetailFromJson(Map<String, dynamic> json) {
  return MeetingDetail(
      json['meetingId'] as int,
      json['id'] as int,
      json['city'] as String,
      json['age'] as int,
      json['height'] as int,
      json['summary'] as String,
      json['approve'] as int,
      date:
          json['date'] == null ? null : DateTime.parse(json['date'] as String))
    ..read = json['read'] as bool
    ..type = json['type'] as String
    ..loveType = json['loveType'] as String
    ..marry = json['marry'] as int
    ..job = json['job'] as String
    ..figure = json['figure'] as String
    ..xingzuo = json['xingzuo'] as String
    ..content = json['content'] as String
    ..registId = json['registId'] as String
    ..enlistersName = json['enlistersName'] as String
    ..score = json['score'] as int
    ..pics = json['pics'] as int
    ..reason = json['reason'] as String;
}

Map<String, dynamic> _$MeetingDetailToJson(MeetingDetail instance) =>
    <String, dynamic>{
      'meetingId': instance.meetingId,
      'id': instance.id,
      'city': instance.city,
      'summary': instance.summary,
      'date': instance.date?.toIso8601String(),
      'read': instance.read,
      'approve': instance.approve,
      'type': instance.type,
      'loveType': instance.loveType,
      'age': instance.age,
      'marry': instance.marry,
      'height': instance.height,
      'job': instance.job,
      'figure': instance.figure,
      'xingzuo': instance.xingzuo,
      'content': instance.content,
      'registId': instance.registId,
      'enlistersName': instance.enlistersName,
      'score': instance.score,
      'pics': instance.pics,
      'reason': instance.reason
    };
