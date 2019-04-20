import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_undermoon/articles/Article.dart';
import 'package:flutter_undermoon/articles/ArticleItem.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';

class ArticleListScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => ArticleListScreenState();
}

class ArticleListScreenState extends State<ArticleListScreen>{
  int _count = 0;
  List<Article> _articles = [];
  bool _displayAll = true;

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  @override
  Widget build(BuildContext context) {
    var _articleListView = ListView.builder(
        controller: _listViewController(),
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _articles.length,
        itemBuilder: (context,index){
          var item = ArticleItem(_articles[index]);
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
            List<Article> _listFor0 = List<Article>();
            _articles.forEach((item){
              if(item.approve == 0)
                _listFor0.add(item);
            });
            setState(() {
              _articles.clear();
              _articles.addAll(_listFor0);
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
      body: (null == _articles || 0 == _articles.length) ?
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
        onPressed: () => _articleListView.controller.animateTo(0.0, duration: Duration(milliseconds: 200), curve: Curves.fastOutSlowIn),
        child: Icon(Icons.vertical_align_top ),
      ),
    );
  }

  bool _isLoading = false;

  Future<Null> _loadArticles() async {
    if(_isLoading || !this.mounted)
      return null;
    _isLoading = true;
    DioUtil.getArticlesByCount(_count).then((_model){
      setState(() {
        List<Article> _temp = List<Article>();
        if(!_displayAll)
          _model.articles.forEach((item){
            if(item.approve == 0)
              _temp.add(item);
          });
        else
          _temp.addAll(_model.articles);
        _articles.addAll(_temp);
        _isLoading = false;
        _count += _model.articles.length;
      });
    });
  }

  Future<Null> _listViewRefresh() {
    _count = 0;
    _articles.clear();
    return _loadArticles();
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if(notification.metrics.pixels >= notification.metrics.maxScrollExtent && !_isLoading)
      _loadArticles();
    return false;
  }

  ScrollController _listViewController() {return ScrollController();}
}