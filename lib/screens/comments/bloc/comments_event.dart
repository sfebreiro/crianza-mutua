part of 'comments_bloc.dart';

abstract class CommentsEvent extends Equatable {
  const CommentsEvent();

  @override
  List<Object> get props => [];
}

class CommentsFetchComments extends CommentsEvent {
  final String user;

  const CommentsFetchComments({@required this.user});

  @override
  List<Object> get props => [user];
}

class CommentsUpdateComments extends CommentsEvent {
  final List<Comment> comments;

  CommentsUpdateComments({@required this.comments});

  @override
  List<Object> get props => [comments];
}

class CommentsPostComment extends CommentsEvent {
  final String content;

  CommentsPostComment({
    @required this.content,
  });

  @override
  List<Object> get props => [
        content,
      ];
}

class CommentsDeleteComment extends CommentsEvent {
  final String commentId;

  const CommentsDeleteComment({@required this.commentId});

  @override
  List<Object> get props => [commentId];
}
