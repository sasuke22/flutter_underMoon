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
  bool _displayAll = true;
  var _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
    _loadMeetings();
  }

  @override
  Widget build(BuildContext context) {
    var _meetingListView = ListView.builder(
      controller: _scrollController,
      physics: AlwaysScrollableScrollPhysics(),
      itemCount: _meetings.length,
      itemBuilder: (context,index){
        var item = MeetingItem(_meetings[index],onDelete: (id){_deleteItem(index,id);},);
        return item;
      });

    var _body = NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: RefreshIndicator(
        color: Colors.green,
        child: _meetingListView,
        onRefresh: _listViewRefresh,
      ),
    );

    var _menu = PopupMenuButton<String>(
      itemBuilder: (context) => <PopupMenuItem<String>>[
        PopupMenuItem<String>(
          value: '未审核',child: Text('显示未审核'),
        ),
        PopupMenuItem<String>(
          value: '全部',child: Text('显示全部'),
        )
      ],
      onSelected: (String action){
        switch(action){
          case '未审核':
            _displayAll = false;
            List<MeetingDetail> _listFor0 = List<MeetingDetail>();
            _meetings.forEach((item){
              if(item.approve == 0)
                _listFor0.add(item);
            });
            setState(() {
              _meetings.clear();
              _meetings.addAll(_listFor0);
            });
            break;
          case '全部':
            _displayAll = true;
            _listViewRefresh();
            break;
        }
      },
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('邀约列表'),
        actions: <Widget>[
          _menu,
        ],
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
        floatingActionButton: FloatingActionButton(
          onPressed: () => _meetingListView.controller.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn),
          child: Icon(Icons.vertical_align_top ),
        ),
    );
  }

  bool _isLoading = false;

  Future<Null> _loadMeetings(){
    if(_isLoading || !this.mounted)
      return null;
    _isLoading = true;
    return DioUtil.getMeetingsByCount((MeetingsModel _model){
      setState(() {
        List<MeetingDetail> _temp = List<MeetingDetail>();
        if(!_displayAll)
          _model.meetings.forEach((item){
            if(item.approve == 0)
              _temp.add(item);
          });
        else
          _temp.addAll(_model.meetings);
        _meetings.addAll(_temp);
        _isLoading = false;
        _count += _model.meetings.length;
      });
    }, _count);
  }

  Future<Null> _listViewRefresh() async {
    _count = 0;
    _meetings.clear();
    return await _loadMeetings();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if(notification.metrics.pixels >= notification.metrics.maxScrollExtent && !_isLoading)
      _loadMeetings();
    return false;
  }

  void _deleteItem(int index,int id) {
    setState(() {
      _meetings.removeAt(index);
    });
  }
}