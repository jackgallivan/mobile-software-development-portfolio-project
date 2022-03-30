import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/post_entry.dart';

class PostEntryDAO {
  static final PostEntryDAO _instance = PostEntryDAO._internal();
  static final CollectionReference _postsRef =
      FirebaseFirestore.instance.collection('posts').withConverter<PostEntry>(
            fromFirestore: (snapshot, _) => PostEntry.fromMap(snapshot.data()!),
            toFirestore: (post, _) => post.toMap(),
          );

  factory PostEntryDAO() => _instance;

  static CollectionReference get postsRef => _postsRef;

  PostEntryDAO._internal();
}
