import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

// // Primer evento
// class FetchTopHeadlines extends NewsEvent {
//   final String country;
//   final int page;

//   const FetchTopHeadlines({@required this.country, this.page}) 
//     : assert(country != null, page != null);

//   @override
//   List<Object> get props => [country, page];
// }

class FetchTopHeadlinesByCategory extends NewsEvent {
  final String country;
  final String category;
  final int page;

  const FetchTopHeadlinesByCategory({@required this.country, @required this.category, this.page}) 
    : assert(country != null, category != null);

  @override
  List<Object> get props => [country, category, page];
}

