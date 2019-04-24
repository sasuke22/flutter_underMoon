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
                            Text(
                                _meetingDetail.approve == 0 ? '未审核' : '已审核',
                                style: TextStyle(
                                    fontSize: 16.0,
                                    color: _meetingDetail.approve == 0 ? Colors.red : Colors.lightGreenAccent
                                )
                            )
                          ]
                      )
                  ),
                  Icon(Icons.arrow_forward_ios)
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