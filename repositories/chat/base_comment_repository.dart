import 'package:crianza_mutua/models/models.dart';

abstract class BaseCommentRepository {
  Future<void> createComment({Comment comment});
  Stream<List<Future<Comment>>> getComments();
  Future<void> deleteComment({String commentId});
}
