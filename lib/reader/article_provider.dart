import 'package:flutter_book/public.dart';

class ArticleProvider {
  static Future<Article> fetchArticle(int articleId) async {
    var response = await Request.get(action: 'article_$articleId');
    var article =Article.fromJson(response);

    return article;
  }
}