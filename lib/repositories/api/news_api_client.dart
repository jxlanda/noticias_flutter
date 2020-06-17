import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:news/environment/environment.dart';
import 'package:news/models/news_model.dart';

class NewsApiClient {
  static String baseUrl = environment['news_api_url'];
  static String apiKey = environment['news_api_key'];
  final http.Client httpClient;

  // Assert asegura que los valores @required no sean nulos
  NewsApiClient({
    @required this.httpClient,
  }) : assert(httpClient != null);
  

  // Future<News> getTopHeadlines(String country, int page) async {
  //   final newsUrl = Uri.https(baseUrl,'/v2/top-headlines', {
  //     'apiKey': apiKey,
  //     'country': country,
  //     'page': page.toString()
  //   });

  //   final newsResponse = await this.httpClient.get(newsUrl);

  //   if (newsResponse.statusCode != 200) {
  //     print(newsResponse.body);
  //     throw Exception('error getting news');
  //   }

  //   //final newsJson = jsonDecode(newsResponse.body);
  //   //return News.fromJson(newsJson);

  //   final newsJson = newsFromJson(newsResponse.body);
  //   return newsJson;
  // }

  Future<News> getTopHeadlinesByCategory (String country, String category, int page) async {
    final newsUrl = Uri.https(baseUrl,'/v2/top-headlines', {
      'apiKey': apiKey,
      'country': country,
      'category': category,
      'page': page.toString()
    });

    final newsResponse = await this.httpClient.get(newsUrl);

    if (newsResponse.statusCode != 200) {
      print(newsResponse.body);
      throw Exception('error getting news');
    }

    final newsJson = newsFromJson(newsResponse.body);
    return newsJson;
  }

  Future<News> getSearchNews (String search, String language, int page) async {
    final newsUrl = Uri.https(baseUrl,'/v2/everything', {
      'apiKey': apiKey,
      'q': search,
      'language' : language,
      'page': page.toString()
    });
    final newsResponse = await this.httpClient.get(newsUrl);

    if (newsResponse.statusCode != 200) {
      print(newsResponse.body);
      throw Exception('error getting news');
    }

    final newsJson = newsFromJson(newsResponse.body);
    return newsJson;
  }
}

