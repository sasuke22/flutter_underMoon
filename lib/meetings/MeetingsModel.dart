import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class MeetingsModel{
  List<MeetingDetail> meetings;

  MeetingsModel(this.meetings);

  MeetingsModel.fromJson(Map<String, dynamic> json){
    meetings = List<MeetingDetail>();
    (json['meetings'] as List).forEach((item){
      MeetingDetail meeting = MeetingDetail.fromJson(item);
      meetings.add(meeting);
    });
  }

  Map<String, dynamic> toJson() =>
    {
      'meetings' : meetings,
    };
}