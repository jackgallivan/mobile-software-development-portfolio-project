import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/posts_scaffold.dart';
import '../models/post_entry.dart';

class PostDetailsScreen extends StatelessWidget {
  const PostDetailsScreen({Key? key, required this.title}) : super(key: key);

  static const routeName = 'post_details';
  final String title;

  /* BUILD */
  @override
  Widget build(BuildContext context) {
    final PostEntry postEntry =
        ModalRoute.of(context)!.settings.arguments as PostEntry;

    return PostsScaffold(
      title: title,
      body: postDetails(context, postEntry),
    );
  }

  Widget postDetails(BuildContext context, PostEntry postEntry) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            postEntry.dateStringShort,
            style: Theme.of(context).textTheme.headline4,
          ),
          Builder(
            builder: (BuildContext context) {
              if (postEntry.imageURL != null && postEntry.imageURL != 'null') {
                return CachedNetworkImage(
                  imageUrl: postEntry.imageURL!,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.broken_image),
                  fadeOutDuration: Duration.zero,
                );
              }
              return const Icon(Icons.image);
            },
          ),
          Text(
            postEntry.quantityString + ' items',
            style: Theme.of(context).textTheme.headline4,
          ),
          Text(postEntry.locationString),
        ],
      ),
    );
  }
}
