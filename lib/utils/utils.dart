import 'package:flutter/material.dart';
import 'package:news/models/models.dart';
import 'package:news/environment/environment.dart' as env;
// Plugins
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true);
  } else {
    throw 'No se pudo abrir $url';
  }
}

void changeSystemNavBar(bool darkMode) {

  final SystemUiOverlayStyle sysNavBarDark = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light
  );
  final SystemUiOverlayStyle sysNavBarLight = SystemUiOverlayStyle(
    systemNavigationBarColor: Colors.white,
    systemNavigationBarIconBrightness: Brightness.dark
  );

  darkMode
    ? SystemChrome.setSystemUIOverlayStyle(sysNavBarDark) 
    : SystemChrome.setSystemUIOverlayStyle(sysNavBarLight);
}


void modalBottomSheet(BuildContext context, Article article) {
  final scaffold = Scaffold.of(context);
  // Inicializar la base de datos
  final Box<Article> favoritesNews = Hive.box<Article>(env.favorites);
  // Almacenamos todos los favortios en una lista
  final List<Article> favoriteList = favoritesNews.values.toList();
  // Comprobamos si existe article en favoritos
  final bool containsArticle = favoriteList.contains(article);
  // Filtrado de items
  // var filteredUsers = userBox.values.where((user) => user.name.startsWith('s'));

  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(FlutterIcons.share_mdi),
                  title: Text('Compartir'),
                  onTap: () =>
                      {Share.share('${article.url}'), Navigator.pop(context)}),
              containsArticle
                  ? ListTile(
                      leading: Icon(FlutterIcons.star_mdi),
                      title: Text('Eliminar'),
                      onTap: () => {
                            // Eliminamos article de la base de datos
                            article.delete(),
                            // Salimos del modal
                            Navigator.pop(context),
                            scaffold.showSnackBar(SnackBar(
                                content: Text("Eliminado de favoritos"),
                                duration: Duration(seconds: 1),
                                action: SnackBarAction(
                                    label: 'Deshacer',
                                    onPressed: () {
                                      // Agregamos article a la base de datos
                                      favoritesNews.add(article);
                                    })))
                          })
                  : ListTile(
                      leading: Icon(FlutterIcons.star_mdi),
                      title: Text('Guardar'),
                      onTap: () => {
                            // Agregamos article a la base de datos
                            favoritesNews.add(article),
                            // Para actualizar se usa
                            // article.save()
                            // Salimos del modal
                            Navigator.pop(context),
                            scaffold.showSnackBar(SnackBar(
                                content: Text("Agregado a favoritos"),
                                duration: Duration(seconds: 1),
                                action: SnackBarAction(
                                    label: 'Deshacer',
                                    onPressed: () {
                                      // Eliminamos article de la base de datos
                                      article.delete();
                                    })))
                          }),
              Divider(),
              ListTile(
                  leading: Icon(FlutterIcons.close_mdi),
                  title: Text('Cerrar'),
                  onTap: () => {Navigator.pop(context)}),
            ],
          ),
        );
      });
}
