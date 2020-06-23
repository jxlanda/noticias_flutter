// To parse this JSON data, do
//
//     final news = newsFromJson(jsonString);

import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
// Escribir el nombre del modelo a generar
part 'news_model.g.dart';

News newsFromJson(String str) => News.fromJson(json.decode(str));

String newsToJson(News data) => json.encode(data.toJson());

// Noticias
class News extends Equatable {
  final String status;
  final int totalResults;
  final List<Article> articles;

  const News({
    this.status,
    this.totalResults,
    this.articles,
  });

  factory News.fromJson(Map<String, dynamic> json) => News(
        status: json["status"],
        totalResults: json["totalResults"],
        articles: List<Article>.from(
            json["articles"].map((x) => Article.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "totalResults": totalResults,
        "articles": List<dynamic>.from(articles.map((x) => x.toJson())),
      };

  @override
  List<Object> get props => [status, totalResults, articles];
}

// Noticia
// Crear adapter 
// Escribir @HiveType con su typeId: numeroConsecutivo
// Extender de HiveObject para tener .Save(), .Delete()
@HiveType(typeId: 0)
class Article extends HiveObject {
  // Colocar @HiveField a cada campo
  @HiveField(0)
  Source source;
  // En este caso el campo Source depende de otro modelo
  // Se tiene que crear un adapater tambien para ese modelo
  @HiveField(1)
  String author;
  @HiveField(2)
  String title;
  @HiveField(3)
  String description;
  @HiveField(4)
  String url;
  @HiveField(5)
  String urlToImage;
  @HiveField(6)
  DateTime publishedAt;

  String content;
    Article({
    this.source,
    this.author,
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
  });


  factory Article.fromJson(Map<String, dynamic> json) => Article(
        source: Source.fromJson(json["source"]),
        author: json["author"] == null ? null : json["author"],
        title: json["title"],
        description: json["description"],
        url: json["url"],
        urlToImage: json["urlToImage"],
        publishedAt: DateTime.parse(json["publishedAt"]),
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "source": source.toJson(),
        "author": author == null ? null : author,
        "title": title,
        "description": description,
        "url": url,
        "urlToImage": urlToImage,
        "publishedAt": publishedAt.toIso8601String(),
        "content": content,
      };
}

// Fuente
@HiveType(typeId: 1)
class Source extends HiveObject {
  Source({
    this.id,
    this.name,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String name;

  factory Source.fromJson(Map<String, dynamic> json) => Source(
        id: json["id"] == null ? null : json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name,
      };
}
