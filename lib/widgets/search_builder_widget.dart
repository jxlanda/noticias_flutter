import 'dart:async';
import 'package:flutter/material.dart';
import 'package:news/blocs/blocs.dart';
import 'package:news/widgets/widgets.dart';
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';

class SearchNews extends StatefulWidget {
  final String query;
  final bool isSearching;
  SearchNews({Key key, @required this.query, @required this.isSearching})
      : super(key: key);

  @override
  _SearchNewsState createState() => _SearchNewsState();
}

class _SearchNewsState extends State<SearchNews> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 100.0;
  SearchNewsBloc _searchNewsBloc;
  Timer _debounce;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _searchNewsBloc = BlocProvider.of<SearchNewsBloc>(context);
    super.initState();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
      if (maxScroll - currentScroll <= _scrollThreshold) {
        if (_debounce?.isActive ?? false) _debounce.cancel();
          _debounce = Timer(const Duration(milliseconds: 500), () {
            _searchNewsBloc.add(FetchNewsByQuery(query: widget.query, language: 'es'));
          }); 
      }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isSearching) {
      BlocProvider.of<SearchNewsBloc>(context)
          .add(FetchNewsByQuery(query: widget.query, language: 'es'));
      setState(() {});
    }
    return BlocBuilder<SearchNewsBloc, SearchNewsState>(
        builder: (BuildContext context, SearchNewsState state) {
      if (state is SearchNewsInitial || widget.query.isEmpty)
        return Center(child: Text("No hay busquedas"));
      else if (state is SearchNewsLoading) 
        return Center(child: Container(child: CircularProgressIndicator()));
      else if (state is SearchNewsSuccess) {
        if(state.noResults == true) 
        return Center(child: Text('¡No hay resultados!'));
        else return
        ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.grey[200],
                  height: 12.0,
                  thickness: 0.0,
            ),
            controller: _scrollController,
            itemCount: state.hasReachedMax
                ? (state.articles.length)
                : (state.articles.length + 1),
            itemBuilder: (BuildContext context, int index) {
                return index >= state.articles.length?
                  BottomLoader()
                  :
                  SingleArticle(article: state.articles[index]);
            });
      } else if (state is SearchNewsError) {
        return Center(child: Text('¡Ocurrio un error!'));
      }
      return Container(width: 0.0, height: 0.0);
    });
  }
}
