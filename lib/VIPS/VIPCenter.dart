import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_undermoon/VIPS/User.dart';
import 'package:flutter_undermoon/VIPS/UserItem.dart';
import 'package:flutter_undermoon/VIPS/add_session.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';

class VIPCenter extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => VIPCenterState();
}

class VIPCenterState extends State<VIPCenter> with SingleTickerProviderStateMixin {
  int _count = 0;
  List<User> _users = [];
  ScrollController _controller = ScrollController();
  int _selectedTab = 0;//默认选中第一个
  TabController _barController;
  int _womanCount = 0;
  int _manCount = 0;

  @override
  void initState() {
    super.initState();
    _barController = TabController(length: 2, vsync: this);
    _getCount();
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

    var _body;
    if(null == _users || 0 == _users.length){
      _body = SpinKitCircle (
        itemBuilder: (_, int index) {
          return DecoratedBox(
            decoration: BoxDecoration(
              color: index.isEven ? Colors.red : Colors.green,
            ),
          );
        },
      );
    }else{
      _body = NotificationListener<ScrollNotification>(
        onNotification: _onScrollNotification,
        child: RefreshIndicator(
          color: Colors.green,
          child: _articleListView,
          onRefresh: _listViewRefresh,
        ),
      );
    }

    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text('会员列表'),
            actions: <Widget>[
              IconButton(
                onPressed: (){_showSearchDialog();},
                icon: Icon(Icons.search),
              )
            ],
            bottom: TabBar(
              onTap: (index){_updateContentAccordingIndex(index);},
              labelColor: Colors.redAccent,
              unselectedLabelColor: Colors.grey,
              indicator: BoxDecoration(),
              tabs: <Widget>[
                Tab(text: '女生($_womanCount人)'),
                Tab(text: '男生($_manCount人)'),
              ]),
          ),
          body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _barController,
              children: <Widget>[
                _body,
                _body
              ]),
          floatingActionButton: FloatingActionButton(
            onPressed: () => _articleListView.controller.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn),
            child: Icon(Icons.vertical_align_top ),
          ),
        ));
  }

  bool _isLoading = false;

  Future<Null> _loadUsers() async {
    if(_isLoading || !this.mounted)
      return null;
    _isLoading = true;
    DioUtil.getAllUsers(_count,_selectedTab).then((_model){
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

  void _showSearchDialog() {
    showDialog<List<dynamic>>(
            context: context,
            barrierDismissible: false,
            builder: (context){return AddSession(_users);})
        .then((List<dynamic> onValue) {
      if (onValue != null) {

      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _barController?.dispose();
    super.dispose();
  }

  void _updateContentAccordingIndex(int index) {
    _selectedTab = index;
    _users.clear();
    _count = 0;
    _loadUsers();
  }

  void _getCount() {
    DioUtil.getUserCount().then((result){
      print(result.toString());
      setState(() {
        _manCount = result['man'];
        _womanCount = result['woman'];
      });
    });
  }
}