import 'package:flutter/material.dart';
import 'package:flutter_undermoon/CustomView/AvatarWithGender.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
import 'package:flutter_undermoon/meetings/MeetingDetailScreen.dart';
import 'package:flutter_undermoon/util/DateUtil.dart';

class MeetingItem extends StatelessWidget{
  final MeetingDetail _meetingDetail;
  final ValueChanged<int> onDelete;

  MeetingItem(this._meetingDetail,{this.onDelete});

  @override
  Widget build(BuildContext context) {
    var _decoration;
    print(_meetingDetail.bigVip);
    print(_meetingDetail.isVip);
    if(_meetingDetail.bigVip)
      _decoration = Image.asset('images/big_vip_meeting_list.png',height: 35,);
    else if(_meetingDetail.isVip)
      _decoration = Image.asset('images/vip_meeting_list.png',height: 35,);
    else
      _decoration = Text('');

    var widget = Card(
          elevation: 3.0,
          child: Stack(
            children: <Widget>[
              Padding(padding: EdgeInsets.fromLTRB(8,5,8,5),
                child: Row(
                    children: <Widget>[
                      AvatarWithGender(36,_meetingDetail.id,_meetingDetail.gender),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Text(
                                        DateUtil.getFormattedTime(_meetingDetail.date),
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        )
                                    ),
                                    Text(
                                      _meetingDetail.gender > 0 ? '男' : '女',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: <Widget>[
                                    Text(
                                        _meetingDetail.city,
                                        style: TextStyle(
                                          fontSize: 16.0,
                                        )
                                    ),
                                    _meetingDetail.top > 0 ? Text('    置顶',style: TextStyle(color: Colors.red)) : Text('')
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                        _meetingDetail.approve == 1 ? '已通过' : _meetingDetail.approve == -1 ? '未通过' : '未审核',
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: _meetingDetail.approve == 1 ? Colors.lightGreenAccent : _meetingDetail.approve == -1 ? Colors.red : Colors.yellow
                                        )
                                    ),
                                    Row(
                                      children: <Widget>[
                                        Icon(Icons.textsms,color: Theme.of(context).backgroundColor,size: 18),
                                        Text('${_meetingDetail.commentCount}',style: TextStyle(color: Theme.of(context).backgroundColor))
                                      ],
                                    )
                                  ],
                                )
                              ]
                          )
                      ),
                    ]
                ),
              ),
              Positioned(child: _decoration,left: 0,top: 0,),
            ],
          ),
    );
    return GestureDetector(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => MeetingDetailScreen(_meetingDetail.meetingId))).then((result){
        if(result != null){
          onDelete(result['delete']);
        }
      });},
      child: widget,
    );
  }

}