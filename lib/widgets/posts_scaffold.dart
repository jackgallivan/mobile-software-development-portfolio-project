import 'package:flutter/material.dart';

class PostsScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final Widget? bottomWidget;

  const PostsScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.bottomWidget,
  }) : super(key: key);

  /* BUILD */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: body,
      bottomNavigationBar: bottomWidget,
    );
  }
}
