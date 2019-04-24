import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_undermoon/VIPS/User.dart';
import 'package:flutter_undermoon/VIPS/UserItem.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';

class VIPCenter extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => VIPCenterState();
}

class VIPCenterState extends State<VIPCenter>{
  int _count = 0;
  List<User> _users = [];
  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  @override
  Widget build(BuildContext context) {
    var _articleListView = ListView.builder(
        controller: _controller,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _users.length,
        itemBuilder: (context,index){
          var item = UserItem(_users[index]);
          return item;
        });

    var _body = NotificationListener<ScrollNotification>(
      onNotification: _onScrollNotification,
      child: RefreshIndicator(
        color: Colors.green,
        child: _articleListView,
        onRefresh: _listViewRefresh,
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text('会员列表'),
      ),
      body: (null == _users || 0 == _users.length) ?
      SpinKitCircle (
        itemBuilder: (_, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.red : Colors.green,
            ),
          );
        },
      ) : _body,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _articleListView.controller.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn),
        child: Icon(Icons.vertical_align_top ),
      ),
    );
  }

  bool _isLoading = false;

  Future<Null> _loadUsers() async {
    if(_isLoading || !this.mounted)
      return null;
    _isLoading = true;
    DioUtil.getAllUsers(_count).then((_model){
      setState(() {
        List<User> _temp = List<User>();
        _temp.addAll(_model.userList);
        _users.addAll(_temp);
        _isLoading = false;
        _count += _model.userList.length;
      });
    });
  }

  Future<Null> _listViewRefresh() {
    _count = 0;
    _users.clear();
    return _loadUsers();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if(notification.metrics.pixels >= notification.metrics.maxScrollExtent && !_isLoading)
      _loadUsers();
    return false;
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}