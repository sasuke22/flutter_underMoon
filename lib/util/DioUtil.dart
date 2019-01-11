import 'package:dio/dio.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
import 'package:flutter_undermoon/meetings/MeetingsModel.dart';

class DioUtil {
  static const APPLICATION_SERVER = 'http://192.168.107.45:8080/qiqiim-server/';

  void getMeetingDetail(Function callback,int meetingId) async{
    Dio().get(APPLICATION_SERVER + 'invitationdetail',data: {'meetingid': meetingId}).then((response){
      callback(MeetingDetail.fromJson(response.data));
    });
  }

  void getMeetingsByCount(Function callback,int oldCount) async{
    Dio().get(APPLICATION_SERVER + 'morecontributes',data: {'count': oldCount}).then((response){
      callback(MeetingsModel.fromJson(response.data));
    });
  }

  void changeMeetingApprove(Function callback, int meetingId, int approve, {String reason}) async{
    Dio().get(APPLICATION_SERVER + 'changemeetingapprove',data: {'meetingId': meetingId, 'approve': approve, 'reason': reason}).then((response){
      callback(response.data);
    });
  }
}