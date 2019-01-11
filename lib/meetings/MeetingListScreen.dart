import 'package:flutter/material.dart';
import 'package:flutter_undermoon/meetings/MeetingDetail.dart';
import 'package:flutter_undermoon/meetings/MeetingItem.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';
import 'package:flutter_undermoon/meetings/MeetingsModel.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class MeetingListScreen extends StatefulWidget{

  MeetingListScreen(
      {Key key}
      ) : super(key : key);

  @override
  State<StatefulWidget> createState() {
    return MeetingListScreenState();
  }
}

class MeetingListScreenState extends State<MeetingListScreen>{
  int _count = 0;
  List<MeetingDetail> _meetings = [];

  @override
  void initState() {
    super.initState();
    _loadMeetings();
  }

  @override
  Widget build(BuildContext context) {
    var _meetingListView = ListView.builder(
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: _meetings.length,
      itemBuilder: (context,index){
        return MeetingItem(index, _meetings[index]);
      });

    var _body = NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: RefreshIndicator(
        color: Colors.green,
        child: _meetingListView,
        onRefresh: _listViewRefresh
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('邀约列表'),
      ),
      body: (null == _meetings || 0 == _meetings.length) ?
        SpinKitFoldingCube (
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: index.isEven ? Colors.red : Colors.green,
              ),
            );
          },
        ) : _body,
    );
  }

  bool _isLoading = false;

  void _loadMeetings(){
    if(_isLoading || !this.mounted)
      return null;
    //TODO 显示加载中
    _isLoading = true;
    DioUtil().getMeetingsByCount((MeetingsModel _model){
      //TODO 加载中提示消失
      setState(() {
        _meetings.addAll(_model.meetings);
        _isLoading = false;
        _count += 20;
      });
    }, _count);
  }

  Future<Null> _listViewRefresh() {
    _count = 0;
    _meetings.clear();
    _loadMeetings();
    return null;
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if(notification.metrics.pixels >= notification.metrics.maxScrollExtent)
      _loadMeetings();
    return false;
  }
}