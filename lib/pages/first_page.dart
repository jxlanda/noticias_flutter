import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news/blocs/blocs.dart';
import 'package:news/repositories/repositories.dart';
import 'package:news/widgets/search_builder_widget.dart';

class SearchPage extends StatefulWidget {
  // Parametros
  final int number;
  final NewsRepository newsRepository;

  const SearchPage({Key key, @required this.newsRepository, this.number})
      : super();

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // Variables
  String query = '';
  bool isSearching = false;
  final _searchQuery = new TextEditingController();
  Timer _debounce;

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    _debounce.cancel();
    super.dispose();
  }

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        if(_searchQuery.text == query){
          isSearching = false;
        } else {
          query = _searchQuery.text;
          isSearching = true;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(42.0),
        child: AppBar(
            title: Text("Busqueda", style: TextStyle(color: Colors.black)),
            centerTitle: true,
            backgroundColor: Colors.grey[200],
            elevation: 0.0),
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              SearchNewsBloc(newsRepository: widget.newsRepository),
          child: Column(children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                  left: 20.0, right: 20.0, top: 20.0, bottom: 10.0),
              child: TextFormField(
                  controller: _searchQuery,
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      suffixIcon: Icon(Icons.search),
                      hintText: "Buscar",
                      fillColor: Colors.white,
                      filled: true),
                  autofocus: false,
                  onEditingComplete: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onChanged: (value) => _onSearchChanged
              ),
            ),
            Expanded(
              child: SearchNews(query: query, isSearching: isSearching),
            )
          ]),
        ),
      ),
    );
  }
}

