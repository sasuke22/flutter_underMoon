import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_undermoon/CustomView/PhotoPageView.dart';
import 'package:flutter_undermoon/CustomView/UnderMoonDialog.dart';
import 'package:flutter_undermoon/VIPS/User.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

class EnlisterInfo extends StatefulWidget {
  final User _user;
  EnlisterInfo(this._user);

  @override
  State createState() => _EnlisterInfoState();
}

class _EnlisterInfoState extends State<EnlisterInfo> {
  List<String> _picUrls = List<String>();
  ScrollController _scrollController = ScrollController();
  String _genderString;
  List<Widget> _photoList;
  List<ImageProvider> _imgProviderList;
  String _restoreOrLimit;
  TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    _genderString = widget._user.gender == 1 ? '男' : '女';
    _analyzePics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenWidth = size.width;
    final height = screenWidth/1.72;
    double _statusBarHeight = MediaQuery.of(context).padding.top;
    var _photoGrid;
    _restoreOrLimit = widget._user.lock == 1 ? '恢复' : '禁用';

    if(_picUrls.length > 0){
      _photoGrid = GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(5.0),
        crossAxisCount: _picUrls.length < 3 ? _picUrls.length : 3,
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
        children: _displayPhoto(),
      );
    }else
      _photoGrid = Text('');

    return Scaffold(
      backgroundColor: Colors.white,
      body: null == widget._user ?
        SpinKitFadingCube (
          itemBuilder: (_, int index) {
            return DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
              ),
            );
          },
        )
        : Stack(
          children: <Widget>[
            Container(
              height: double.infinity,
              padding: EdgeInsets.only(bottom: 50),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Stack(
                      alignment: FractionalOffset(0.5, 1),
                      children: <Widget>[
                        Container(
                            height: height,
                            width: screenWidth,
                            decoration: BoxDecoration(
                              image: DecorationImage(image: AssetImage('images/background.jpg'),fit: BoxFit.cover),
                            )),
                        Padding(padding: EdgeInsets.only(bottom: 10),child: Column(
                          children: <Widget>[
                            CircleAvatar(
                              backgroundImage: NetworkImage(DioUtil.PIC_SERVER + '${widget._user.id}/0.jpg'),
                              radius: 36.0,
                            ),
                            Text(
                              widget._user.userName,
                              textScaleFactor: 1.4,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              '${widget._user.location}  id:${widget._user.id}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text('基本资料  $_genderString  ${widget._user.age}岁  ${widget._user.height}  ${widget._user.xingzuo}  ${widget._user.marry}  ${widget._user.job}'),
                    ),
                    Divider(height: 1),
                    Padding(padding: EdgeInsets.only(top: 8,left: 8,bottom: 8),child: Text('自我独白')),
                    Container(
                      padding: EdgeInsets.only(left: 8,right: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                      ),
                      child: Text(null == widget._user.userBriefIntro ? '暂无介绍' : widget._user.userBriefIntro),
                    ),
                    _photoGrid,
                    Padding(
                        padding: EdgeInsets.only(left: 8),
                        child: Row(
                          children: <Widget>[
                            Text('密码:'+widget._user.password),
                            IconButton(icon: Icon(Icons.edit), onPressed: (){_editPassword();})
                          ],
                        ))
                  ],
                ),
              ),
            ),
            Padding(padding: EdgeInsets.only(top: _statusBarHeight,right: 10),child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                BackButton(color: Colors.white),
                GestureDetector(
                  onTap: (){_showDialogDisableUser(context,widget._user.id);},
                  child: Text(_restoreOrLimit,style: TextStyle(color: Colors.white)),
                ),
              ],
            )),
          ]
        ),
    );
  }

  List<Widget> _displayPhoto() {
    _photoList = List<Widget>();
    _imgProviderList = [];
    Image _image;
    for(int i = 0;i < _picUrls.length;i++){
      _image = Image.network(_picUrls[i],height: 80.0,width: 80.0,fit: BoxFit.cover,);
      _imgProviderList.add(_image.image);
      _photoList.add(GestureDetector(
        onTap: (){Navigator.push(context, MaterialPageRoute(builder: (_) => PhotoPageView(_imgProviderList,i)));},
        child: Card(
            elevation: 2.0,
            child: _image),
      ),
      );
    }
    return _photoList;
  }

  void _showDialogDisableUser(BuildContext context,int id) {
    showDialog(context: context,builder: (_) =>
        CupertinoAlertDialog(
          content: Text('你确定$_restoreOrLimit此人吗?',textScaleFactor: 1.0),actions: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){setState(() {
              Navigator.pop(context);
              showDialog(context: context,builder: (_) => UnderMoonDialog('正在$_restoreOrLimit...'));
              DioUtil.disableUser(widget._user.id,widget._user.lock).then((result){
                Navigator.pop(context);
                if(result == 1){
                  var _result = {'delete': widget._user.id};
                  Navigator.pop(context,_result);
                  Fluttertoast.showToast(msg: '$_restoreOrLimit成功');
                }else
                  Fluttertoast.showToast(msg: '$_restoreOrLimit失败,请重试');
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

  void _analyzePics() {
    if(null != widget._user.photoAddress && widget._user.photoAddress != ''){
      widget._user.photoAddress.split('|').forEach((index){
        if(index != '|') {
          _picUrls.add(DioUtil.PIC_SERVER + '${widget._user.id}/$index.jpg');
        }
      });
    }
  }

  void _editPassword() {
    showDialog(context: context,builder: (_) => Material(
      type: MaterialType.transparency,
      child: Center(
        child: CupertinoAlertDialog(
          title: Text('请输入新密码'),
          content: TextField(
            controller: _passwordController,
            decoration: InputDecoration(hintText: '新密码',border: InputBorder.none,contentPadding: EdgeInsets.all(0)),
          ),actions: <Widget>[
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: (){setState(() {
              Navigator.pop(context);
              showDialog(context: context,builder: (_) => UnderMoonDialog('正在修改...'));
              DioUtil.savePassword(widget._user.id,_passwordController.text.toString().trim()).then((result){
                if(result == 1){
                  Navigator.pop(context);
                  Fluttertoast.showToast(msg: '修改成功');
                }else
                  Fluttertoast.showToast(msg: '修改失败,请重试');
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
        ),
      ),
    ));
  }
}
