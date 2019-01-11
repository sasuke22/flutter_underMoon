import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:banner/banner.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('邀约详情'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),onPressed: _backToList,
        ),
      ),
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

  void _backToList(){
    Navigator.pop(context);
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
                    imageUrl: _bannerUrls[index]
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
                    Padding(padding: EdgeInsets.fromLTRB(10.0, 5.0, 5.0, 5.0),child: Text("日期: ${_meetingDetail.date.toString()}")),
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
    DioUtil().getMeetingDetail(
      (MeetingDetail detail){
        setState(() {
          _meetingDetail = detail;
          for(int i = 0;i < _meetingDetail.pics;i++){
            _bannerUrls.add(DioUtil.APPLICATION_SERVER + 'meeting/' + _meetingDetail.meetingId.toString() + '/' + i.toString() + '.jpg');
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
          textColor: Colors.white
      );
    else
      DioUtil().changeMeetingApprove((int result){
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
    DioUtil().changeMeetingApprove((int result){
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
}