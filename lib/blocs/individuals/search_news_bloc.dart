import 'package:news/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/repositories/repositories.dart';
// Para @required
import 'package:meta/meta.dart';

class SearchNewsBloc extends Bloc<SearchNewsEvent, SearchNewsState> {
  final NewsRepository newsRepository;
  int _currentPage = 1;
  int _maximumResults = 80;
  String _query = '';

  SearchNewsBloc({@required this.newsRepository})
      : assert(newsRepository != null);

  @override
  SearchNewsState get initialState => SearchNewsInitial();

  @override
  Stream<SearchNewsState> mapEventToState(SearchNewsEvent event) async* {
    // Comprobamos si se hizo una peticion con anterioriedad
    // En caso de que NO nos movemos al estado Loading
    if (state is !SearchNewsSuccess) {
      yield SearchNewsLoading();
    } 
    // Asignamos el estado actual a currentState
    final SearchNewsState currentState = state;
    // Comprobamos si se hizo una peticion y no ha llegado al limite
    // El limite es _maximumResults permitidos por el API gratuita
    if (event is FetchNewsByQuery && !_hasReachedMax(currentState)) {
      try {
        // Comprobamos si el estado es Loading
        // Si es la primera vez, siempre sera Loading
        if (currentState is SearchNewsLoading) {
          // Almacenamos la busqueda en una variable privada
          _query = event.query;
          // Hacemos la peticion
          final news = await newsRepository.getSearchNewsByQuery(event.query, event.language, _currentPage);
          // Comprobamos si la respuesta regreso datos
          // Si NO regreso datos cambiamos la variable noResults a TRUE
          // En caso contrario la dejamos en FALSE
          if(news.articles.length == 0)
            yield SearchNewsSuccess(articles: news.articles, hasReachedMax: false, noResults: true);
          else
            yield SearchNewsSuccess(articles: news.articles, hasReachedMax: false, noResults: false);
          return;
        }
        // Comprobamos si hizo una busqueda diferente
        else if (currentState is SearchNewsSuccess && (event.query != _query)) {
          // Almacenamos la busqueda en una variable privada
          _query = event.query;
          // Nos movemos al estado de Loading
          yield SearchNewsLoading();
          // Hacemos la peticion
          final news = await newsRepository.getSearchNewsByQuery(event.query, event.language, _currentPage);
          // Comprobamos si la respuesta regreso datos
          // Si NO regreso datos cambiamos la variable noResults a TRUE
          // En caso contrario la dejamos en FALSE
          if(news.articles.length == 0)
            yield SearchNewsSuccess(articles: news.articles, hasReachedMax: false, noResults: true);
          else
            yield SearchNewsSuccess(articles: news.articles, hasReachedMax: false, noResults: false);
          return;
        }
        // Comprobamos si hizo otra peticion de la misma busqueda
        else if (currentState is SearchNewsSuccess) {
          // Sumamos el numero de paginacion
          _currentPage++;
          // Hacemos la peticion con la nueva pagina
          final news = await newsRepository.getSearchNewsByQuery(event.query, event.language, _currentPage);
          // Comprobamos si llego al maximo de resultados permitidos por el API
          // En caso de que SI cambiamos el estado de la variable hasReachedMax a TRUE
          // Si NO llego al maxmo hacmos otra peticion
          if (currentState.articles.length == _maximumResults)
            yield currentState.copyWith(hasReachedMax: true);
          else 
            yield SearchNewsSuccess(articles: currentState.articles + news.articles, hasReachedMax: false, noResults: false);
          return;
        }
      } catch (_) {
        yield SearchNewsError();
      }
    } 
    // Comprobamos si se hizo una peticion, si llego al limite y si se hizo una busqueda diferente
    else if (event is FetchNewsByQuery && _hasReachedMax(currentState) && (_query != event.query)){
      // Reseteamos las variables
      _currentPage = 1;
      _query = event.query;
      // Nos movemos al estado de Loading
      yield SearchNewsLoading();
      // Hacemos la peticion
      final news = await newsRepository.getSearchNewsByQuery(event.query, event.language, _currentPage);
      // Comprobamos si la respuesta regreso datos
      // Si NO regreso datos cambiamos la variable noResults a TRUE
      // En caso contrario la dejamos en FALSE
      if(news.articles.length == 0)
        yield SearchNewsSuccess(articles: news.articles, hasReachedMax: false, noResults: true);
      else
        yield SearchNewsSuccess(articles: news.articles, hasReachedMax: false, noResults: false);
      return;
    }
  }

  bool _hasReachedMax(SearchNewsState state) =>
      state is SearchNewsSuccess && state.hasReachedMax;

}
