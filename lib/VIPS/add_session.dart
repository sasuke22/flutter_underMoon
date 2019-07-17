import 'package:flutter/material.dart';
import 'package:flutter_undermoon/VIPS/EnlisterInfo.dart';
import 'package:flutter_undermoon/VIPS/User.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddSession extends StatefulWidget {
  AddSession(this._list);
  final List<User> _list;

  @override
  State createState() => _AddSessionState();
}

class _AddSessionState extends State<AddSession> {
  final TextEditingController _idController = TextEditingController();
  User _searchUser;
  String _errorPrompt = '';
  bool _nullText = true;

  void _handleFind() {
    FocusScope.of(context).requestFocus(FocusNode());
    if (_idController.text.isEmpty) {
      setState(() {
        _errorPrompt = 'ID不能为空!';
      });
      return;
    } else if (_idController.text.trim().length > 12) {
      setState(() {
        _errorPrompt = 'ID的长度不能大于12!';
      });
      return;
    }
    for(int i = 0;i < widget._list.length;i++){
      if(widget._list[i].account == _idController.text.toString()){
        Navigator.push(context, MaterialPageRoute(builder: (context) => EnlisterInfo(widget._list[i])));
        return;
      }
    }
    Fluttertoast.showToast(msg: '没有符合条件的人');
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
        title: Text('查找人物'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 23.0),
        children: <Widget>[
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Flexible(
                    child: TextField(
                  controller: _idController,
                  keyboardType: TextInputType.phone,
                  inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  decoration:
                      InputDecoration.collapsed(hintText: '点击此处输入手机号码'),
                  onChanged: (text) {
                    if (text == '') {
                      _nullText = true;
                    } else {
                      _nullText = false;
                    }
                    setState(() {});
                  },
                )),
                _nullText
                    ? Text('')
                    : IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _idController.clear();
                          _nullText = true;
                          _errorPrompt = '';
                          _searchUser = null;
                          setState(() {});
                        },
                      ),
              ],
            ),
            height: 40.0,
          ),
          Container(
            child: null == _searchUser
                ? _errorPrompt == ''
                    ? Text('')
                    : Container(
                        margin: const EdgeInsets.only(top: 10.0),
                        child: Text(
                          _errorPrompt,
                          style: TextStyle(color: Colors.red),
                        ))
                : Row(
                    children: <Widget>[
                      CircleAvatar(
                          backgroundImage: NetworkImage(DioUtil.PIC_SERVER + '${_searchUser.id}/0.jpg')),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              '  ' + _searchUser.userName,
                              textScaleFactor: 1.2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text('  ' + (_searchUser.gender == 0 ? '♀' : '♂') + _searchUser.age.toString(),style: TextStyle(color: _searchUser.gender == 0 ? Colors.pinkAccent : Colors.lightBlue),)
                          ],
                        )
                      )
                    ],
                  ),
            height: 40.0,
          ),
          Container(
              margin: const EdgeInsets.only(top: 19.0, bottom: 23.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  RaisedButton(
                    elevation: 0.0,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    colorBrightness: Brightness.dark,
                    color: Theme.of(context).hintColor,
                    child: Text('取消'),
                  ),
                  RaisedButton(
                    elevation: 0.0,
                    onPressed: _handleFind,
                    colorBrightness: Brightness.dark,
                    color: Colors.lightBlue,
                    child: Text('查找'),
                  ),
                ],
              ))
        ]);
  }
}
