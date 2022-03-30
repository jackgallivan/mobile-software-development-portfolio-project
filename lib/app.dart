import 'package:flutter/material.dart';

import 'screens/posts_list.dart';
import 'screens/post_details.dart';
import 'screens/post_entry_form.dart';

class App extends StatefulWidget {
  final String title;

  const App({Key? key, required this.title}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late final Map<String, Widget Function(BuildContext)> routes;

  @override
  void initState() {
    super.initState();
    routes = {
      PostsListScreen.routeName: (context) {
        return PostsListScreen(title: widget.title);
      },
      PostDetailsScreen.routeName: (context) {
        return PostDetailsScreen(title: widget.title);
      },
      PostEntryForm.routeName: (context) {
        return const PostEntryForm();
      },
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: widget.title,
      theme: ThemeData.dark(),
      routes: routes,
      initialRoute: PostsListScreen.routeName,
    );
  }
}
