part of 'comments_bloc.dart';

enum CommentStatus { initial, loading, loaded, submitting, error, deleting }

class CommentsState extends Equatable {
  final List<Comment> comments;
  final User user;
  final bool isCurrentUser;
  final CommentStatus status;
  final Failure failure;

  const CommentsState({
    @required this.comments,
    @required this.user,
    @required this.isCurrentUser,
    @required this.status,
    @required this.failure,
  });

  factory CommentsState.initial() {
    return const CommentsState(
      comments: [],
      user: User.empty,
      isCurrentUser: false,
      status: CommentStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        comments,
        user,
        isCurrentUser,
        status,
        failure,
      ];

  CommentsState copyWith({
    List<Comment> comments,
    User user,
    bool isCurrentUser,
    CommentStatus status,
    Failure failure,
  }) {
    return CommentsState(
      comments: comments ?? this.comments,
      user: user ?? this.user,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
