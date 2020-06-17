import 'package:flutter/material.dart';
import 'package:news/blocs/blocs.dart';
import 'package:news/repositories/repositories.dart';
import 'package:news/widgets/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NewsPage extends StatelessWidget {
  final NewsRepository newsRepository;
  const NewsPage({Key key, @required this.newsRepository}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    print("Page 0, comes from:");
    return DefaultTabController(
        length: 7,
        child: SafeArea(
          child: Scaffold(
            appBar: TabBar(
              isScrollable: true,
              labelColor: Colors.blue,
              //indicator: BoxDecoration(color: Colors.blue),
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(child: Text("General")),
                Tab(child: Text("Ciencia")),
                Tab(child: Text("Deportes")),
                Tab(child: Text("Entretenimiento")),
                Tab(child: Text("Negocio")),
                Tab(child: Text("Salud")),
                Tab(child: Text("Tecnología")),
              ],
            ),
            backgroundColor: Colors.grey[200],
            body: TabBarView(
              children: [
                BlocProvider(
                    create: (context) =>
                        NewsBloc(newsRepository: newsRepository),
                    child: NewsBuilder(category: 'general')),
                BlocProvider(
                    create: (context) =>
                        NewsBloc(newsRepository: newsRepository),
                    child: NewsBuilder(category: 'science')),
                BlocProvider(
                    create: (context) =>
                        NewsBloc(newsRepository: newsRepository),
                    child: NewsBuilder(category: 'sports')),
                BlocProvider(
                    create: (context) =>
                        NewsBloc(newsRepository: newsRepository),
                    child: NewsBuilder(category: 'entertainment')),
                BlocProvider(
                    create: (context) =>
                        NewsBloc(newsRepository: newsRepository),
                    child: NewsBuilder(category: 'business')),
                BlocProvider(
                    create: (context) =>
                        NewsBloc(newsRepository: newsRepository),
                    child: NewsBuilder(category: 'health')),
                BlocProvider(
                    create: (context) =>
                        NewsBloc(newsRepository: newsRepository),
                    child: NewsBuilder(category: 'technology'))
              ],
            ),
          ),
        ));
  }
}

// appBar: AppBar(
//   title: Text("Noticias"),
//   bottom: TabBar(
//     isScrollable: true,
//     tabs: [
//       Tab(child: Text("General")),
//       Tab(child: Text("Ciencia")),
//       Tab(child: Text("Deportes")),
//       Tab(child: Text("Entretenimiento")),
//       Tab(child: Text("Negocio")),
//       Tab(child: Text("Salud")),
//       Tab(child: Text("Tecnología")),
//     ],
//   ),
// ),
