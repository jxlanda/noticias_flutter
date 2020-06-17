import 'package:equatable/equatable.dart';
import 'package:news/models/models.dart';
import 'package:meta/meta.dart';

abstract class SearchNewsState extends Equatable {
  const SearchNewsState();

  @override
  List<Object> get props => [];
}

class SearchNewsInitial extends SearchNewsState {}
class SearchNewsLoading extends SearchNewsState {}
class SearchNewsSuccess extends SearchNewsState {
  final List<Article> articles;
  final bool hasReachedMax;
  final bool noResults;
  const SearchNewsSuccess({ @required this.articles, @required this.hasReachedMax, @required this.noResults}) : assert(articles != null);

  SearchNewsSuccess copyWith({List<Article> articles, bool hasReachedMax, bool noResults}) {
    return SearchNewsSuccess(
      articles: articles ?? this.articles,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      noResults: noResults ?? this.noResults
    );
  }
  
  @override
  List<Object> get props => [articles, hasReachedMax, noResults];
  
}
class SearchNewsError extends SearchNewsState {}
