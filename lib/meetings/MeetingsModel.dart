import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
part 'MeetingsModel.g.dart';

@JsonSerializable()
class MeetingsModel{
  List<MeetingDetail> meetings;

  MeetingsModel(this.meetings);

  factory MeetingsModel.fromJson(Map<String, dynamic> json) => _$MeetingsModelFromJson(json);

  toJson() => _$MeetingsModelToJson(this);
}