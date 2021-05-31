part of 'feed_bloc.dart';

enum FeedStatus { initial, loading, loaded, paginating, error }

class FeedState extends Equatable {
  final List<Post> post;
  final User user;
  final FeedStatus status;
  final Failure failure;

  const FeedState({
    @required this.post,
    @required this.user,
    @required this.status,
    @required this.failure,
  });

  factory FeedState.initial() {
    return const FeedState(
      post: [],
      user: User.empty,
      status: FeedStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        post,
        user,
        status,
        failure,
      ];

  FeedState copyWith({
    List<Post> post,
    User user,
    FeedStatus status,
    Failure failure,
  }) {
    return FeedState(
      post: post ?? this.post,
      user: user ?? this.user,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
