import 'package:flutter/material.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
import 'package:flutter_undermoon/meetings/MeetingDetailScreen.dart';
import 'package:flutter_undermoon/util/DateUtil.dart';

class MeetingItem extends StatelessWidget{
  final MeetingDetail _meetingDetail;

  MeetingItem(this._meetingDetail);

  @override
  Widget build(BuildContext context) {
    var widget = new Padding(
        padding: new EdgeInsets.fromLTRB(8,0,8,0),
        child: Card(
          elevation: 3.0,
          child: new Padding(padding: new EdgeInsets.fromLTRB(8,5,8,5),
            child: Row(
                children: <Widget>[
                  Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              DateUtil.getFormatedTime(_meetingDetail.date),
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
            ),
          ),
        ),
    );
    return GestureDetector(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => MeetingDetailScreen(_meetingDetail.meetingId)));},
      child: widget,
    );
  }

}