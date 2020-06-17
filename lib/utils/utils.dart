import 'package:flutter/material.dart';
import 'package:news/models/models.dart';
// Plugins
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_icons/flutter_icons.dart';

void launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url, forceWebView: true);
  } else {
    throw 'No se pudo abrir $url';
  }
}

void modalBottomSheet(BuildContext context, Article article) {
  final scaffold = Scaffold.of(context);
  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(FlutterIcons.share_mdi),
                title: Text('Compartir'),
                onTap: () => {
                  Share.share('${article.url}'),
                  Navigator.pop(context)
                }
              ),
              ListTile(
                leading: Icon(FlutterIcons.star_mdi),
                title: Text('Favoritos'),
                onTap: () => {
                  Navigator.pop(context),
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text("Agregado a favoritos"), 
                      duration: Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'Deshacer', 
                        onPressed: (){
                          // Deshacer el cambio
                        }
                      )
                    )
                  )
                }
              ),
              Divider(),
              ListTile(
                leading: Icon(FlutterIcons.close_mdi),
                title: Text('Cerrar'),
                onTap: () => {
                  Navigator.pop(context)
                }
              ),
            ],
          ),
        );
      });
}