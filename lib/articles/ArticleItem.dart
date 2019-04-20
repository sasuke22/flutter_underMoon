import 'package:flutter/material.dart';
import 'package:flutter_undermoon/articles/Article.dart';
import 'package:flutter_undermoon/articles/ArticleDetailScreen.dart';
import 'package:flutter_undermoon/util/DateUtil.dart';
import 'package:flutter_undermoon/util/DioUtil.dart';

class ArticleItem extends StatelessWidget{
  final Article _articleDetail;
  final ValueChanged<int> onDelete;

  ArticleItem(this._articleDetail,{this.onDelete});

  @override
  Widget build(BuildContext context) {
    List<Widget> _articleSummary = [];
    _articleSummary.add(Text(
        _articleDetail.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(fontSize: 16.0)
    ));
    _articleSummary.add(Padding(padding: EdgeInsets.only(right: 8),child: Text(
        _articleDetail.approve == 0 ? '未审核' : '已审核',
        style: TextStyle(
            fontSize: 16.0,
            color: _articleDetail.approve == 0 ? Colors.red : Colors.lightGreenAccent
        )
    )));
    _articleSummary.add(Text(
        DateUtil.getFormattedTime(_articleDetail.date),
        style: TextStyle(color: Colors.grey)
    ));

    var widget = Card(
          elevation: 1.0,
          child: Padding(padding: EdgeInsets.fromLTRB(8,5,8,5),
            child: Row(
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Image.network(DioUtil.PIC_SERVER + 'article/${_articleDetail.id}/0.jpg',width: 80,height: 80,fit: BoxFit.cover),
                  ),
                  Expanded(
                      child: Container(height: 80,child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: _articleSummary
                      ),)
                  ),
                ]
            ),
        ),
    );
    return GestureDetector(
      onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context) => ArticleDetailScreen(_articleDetail))).then((result){
        if(result != null){
          onDelete(result['delete']);
        }
      });},
      child: widget,
    );
  }

}