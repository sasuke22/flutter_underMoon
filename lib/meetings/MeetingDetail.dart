import 'package:json_annotation/json_annotation.dart';
part 'MeetingDetail.g.dart';

@JsonSerializable()
class MeetingDetail{
  int meetingId;
  int id;
  String city;
  String summary;
  DateTime date;
  bool read;
  int approve;
  String type;
  String loveType;
  int age;
  int marry;
  int height;
  String job;
  String figure;
  String xingzuo;
  String content;
  String registId;
  String enlistersName;
  int score;
  int pics;
  String reason;

  MeetingDetail(this.meetingId,this.id,this.city,this.age,this.height,this.summary,this.approve,{this.date});

  factory MeetingDetail.fromJson(Map<String, dynamic> json) => _$MeetingDetailFromJson(json);

  Map<String, dynamic> toJson() => _$MeetingDetailToJson(this);
}