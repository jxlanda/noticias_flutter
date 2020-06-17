import 'package:flutter/material.dart';
import 'package:news/blocs/blocs.dart';
import 'package:news/widgets/widgets.dart';
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsBuilder extends StatefulWidget {
  final String category;
  const NewsBuilder({Key key, @required this.category}) : super(key: key);
  @override
  _NewsBuilderState createState() => _NewsBuilderState();
}

class _NewsBuilderState extends State<NewsBuilder>
    with AutomaticKeepAliveClientMixin<NewsBuilder> {
  final _scrollController = ScrollController();
  // Cargara de acuerdo a los pixeles antes de llegar la final
  final _scrollThreshold = 50.0;
  NewsBloc _newsBloc;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    _newsBloc = BlocProvider.of<NewsBloc>(context);
    _newsBloc.add(
        FetchTopHeadlinesByCategory(category: widget.category, country: 'mx'));
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      _newsBloc.add(FetchTopHeadlinesByCategory(
          category: widget.category, country: 'mx'));
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocBuilder<NewsBloc, NewsState>(
        builder: (BuildContext context, NewsState state) {
      if (state is NewsEmpty) {
        return Center(
          child: CircularProgressIndicator(),
        );
      } else if (state is NewsLoaded) {
        return ListView.separated(
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
            return index >= state.articles.length
                ? BottomLoader()
                : index == 0
                    ? TopArticle(article: state.articles[index])
                    : SingleArticle(article: state.articles[index]);
          }
        );
      } else
        return Center(child: Text('¡Ocurrio un error!'));
    });
  }
}
