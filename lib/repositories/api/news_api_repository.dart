import 'package:meta/meta.dart';
import 'package:news/models/models.dart';
import 'package:news/repositories/repositories.dart';

class NewsRepository {
  final NewsApiClient newsApiClient;

  NewsRepository({@required this.newsApiClient})
      : assert(newsApiClient != null);

  // Future<News> getTopHeadlines(String country, int page) async {
  //   final resp = await newsApiClient.getTopHeadlines(country, page);
  //   return resp;
  // }

  Future<News> getTopHeadlinesByCategory(String country, String category, int page) async {
    final resp = await newsApiClient.getTopHeadlinesByCategory(country, category, page);
    return resp;
  }

  Future<News> getSearchNewsByQuery(String query, String language, int page) async {
    final resp = await newsApiClient.getSearchNews(query, language, page);
    return resp;
  }
  
}