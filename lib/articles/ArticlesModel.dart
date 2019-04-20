import 'package:flutter_undermoon/articles/Article.dart';

class ArticlesModel {
  List<Article> articles;

  ArticlesModel(this.articles);

  ArticlesModel.fromJson(Map<String, dynamic> json){
    articles = List<Article>();
    (json['articles'] as List).forEach((item){
      Article article = Article.fromJson(item);
      articles.add(article);
    });
  }

  Map<String, dynamic> toJson() =>
      {
        'articles' : articles,
      };
}