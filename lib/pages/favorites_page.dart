import 'package:flutter/material.dart';

class FavoritesPage extends StatelessWidget {
  final String text;
  const FavoritesPage({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(child: Text('The text is: $text')),
    );
  }
}