import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:banner/banner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_undermoon/CustomView/UnderMoonDialog.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_undermoon/util/DateUtil.dart';

class MeetingDetailScreen extends StatefulWidget{
  final int meetingId;

  MeetingDetailScreen(this.meetingId);

  @override
  State<StatefulWidget> createState() {
    return MeetingDetailScreenState(meetingId);
  }
}

class MeetingDetailScreenState extends State<MeetingDetailScreen>{
  List<String> _bannerUrls;
  MeetingDetail _meetingDetail;
  int _meetingId;
  TextEditingController _reasonController = TextEditingController();

  MeetingDetailScreenState(this._meetingId);

  @override
  void initState() {
    super.initState();
    _loadMeetingDetail();
  }

  @override
  Widget build(BuildContext context) {
    String _top;
    if(null == _meetingDetail || _meetingDetail.top == 0){
      _top = '置顶';
    } else
      _top = '取消置顶';

    return Scaffold(
      appBar: AppBar(
        title: Text('邀约详情'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete), onPressed: (){_deleteMeeting(context,_meetingDetail.meetingId);})
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){_pushMeetingToTop(context);},
        child: Text(_top)),
      body: null == _meetingDetail ?
        SpinKitFoldingCube (
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.red : Colors.green,
              ),
            );
          },
        ) : meetingDetailScreenBody(context),
    );
  }

  Widget meetingDetailScreenBody(BuildContext context){
    var header;
    if (null == _bannerUrls || _bannerUrls.length <= 0)
      header = Icon(Icons.add_a_photo);
    else {
      double screenWidth = MediaQueryData
          .fromWindow(ui.window)
          .size
          .width;
      header = Container(
        height: screenWidth * 500 / 900,
        width: screenWidth,
        child: Card(
          elevation: 5.0,
          shape: Border(),
          margin: EdgeInsets.all(0.0),
          child: BannerView(
              data: _bannerUrls,
              delayTime: 10,
              onBannerClickListener: (index, itemData) {
                //TODO 点击之后显示大图
              },
              buildShowView: (index, data) {
                return CachedNetworkImage(
                    fadeInDuration: Duration(milliseconds: 0),
                    fadeOutDuration: Duration(milliseconds: 0),
                    imageUrl: data,
//                    fit: BoxFit.cover,
                );
              }),
        ),
      );
    }
    return SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              header,
              Table(
                columnWidths: const <int,TableColumnWidth>{
                  0: FlexColumnWidth(1.0),
                  1: FlexColumnWidth(1.0),
                },
                border: TableBorder(
                  horizontalInside: BorderSide(color: Colors.blueGrey),
                  verticalInside: BorderSide(color: Colors.blueGrey),
                  top: BorderSide(color: Colors.blueGrey),
                  bottom: BorderSide(color: Colors.blueGrey),
                ),
                children: <TableRow>[
                  TableRow(children: <Widget>[
                    Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),child: Text("id: ${_meetingDetail.id.toString()}")),
                    Padding(padding: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),child: Text("城市: ${_meetingDetail.city}")),
                  ]),
                  TableRow(children: <Widget>[
                    Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),child: Text("日期: ${DateUtil.getFormattedTime(_meetingDetail.date)}")),
                    Padding(padding: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),child: Text("年龄: ${_meetingDetail.age.toString()}")),
                  ]),
                  TableRow(children: <Widget>[
                    Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),child: Text("身高: ${_meetingDetail.height.toString()}")),
                    Padding(padding: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),child: Text("描述: ${_meetingDetail.content}")),
                  ]),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
                child: TextField(
                  controller: _reasonController,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(5),
                    border: OutlineInputBorder(),
                    labelText: '请输入审核未通过的理由',
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),
                        child: OutlineButton(
                          onPressed: _deny,
                          borderSide: BorderSide(
                            color: Colors.lightBlue,
                          ),
                          child: Text('不通过',style: TextStyle(color: Colors.lightBlue)),
                        ),
                        height: 40,
                      )
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(5.0, 5.0, 10.0, 5.0),
                        child: RaisedButton(
                          onPressed: _approve,
                          color: Colors.lightBlue,
                          textColor: Colors.white,
                          child: Text('通过'),
                        ),
                        height: 40,
                      )
                  ),
                ],
              )
            ]
        ),
    );
  }

  _loadMeetingDetail() {
    DioUtil.getMeetingDetail(
      (MeetingDetail detail){
        setState(() {
          _meetingDetail = detail;
          _bannerUrls = List<String>();
          for(int i = 0;i < _meetingDetail.pics;i++){
            _bannerUrls.add(DioUtil.PIC_SERVER + 'meeting/${_meetingDetail.meetingId}/$i.jpg');
          }
        });
      },
      _meetingId);
  }

  void _deny() {
    if(null == _reasonController.text || _reasonController.text.length <= 0)
      Fluttertoast.showToast(
          msg: '忘记否决原因啦!',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.lightBlue,
          textColor: Colors.white,
      );
    else
      DioUtil.changeMeetingApprove((int result){
        Fluttertoast.showToast(
            msg: 1 == result ? '否决成功' : '否决失败',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.lightBlue,
            textColor: Colors.white
        );
      }, _meetingId, -1, reason: _reasonController.text);
  }

  void _approve() {
    DioUtil.changeMeetingApprove((int result){
      Fluttertoast.showToast(
          msg: 1 == result ? '通过成功' : '通过失败',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.lightBlue,
          textColor: Colors.white
      );
    }, _meetingId, 1);
  }

  @override
  void dispose() {
    _reasonController?.dispose();
    super.dispose();
  }

  void _deleteMeeting(BuildContext context, int meetingId) {
    showDialog(context: context,builder: (_) => CupertinoAlertDialog(
      content: Text('你确定删除这个邀约吗?',textScaleFactor: 1.0),actions: <Widget>[
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){setState(() {
          Navigator.pop(context);
          showDialog(context: context,builder: (_) => UnderMoonDialog('正在删除...'));
          DioUtil.deleteMeeting(meetingId,true).then((result){
            if(result == 1){
              Navigator.pop(context);
              var _result = {'delete': _meetingDetail.meetingId};
              Navigator.pop(context,_result);
              Fluttertoast.showToast(msg: '删除成功');
            }else
              Fluttertoast.showToast(msg: '删除失败,请重试');
          });
        });},
        child: Container(
          padding: EdgeInsets.only(top: 10,bottom: 10),
          alignment: Alignment.center,
          child: Text('确定',style: Theme.of(context).textTheme.display1),
        ),
      ),
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: (){setState(() {
          Navigator.pop(context);
        });},
        child: Container(
          padding: EdgeInsets.only(top: 10,bottom: 10),
          alignment: Alignment.center,
          child: Text('取消',style: Theme.of(context).textTheme.display2),
        ),
      )
    ],
    ));
  }

  void _pushMeetingToTop(BuildContext context) {
    showDialog(context: context,builder: (_) =>
        CupertinoAlertDialog(
          content: Text('你确定执行这个动作吗?',textScaleFactor: 1.0),actions: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){setState(() {
              Navigator.pop(context);
              showDialog(context: context,builder: (_) => UnderMoonDialog('正在执行...'));
              DioUtil.topMeeting(_meetingDetail.meetingId,_meetingDetail.top).then((result){
                Navigator.pop(context);
                if(result == 1){
                  var _result = {'delete': _meetingId};
                  Navigator.pop(context,_result);
                  Fluttertoast.showToast(msg: '执行成功');
                }else
                  Fluttertoast.showToast(msg: '执行失败,请重试');
              });
            });},
            child: Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              alignment: Alignment.center,
              child: Text('确定',style: Theme.of(context).textTheme.display1),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){setState(() {
              Navigator.pop(context);
            });},
            child: Container(
              padding: EdgeInsets.only(top: 10,bottom: 10),
              alignment: Alignment.center,
              child: Text('取消',style: Theme.of(context).textTheme.display2),
            ),
          )
          ],
        )
    );
  }
}