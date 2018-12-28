import 'package:flutter/material.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';

class MeetingItem extends StatelessWidget{
  MeetingDetail _meetingDetail;

  @override
  Widget build(BuildContext context) {
    var widget = Row(
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  _meetingDetail.date.toString(),
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
        Image.asset(
            'images/ic_common_arrow.png'
        ),
      ]
    );
    return widget;
  }
}