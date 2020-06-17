import 'package:flutter/material.dart';
import 'package:news/models/models.dart';
// Plugins
import 'package:news/utils/utils.dart' as utils;
import 'package:news/widgets/widgets.dart';
import 'package:timeago/timeago.dart' as timeago;

class SingleArticle extends StatelessWidget {
  // Parametro
  final Article article;
  // Constantes
  final double imageWidth = 120.0;
  final double imageHeight = 92.0;
  final TextStyle titleArticle =
      TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0);
  final TextStyle subtitleArticle = TextStyle(color: Colors.grey[600]);

  SingleArticle({Key key, @required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.0),
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => utils.launchURL(article.url),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ImageArticle(
                  imageWidth: imageWidth,
                  imageHeight: imageHeight,
                  article: article),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                      height: 70.0,
                      child: Text(article.title,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: titleArticle),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 10.0, bottom: 5.0),
                      child: Text(
                          article.source.name +
                              " - " +
                              timeago.format(article.publishedAt, locale: 'es'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: subtitleArticle),
                    )
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.only(top: 5.0),
                child: InkWell(
                  onTap: () => utils.modalBottomSheet(context, article),
                  child: Icon(
                    Icons.more_vert,
                    color: Colors.grey[600],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

