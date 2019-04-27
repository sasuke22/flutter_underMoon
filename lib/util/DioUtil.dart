import 'package:dio/dio.dart';
import 'package:flutter_undermoon/VIPS/UserListModel.dart';
import 'package:flutter_undermoon/articles/Article.dart';
import 'package:flutter_undermoon/articles/ArticlesModel.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
import 'package:flutter_undermoon/meetings/MeetingsModel.dart';

class DioUtil {
  static const APPLICATION_SERVER = 'http://undermoonserver.ngrok.xiaomiqiu.cn/qiqiim-server/';
  static const PIC_SERVER = 'http://undermoonpic.ngrok.xiaomiqiu.cn/';

  static void getMeetingDetail(Function callback,int meetingId) async{
    Dio().get(APPLICATION_SERVER + 'invitationdetail',data: {'meetingid': meetingId}).then((response){
      callback(MeetingDetail.fromJson(response.data));
    });
  }

  static Future<Null> getMeetingsByCount(Function callback,int oldCount) async{
    Dio().get(APPLICATION_SERVER + 'morecontributes',data: {'count': oldCount}).then((response){
      callback(MeetingsModel.fromJson(response.data));
    });
  }

  static void changeMeetingApprove(Function callback, int meetingId, int approve, {String reason}) async{
    Dio().get(APPLICATION_SERVER + 'changemeetingapprove',data: {'meetingId': meetingId, 'approve': approve, 'reason': reason}).then((response){
      callback(response.data);
    });
  }

  static Future<ArticlesModel> getArticlesByCount(int oldCount) async {
    var response = await Dio().get(APPLICATION_SERVER + 'morearticles',data: {'count': oldCount});
    return ArticlesModel.fromJson(response.data);
  }

  static Future<int> changeArticleApprove(Article article) async{
    FormData fromData = FormData.from({
      'article': article.toJson(),
    });
    var response = await Dio().post(APPLICATION_SERVER + 'changearticleapprove',data: fromData);
    return response.data;
  }

  static Future<int> deleteMeeting(int meetingId,bool isMeeting) async {
    FormData formData = FormData.from({
      'meetingid': meetingId,
      'ismeeting': isMeeting
    });
    var response = await Dio().post(APPLICATION_SERVER + 'deletemeeting',data: formData);
    if(response.statusCode == 200)
      return response.data;
    else
      return -1;
  }

  static Future<UserListModel> getAllUsers(int count) async {
    var response = await Dio().get(APPLICATION_SERVER + 'getalluser',data: {'count': count});
    return UserListModel.fromJson(response.data);
  }

  static Future<int> disableUser(int id,int lock) async {
    int toLock = lock == 1 ? 0 : 1;
    FormData formData = FormData.from({
      'id': id,
      'lock': toLock
    });
    try{
      var response = await Dio().post(APPLICATION_SERVER + 'disableuser',data: formData);
      return response.data;
    } on DioError{
      return -1;
    }
  }

  static Future<int> topMeeting(int meetingId,int top) async {
    FormData formData = FormData.from({
      'meetingid': meetingId,
      'top': top
    });
    try{
      var response = await Dio().post(APPLICATION_SERVER + 'topmeeting',data: formData);
      return response.data;
    } on DioError{
      return -1;
    }
  }
}