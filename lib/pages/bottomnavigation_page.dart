// Folders
import 'package:news/blocs/blocs.dart';
import 'package:news/pages/favorites_page.dart';
import 'package:news/pages/pages.dart';
import 'package:news/repositories/repositories.dart';
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

class BottomNavigationPage extends StatefulWidget {
  final NewsRepository newsRepository;
  const BottomNavigationPage({Key key, @required this.newsRepository})
      : super(key: key);

  @override
  _BottomNavigationPageState createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  int indexStack = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: indexStack,
        children: <Widget>[
          // Pagina 0
          NewsPage(key: PageStorageKey("news"), newsRepository: widget.newsRepository),
          // Otras paginas
          BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
            builder: (context, state) {
              if (state is PageLoading) {
                return Center(
                    child: CircularProgressIndicator()
                );
              }
              if (state is FirstPageLoaded) {
                print("Pagina 1");
                return SearchPage(newsRepository: widget.newsRepository, number: state.number);
              }
              if (state is SecondPageLoaded) {
                print("Pagina 2");
                return FavoritesPage(text: state.text);
              }
              if (state is ThirdPageLoaded) {
                print("Pagina 3");
                return SettingsPage();
              }
              return Container();
            },
          ),
        ]
      ),
      bottomNavigationBar:
          BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
              builder: (BuildContext context, BottomNavigationState state) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex:
              BlocProvider.of<BottomNavigationBloc>(context).currentIndex,
          selectedItemColor: Theme.of(context).accentColor,
          showUnselectedLabels: false,
          unselectedItemColor: Theme.of(context).disabledColor,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(FlutterIcons.newspaper_mco), title: Text("Noticias")),
            BottomNavigationBarItem(
                icon: Icon(FlutterIcons.search_mdi), title: Text("Buscar")),
            BottomNavigationBarItem(
                icon: Icon(FlutterIcons.star_mdi), title: Text("Favoritos")),
            BottomNavigationBarItem(icon: Icon(FlutterIcons.settings_mdi), title: Text("Configuración"))
          ],
          onTap: (index) {
            if(index == 0){
              setState(() {
                indexStack = 0;
                BlocProvider.of<BottomNavigationBloc>(context).currentIndex = 0;
              });
            } else {
              setState(() {
                indexStack = 1;
                BlocProvider.of<BottomNavigationBloc>(context)
                  .add(PageTapped(index: index));
              });
            }
          }
        );
      }),
    );
  }
}
