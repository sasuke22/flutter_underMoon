import 'package:flutter_undermoon/VIPS/User.dart';

class UserListModel {
  List<User> userList;

  UserListModel.fromJson(Map<String, dynamic> json){
    userList = List<User>();
    (json['userList'] as List).forEach((item){
       User user = User.fromJson(item);
       userList.add(user);
    });
  }

  Map<String, dynamic> toJson() =>
  {
    'userList' : userList
  };
}