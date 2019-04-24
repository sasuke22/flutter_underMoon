import 'package:flutter/material.dart';
import 'package:flutter_undermoon/CustomView/AvatarWithGender.dart';
import 'package:flutter_undermoon/VIPS/EnlisterInfo.dart';
import 'package:flutter_undermoon/VIPS/User.dart';

class UserItem extends StatelessWidget{
  final User _user;

  UserItem(this._user);

  @override
  Widget build(BuildContext context) {
    List<Widget> _vipInfo = [];
    _vipInfo.add(Text(
        _user.userName,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(fontSize: 16.0)
    ));
    _vipInfo.add(Text(
        _user.userBriefIntro,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(fontSize: 16.0,color: Colors.grey)
    ));
    _vipInfo.add(Text(
        _user.location,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(fontSize: 16.0,color: Colors.grey)
    ));

    var widget = Card(
      elevation: 1.0,
      child: Padding(padding: EdgeInsets.fromLTRB(8,5,8,5),
        child: Row(
            children: <Widget>[
              AvatarWithGender(36,_user.id,_user.gender),
              Expanded(
                  child: Container(height: 80,child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: _vipInfo
                  ),)
              ),
            ]
        ),
      ),
    );
    return GestureDetector(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => EnlisterInfo(_user)));},
      child: widget,
    );
  }
}