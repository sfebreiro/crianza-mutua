import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:crianza_mutua/blocs/auth/auth_bloc.dart';
import 'package:crianza_mutua/models/failure_model.dart';
import 'package:crianza_mutua/models/models.dart';
import 'package:crianza_mutua/repositories/repositories.dart';

part 'feed_event.dart';
part 'feed_state.dart';

class FeedBloc extends Bloc<FeedEvent, FeedState> {
  final PostRepository _postRepository;

  // ignore: unused_field
  final UserRepository _userRepository;

  // ignore: unused_field
  final AuthBloc _authBloc;

  FeedBloc({
    @required PostRepository postRepository,
    @required UserRepository userRepository,
    @required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _userRepository = userRepository,
        _authBloc = authBloc,
        super(FeedState.initial());

  @override
  Stream<FeedState> mapEventToState(
    FeedEvent event,
  ) async* {
    if (event is FeedFecthPosts) {
      yield* _mapFeedFetchPostsToState(event);
    } else if (event is FeedPaginatePosts) {
      yield* _mapFeedPaginatePostsToState();
    }
  }

  Stream<FeedState> _mapFeedFetchPostsToState(FeedFecthPosts event) async* {
    yield state.copyWith(post: [], status: FeedStatus.loading);
    try {
      final posts = await _postRepository.getPosts();
      //final user = await _userRepository.getUserWithId(userId: event.user);

      yield state.copyWith(
        post: posts,
        //user: user,
        status: FeedStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: FeedStatus.error,
        failure: Failure(
            message:
                'No se ha podido cargar el contenido. Por favor, vuelve a intentarlo.'),
      );
    }
  }

  Stream<FeedState> _mapFeedPaginatePostsToState() async* {
    yield state.copyWith(status: FeedStatus.paginating);
    try {
      final lastPostId = state.post.isNotEmpty ? state.post.last.id : null;
      final posts = await _postRepository.getPosts(lastPostId: lastPostId);
      final updatedPost = List<Post>.from(state.post)..addAll(posts);

      yield state.copyWith(post: updatedPost, status: FeedStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: FeedStatus.error,
        failure: Failure(
            message:
                'No se ha podido cargar el contenido. Por favor, vuelve a intentarlo.'),
      );
    }
  }
}
