import 'package:flutter/material.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';

class AvatarWithGender extends StatelessWidget{
  final double size;
  final int userId;
  final int gender;

  AvatarWithGender(this.size,this.userId,this.gender);

  @override
  Widget build(BuildContext context) {
    ImageProvider _avatar;
    if(userId == -1){
      if(gender == 1)
        _avatar = AssetImage(
          'images/default_man.png',
        );
      else
        _avatar = AssetImage(
          'images/default_woman.png',
        );
    }else
      _avatar = NetworkImage(DioUtil.PIC_SERVER + '$userId/0.jpg');
    return Container(
        margin: EdgeInsets.only(right: 8),
        child: Stack(
          alignment: const FractionalOffset(1, 1),
          children: <Widget>[
            CircleAvatar(
                backgroundImage: _avatar,
                radius: size,
            ),
            CircleAvatar(
              backgroundColor: Colors.grey[100],
              child: Text(gender == 1 ? '♂' : '♀',style: TextStyle(fontSize: 14-80/size,color: gender == 1 ? Colors.lightBlue : Colors.pink),),
              radius: size/3.6,
            )
          ],
        )
    );
  }

}