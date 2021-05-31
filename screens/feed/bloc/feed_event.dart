part of 'feed_bloc.dart';

abstract class FeedEvent extends Equatable {
  const FeedEvent();

  @override
  List<Object> get props => [];
}

class FeedFecthPosts extends FeedEvent {
  // final String user;
//
  // const FeedFecthPosts({@required this.user});
//
  // @override
  // List<Object> get props => [user];
}

class FeedPaginatePosts extends FeedEvent {}
