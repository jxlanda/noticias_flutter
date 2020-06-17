import 'package:flutter/material.dart';
import 'package:news/pages/pages.dart';
import 'package:news/repositories/repositories.dart';
import 'blocs/blocs.dart';
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

void main() {
  final NewsRepository newsRepository = NewsRepository(
    newsApiClient: NewsApiClient(
      httpClient: http.Client(),
    ),
  );
  BlocSupervisor.delegate = SimpleBlocDelegate();
  runApp(MyApp(newsRepository: newsRepository));
}
 
class MyApp extends StatelessWidget {
  final NewsRepository newsRepository;
  MyApp({Key key, @required this.newsRepository})
      : assert(newsRepository != null),
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noticias',
      home: BlocProvider<BottomNavigationBloc>(
        create: (context) => BottomNavigationBloc(
          firstPageRepository: FirstPageRepository(), 
          secondPageRepository: SecondPageRepository(),
          thirdPageRepository: ThirdPageRepository()
        )
          ..add(AppStarted()),
        child: BottomNavigationPage(newsRepository: newsRepository)
      )
    );
  }
}
