import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/models/models.dart';
import 'package:news/utils/utils.dart' as utils;
import 'package:timeago/timeago.dart' as timeago;

class TopArticle extends StatelessWidget {
  // Parametro
  final Article article;
  // Constantes
  final double imageHeight = 200.0;

  const TopArticle({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Constantes en ejecucion
    final TextStyle titleArticle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 16.0, color: Colors.white);
    final TextStyle subtitleArticle = TextStyle(color: Colors.grey[400]);
    
    return Column(children: <Widget>[
      (article.urlToImage == null)
          ? Container(
              width: double.infinity,
              height: imageHeight,
              child: Center(child: Text("No image"))
          )
          : GestureDetector(
            onTap: () => utils.launchURL(article.url),
            child: Stack(overflow: Overflow.visible, children: <Widget>[
                CachedNetworkImage(
                  width: double.infinity,
                  height: imageHeight,
                  fit: BoxFit.cover,
                  imageUrl: article.urlToImage,
                  placeholder: (context, url) => Container(
                    width: double.infinity,
                    color: Colors.grey,
                    height: imageHeight,
                  ),
                  errorWidget: (context, url, error) => Container(
                      width: double.infinity,
                      height: imageHeight,
                      child: Center(child: Text("Error"))
                  )
                ),
                Container(
                  width: double.infinity,
                  height: imageHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(0.0, -1.0),
                      end: Alignment(0.0, 1.2),
                      colors: [Colors.transparent, Colors.black],
                    )
                  )
                ),
                Column(children: <Widget>[
                  SizedBox(height: 135.0),
                  Container(
                    width: double.infinity,
                    child: Row(children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            article.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: titleArticle,
                          )
                        )
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 10.0, left: 20.0),
                        child: InkWell(
                          onTap: () => utils.modalBottomSheet(context, article),
                          child: Icon(Icons.more_vert, color: Colors.white),
                        )
                      )
                    ])
                  ),
                  SizedBox(height: 5.0),
                  Container(
                        padding: EdgeInsets.only(left: 10.0),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          article.source.name + " - " + timeago.format(article.publishedAt, locale: 'es'), 
                          maxLines: 1, 
                          overflow: TextOverflow.ellipsis,
                          style: subtitleArticle
                        ),
                  )
                ])
              ]),
          )
    ]);
  }
}
