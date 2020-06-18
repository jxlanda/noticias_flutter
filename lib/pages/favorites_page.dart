import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:news/models/models.dart';
import 'package:news/widgets/single_article_widget.dart';

class FavoritesPage extends StatelessWidget {
  final String text;
  const FavoritesPage({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(42.0),
        child: AppBar(
            title: Text("Favoritos"),
            centerTitle: true
        ),
      ),
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Article>('favorites').listenable(),
        builder: (BuildContext context, Box<Article> box, Widget widget) {
          // Genera una lista de keys la base de datos favorites
          List<int> keys = box.keys.cast<int>().toList();
          if(keys.length == 0)
          return Center(child: Text("No hay favoritos"));
          else return ListView.separated(
            itemBuilder: (context, index) {
              return SingleArticle(article: box.get(keys[index]));
            }, 
            separatorBuilder: (context, index) => SizedBox(height: 10.0), 
            itemCount: keys.length
          );
        }
      ),
    );
  }
}