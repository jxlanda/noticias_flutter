// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/blocs/blocs.dart';
import 'package:news/repositories/repositories.dart';
import 'package:meta/meta.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final NewsRepository newsRepository;
  int _currentPage = 1;

  NewsBloc({@required this.newsRepository}) : assert(newsRepository != null);

  // El estado inicial del bloc
  @override
  NewsState get initialState => NewsEmpty();

  // Si quieres esperar entre peticion

  // @override
  // Stream<Transition<NewsEvent, NewsState>> transformEvents(
  //   Stream<NewsEvent> events,
  //   TransitionFunction<NewsEvent, NewsState> transitionFn,
  // ) {
  //   return super.transformEvents(
  //     events.debounceTime(const Duration(seconds: 1)),
  //     transitionFn,
  //   );
  // }

  @override
  Stream<NewsState> mapEventToState(NewsEvent event) async* {
    final currentState = state;
    // if (event is FetchTopHeadlines && !_hasReachedMax(currentState)) {
    //   try {
    //     if (currentState is NewsEmpty) {
    //       final news =
    //           await newsRepository.getTopHeadlines(event.country, _currentPage);
    //       yield NewsLoaded(articles: news.articles, hasReachedMax: false);
    //       return;
    //     } else if (currentState is NewsLoaded) {
    //         _currentPage++;
    //         final news = await newsRepository.getTopHeadlines(
    //             event.country, _currentPage);
    //         if (news.totalResults == currentState.articles.length) {
    //           yield currentState.copyWith(hasReachedMax: true);
    //           return;
    //         } else {
    //           yield NewsLoaded(
    //               articles: currentState.articles + news.articles,
    //               hasReachedMax: false);
    //         }
    //     }
    //   } catch (_) {
    //     yield NewsError();
    //   }
    // } 
    if (event is FetchTopHeadlinesByCategory && !_hasReachedMax(currentState)){
      try {
        if (currentState is NewsEmpty) {
          final news =
              await newsRepository.getTopHeadlinesByCategory(event.country, event.category, _currentPage);
          yield NewsLoaded(articles: news.articles, hasReachedMax: false);
          return;
        } else if (currentState is NewsLoaded) {
            _currentPage++;
            final news = await newsRepository.getTopHeadlinesByCategory(
                event.country, event.category, _currentPage);
            if (news.totalResults == currentState.articles.length) {
              yield currentState.copyWith(hasReachedMax: true);
              return;
            } else {
              // TO DO
              // Arreglar y solo hacer una carga a la vez
              print(currentState.articles.length);
              yield NewsLoaded(
                  articles: currentState.articles + news.articles,
                  hasReachedMax: false);
            }
        }
      } catch (_) {
        yield NewsError();
      }
    }
  }

  bool _hasReachedMax(NewsState state) =>
      state is NewsLoaded && state.hasReachedMax;
}
