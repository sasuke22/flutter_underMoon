import 'package:dio/dio.dart';
import 'package:flutter_undermoon/VIPS/UserListModel.dart';
import 'package:flutter_undermoon/articles/Article.dart';
import 'package:flutter_undermoon/articles/ArticlesModel.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
import 'package:flutter_undermoon/meetings/MeetingsModel.dart';
import 'dart:convert';

class DioUtil {
  static const APPLICATION_SERVER = 'http://45.204.8.236:8080/qiqiim-server/';
  static const PIC_SERVER = 'http://45.204.8.236:8089/';

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
    FormData formData = FormData.from({
      'meetingId': meetingId,
      'approve': approve,
      'reason': reason
    });
    Dio().post(APPLICATION_SERVER + 'changemeetingapprove',data: formData).then((response){
      callback(response.data);
    });
  }

  static Future<ArticlesModel> getArticlesByCount(int oldCount) async {
    var response = await Dio().get(APPLICATION_SERVER + 'morearticles',data: {'count': oldCount});
    return ArticlesModel.fromJson(response.data);
  }

  static Future<int> changeArticleApprove(Article article) async{
    FormData fromData = FormData.from({
      'article': JsonEncoder().convert(article),
    });
    var response = await Dio().post(APPLICATION_SERVER + 'changearticleapprove',data: fromData);
    return response.data;
  }

  static Future<int> deleteMeeting(int meetingId,bool isMeeting) async {
    FormData formData = FormData.from({
      'meetingid': meetingId,
      'ismeeting': isMeeting
    });
    try{
      var response = await Dio().post(APPLICATION_SERVER + 'deletemeeting',data: formData);
      return response.data;
    } on DioError{
      return -1;
    }
  }

  static Future<UserListModel> getAllUsers(int count,int gender) async {
    var response = await Dio().get(APPLICATION_SERVER + 'getalluser',data: {'count': count,'gender': gender});
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
    int toTop = top == 1 ? 0 : 1;
    FormData formData = FormData.from({
      'meetingid': meetingId,
      'top': toTop
    });
    try{
      var response = await Dio().post(APPLICATION_SERVER + 'topmeeting',data: formData);
      return response.data;
    } on DioError{
      return -1;
    }
  }

  static Future<int> changeArticlePerfect(int id) async {
    FormData fromData = FormData.from({
      'id': id,
    });
    var response = await Dio().post(APPLICATION_SERVER + 'changearticleperfect',data: fromData);
    return response.data;
  }

  static Future<Map<String,dynamic>> getUserCount() async {
    var response = await Dio().get(APPLICATION_SERVER + 'getusercount');
    return response.data;
  }

  static Future<int> savePassword(int id, String pwd) async {
    FormData formData = FormData.from({
      'userId' : id,
      'password' : pwd,
    });
    var response = await Dio().post(APPLICATION_SERVER + 'changepassword',data: formData,);
    return response.data;
  }
}