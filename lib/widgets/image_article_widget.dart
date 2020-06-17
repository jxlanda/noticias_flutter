import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:news/models/models.dart';

class ImageArticle extends StatelessWidget {
  const ImageArticle({
    Key key,
    @required this.imageWidth,
    @required this.imageHeight,
    @required this.article,
  }) : super(key: key);

  final double imageWidth;
  final double imageHeight;
  final Article article;

  @override
  Widget build(BuildContext context) {
    try {
      return CachedNetworkImage(
          width: imageWidth,
          height: imageHeight,
          fit: BoxFit.cover,
          imageUrl: article.urlToImage,
          placeholder: (context, url) => Container(
                color: Colors.grey,
                width: imageWidth,
                height: imageHeight,
          ),
          errorWidget: (context, url, error) => Container(
              width: imageWidth,
              height: imageHeight,
              child: Center(child: Text("Error"))));
    } catch (error) {
      return NoImage(imageWidth: imageWidth, imageHeight: imageHeight);
    }
  }
}

class NoImage extends StatelessWidget {
  const NoImage({
    Key key,
    @required this.imageWidth,
    @required this.imageHeight,
  }) : super(key: key);

  final double imageWidth;
  final double imageHeight;

  @override
  Widget build(BuildContext context) {
    return Container(
        width: imageWidth,
        height: imageHeight,
        child: Center(child: Text("No hay imagen")));
  }
}