import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class SearchNewsEvent extends Equatable {
  const SearchNewsEvent();
}

class FetchNewsByQuery extends SearchNewsEvent {
  final String query;
  final String language;
  final int page;

  const FetchNewsByQuery({@required this.query, @required this.language, this.page}) 
    : assert(query != null, language != null);

  @override
  List<Object> get props => [query, language, page];
}
