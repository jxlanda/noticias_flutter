import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:news/models/news_model.dart';

abstract class NewsState extends Equatable {
  const NewsState();

  @override
  List<Object> get props => [];
}

// Estados que tendra el News Empty, Loading, Loaded, Error
class NewsEmpty extends NewsState {}
class NewsLoaded extends NewsState {
  final List<Article> articles;
  final bool hasReachedMax;
  const NewsLoaded({ @required this.articles, @required this.hasReachedMax}) : assert(articles != null);

  NewsLoaded copyWith({List<Article> articles, bool hasReachedMax}) {
    return NewsLoaded(
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax
    );
  }
  
  @override
  List<Object> get props => [articles, hasReachedMax];
}
class NewsError extends NewsState {}
