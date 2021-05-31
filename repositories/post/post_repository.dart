import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:crianza_mutua/config/paths.dart';
import 'package:crianza_mutua/models/post_model.dart';
import 'package:crianza_mutua/repositories/repositories.dart';

class PostRepository extends BasePostRepository {
  final FirebaseFirestore _firebaseFirestore;

  PostRepository({
    FirebaseFirestore firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createPost({@required Post post}) async {
    await _firebaseFirestore.collection(Paths.posts).add(post.toDocument());
  }

  Future<List<Post>> getPosts({String lastPostId}) async {
    QuerySnapshot postsSnap;
    if (lastPostId == null) {
      postsSnap = await _firebaseFirestore
          .collection(Paths.posts)
          .orderBy('date', descending: true)
          .limit(20)
          .get();
    } else {
      final lastPostDoc = await _firebaseFirestore
          .collection(Paths.posts)
          .doc(lastPostId)
          .get();

      if (!lastPostDoc.exists) {
        return [];
      }

      postsSnap = await _firebaseFirestore
          .collection(Paths.posts)
          .orderBy('date', descending: true)
          .startAfterDocument(lastPostDoc)
          .limit(20)
          .get();
    }

    final posts = Future.wait(
        postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList());
    return posts;
  }

  @override
  Future<void> deletePost({String postId}) async {
    await _firebaseFirestore.collection(Paths.posts).doc(postId).delete();
  }

  Future<List<Post>> getUserPosts({String userId}) async {
    QuerySnapshot postsSnap;

    postsSnap = await _firebaseFirestore
        .collection(Paths.posts)
        .orderBy('date', descending: true)
        .limit(20)
        .get();

    final posts = Future.wait(
        postsSnap.docs.map((doc) => Post.fromDocument(doc)).toList());
    return posts;
  }
}
