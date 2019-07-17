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
    var widget = Card(
          elevation: 3.0,
          child: Padding(padding: EdgeInsets.fromLTRB(8,5,8,5),
            child: Row(
                children: <Widget>[
                  AvatarWithGender(36,_meetingDetail.id,_meetingDetail.gender),
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              DateUtil.getFormattedTime(_meetingDetail.date),
                              style: TextStyle(
                                fontSize: 16.0,
                              )
                            ),
                            Text(
                                _meetingDetail.city,
                                style: TextStyle(
                                  fontSize: 16.0,
                                )
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