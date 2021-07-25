import 'package:flutter/material.dart';
class TodoAppBar extends StatelessWidget {
  final String title;
  final Color color;

  TodoAppBar(this.title, this.color);

  @override
  Widget build(BuildContext context) {
    return FlexibleSpaceBar(
      centerTitle: true,
      title: Text(title, style: TextStyle(color: Colors.white, fontSize: 16.0)),
      background: Container(color: color),
    );
  }
}

