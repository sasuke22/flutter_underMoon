import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';

class AvatarWithGender extends StatelessWidget{
  final double size;
  final int userId;//-1证明只显示男女默认头像
  final int gender;
  final bool isVip;
  final bool bigVip;

  AvatarWithGender(this.size,this.userId,this.gender,{this.isVip = false,this.bigVip = false});

  @override
  Widget build(BuildContext context) {
    Widget _avatar;
    if(userId == -1){
      if(gender == 1)
        _avatar = Image.asset(
          'images/default_man.png',
        );
      else
        _avatar = Image.asset(
          'images/default_woman.png',
        );
    }else
      _avatar = CachedNetworkImage(imageUrl:DioUtil.PIC_SERVER + '$userId/0.jpg');

    var _children = <Widget>[
      ClipOval(
          child: Container(
            height: size * 2,
            width: size * 2,
            child: _avatar,
          ),
      ),
    ];
    if(bigVip)
      _children.add(Positioned(
          child: Image.asset('images/big_vip_comment.png',height: 11),
          left: 0,bottom: 0));
    else if(isVip)
      _children.add(Positioned(
          child: Image.asset('images/vip_comment.png',height: 11),
          left: 0,bottom: 0));

    return Container(
        margin: EdgeInsets.only(right: 8),
        child: Stack(
          children: _children,
        )
    );
  }
}