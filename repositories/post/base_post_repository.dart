import 'package:crianza_mutua/models/models.dart';

abstract class BasePostRepository {
  Future<void> createPost({Post post});
  Future<List<Post>> getPosts({String lastPostId});
  Future<void> deletePost({String postId});
  Future<List<Post>> getUserPosts({String userId});
}
