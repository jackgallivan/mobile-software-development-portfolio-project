import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/post_details.dart';
import '../screens/post_entry_form.dart';
import '../widgets/posts_scaffold.dart';
import '../widgets/large_button.dart';
import '../models/post_entry.dart';
import '../db/post_entry_dao.dart';

class PostsListScreen extends StatefulWidget {
  static const routeName = 'posts_list';
  final String title;

  const PostsListScreen({Key? key, required this.title}) : super(key: key);

  @override
  State<PostsListScreen> createState() => _PostsListScreenState();
}

class _PostsListScreenState extends State<PostsListScreen> {
  int totalQuantity = 0;

  final snapshots =
      PostEntryDAO.postsRef.orderBy('date', descending: true).snapshots();

  @override
  void initState() {
    super.initState();
    getTotalItems();
  }

  void getTotalItems() {
    snapshots.listen((event) {
      for (var docChange in event.docChanges) {
        var docSnapshot = docChange.doc;
        setState(() {
          totalQuantity += docSnapshot.get('quantity') as int;
        });
      }
    });
  }

  /* BUILD */
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: snapshots,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        Widget body;
        String title = widget.title;
        if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
          body = postsList(context, snapshot);
          title += ' - $totalQuantity';
        } else {
          body = const Center(child: CircularProgressIndicator());
        }
        return PostsScaffold(
          title: title,
          body: body,
          bottomWidget: addPostButton(context),
        );
      },
    );
  }

  Widget postsList(
      BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 24),
      itemCount: snapshot.data!.docs.length,
      itemBuilder: (context, index) {
        PostEntry postEntry = snapshot.data!.docs[index].data() as PostEntry;
        String date = postEntry.dateStringLong;
        String numWasteItems = postEntry.quantityString;
        return Semantics(
          child: ListTile(
            title: Text(date),
            trailing: Text(numWasteItems),
            onTap: () {
              Navigator.of(context).pushNamed(
                PostDetailsScreen.routeName,
                arguments: postEntry,
              );
            },
            shape: const Border(top: BorderSide()),
          ),
          button: true,
          enabled: true,
          label: 'Post from $date with $numWasteItems waste items',
          onTapHint: 'View the details of this post',
        );
      },
    );
  }

  Widget addPostButton(BuildContext context) {
    return Semantics(
      child: LargeButton(
        onPressed: () =>
            Navigator.of(context).pushNamed(PostEntryForm.routeName),
        child: const Icon(Icons.photo_camera),
      ),
      button: true,
      enabled: true,
      label: 'Button to select an image to post',
      onTapHint: 'Select an image to post',
    );
  }
}
