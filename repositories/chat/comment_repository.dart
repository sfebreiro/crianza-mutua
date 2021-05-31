import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:crianza_mutua/config/paths.dart';
import 'package:crianza_mutua/models/comment_model.dart';
import 'package:crianza_mutua/repositories/repositories.dart';

class CommentRepository extends BaseCommentRepository {
  final FirebaseFirestore _firebaseFirestore;

  CommentRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createComment({@required Comment comment}) async {
    await _firebaseFirestore
        .collection(Paths.comments)
        .add(comment.toDocument());
  }

  @override
  Stream<List<Future<Comment>>> getComments() {
    return _firebaseFirestore
        .collection(Paths.comments)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => Comment.fromDocument(doc)).toList());
  }

  @override
  @override
  Future<void> deleteComment({String commentId}) async {
    await _firebaseFirestore.collection(Paths.comments).doc(commentId).delete();
  }
}
