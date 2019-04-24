import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_undermoon/CustomView/AvatarWithGender.dart';
import 'package:flutter_undermoon/CustomView/PhotoPageView.dart';
import 'package:flutter_undermoon/CustomView/UnderMoonDialog.dart';
import 'package:flutter_undermoon/articles/Article.dart';
import 'package:flutter_undermoon/util/DateUtil.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ArticleDetailScreen extends StatefulWidget{
  final Article article;

  ArticleDetailScreen(this.article);

  @override
  State<StatefulWidget> createState() => ArticleDetailScreenState();
}

class ArticleDetailScreenState extends State<ArticleDetailScreen>{
  List<String> _picUrls = [];
  List<Widget> _photoList;
  List<Widget> _body;
  List<ImageProvider> _imgProviderList;
  TextEditingController _reasonController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    _titleController.text = widget.article.title;
    _contentController.text = widget.article.content;
    _body = [];
    _initUrls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        title: Text('反馈详情'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.delete), onPressed: (){_deleteMeeting(context,widget.article.id);})
        ],
      ),
      backgroundColor: Colors.grey[200],
      body: meetingDetailScreenBody(context),
      bottomSheet: Row(
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
      ),
    );
  }

  Widget meetingDetailScreenBody(BuildContext context) {
    Widget _header;
    Widget _pic;
    _body = [];

    _header = Container(
      color: Colors.white,
      padding: EdgeInsets.only(left: 8,top: 8),
      child: Row(
        children: <Widget>[
          AvatarWithGender(20.0,widget.article.id, widget.article.gender),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('${widget.article.id}'),
              Text(DateUtil.getFormattedTime(widget.article.date),)
            ],
          )
        ],
      ),
    );

    if (null == _picUrls || _picUrls.length <= 0)
      _pic = Center(child: Text('这个家伙很懒,没有留下照片'),);
    else {
      _pic = Container(color: Colors.white,child: GridView.count(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: EdgeInsets.all(5.0),
        crossAxisCount: _picUrls.length < 3 ? _picUrls.length : 3,
        crossAxisSpacing: 0.5,
        mainAxisSpacing: 0.5,
        children: _displayPhoto(),
      ));
    }

    Widget _title = Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: TextField(
          controller: _titleController,
          maxLines: 2,
          decoration: InputDecoration(border: InputBorder.none,contentPadding: EdgeInsets.all(0)),
          style: TextStyle(fontWeight: FontWeight.w700)));

    Widget _content = Container(
        width: double.infinity,
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: TextField(
            controller: _contentController,
            maxLines: 10,
            decoration: InputDecoration(border: InputBorder.none,contentPadding: EdgeInsets.all(0))));

    _body..add(_header)
      ..add(_pic)
      ..add(Text('标题'))
      ..add(_title)
      ..add(Text('内容'))
      ..add(_content)
      ..add(Container(
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 5.0),
        child: TextField(
          controller: _reasonController,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(5),
            border: OutlineInputBorder(),
            labelText: '请输入审核未通过的理由',
          ),
        ),
      ),);


    return GestureDetector(
        onTap: (){FocusScope.of(context).requestFocus(FocusNode());},
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.only(bottom: 40),
          child: NotificationListener<ScrollNotification>(
            onNotification: _onScrollNotification,
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _body
              ),
            ),
          ),
        ),
    );
  }

  bool _onScrollNotification(ScrollNotification notification) {
    return false;
  }

  void _initUrls() {
    for(int i = 0;i < widget.article.pics;i++){
      _picUrls.add(DioUtil.PIC_SERVER + '/article/${widget.article.id}/$i.jpg');
    }
  }

  List<Widget> _displayPhoto() {
    _photoList = List<Widget>();
    _imgProviderList = [];
    Image _image;
    for(int i = 0;i < _picUrls.length;i++){
      _image = Image.network(_picUrls[i],height: 80.0,width: 80.0,fit: BoxFit.cover);
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
    else{
      Article _temp = Article();
      _temp.id = widget.article.id;
      _temp.approve = -1;
      _temp.reason = _reasonController.text.trim();
      DioUtil.changeArticleApprove(_temp).then((_result){
        Fluttertoast.showToast(
            msg: 1 == _result ? '否决成功' : '否决失败',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.CENTER,
            timeInSecForIos: 1,
            backgroundColor: Colors.lightBlue,
            textColor: Colors.white
        );
      });
    }
  }

  void _approve() {
    Article _temp = Article();
    _temp.id = widget.article.id;
    _temp.title = _titleController.text.trim();
    _temp.content = _contentController.text.trim();
    _temp.approve = 1;
    DioUtil.changeArticleApprove(_temp).then((_result){
      Fluttertoast.showToast(
          msg: 1 == _result ? '否决成功' : '否决失败',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIos: 1,
          backgroundColor: Colors.lightBlue,
          textColor: Colors.white
      );
    });
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
          DioUtil.deleteMeeting(meetingId,false).then((result){
            if(result == 1){
              Navigator.pop(context);
              var _result = {'delete': widget.article.id};
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
}