import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:crianza_mutua/blocs/auth/auth_bloc.dart';
import 'package:crianza_mutua/models/models.dart';
import 'package:crianza_mutua/repositories/repositories.dart';

part 'comments_event.dart';
part 'comments_state.dart';

StreamSubscription<List<Future<Comment>>> _commentsSubscription;

class CommentsBloc extends Bloc<CommentsEvent, CommentsState> {
  final CommentRepository _commentRepository;
  final UserRepository _userRepository;
  final AuthBloc _authBloc;

  CommentsBloc({
    @required CommentRepository commentRepository,
    @required UserRepository userRepository,
    @required AuthBloc authBloc,
  })  : _commentRepository = commentRepository,
        _userRepository = userRepository,
        _authBloc = authBloc,
        super(CommentsState.initial());

  @override
  Future<void> close() {
    _commentsSubscription.cancel();
    return super.close();
  }

  @override
  Stream<CommentsState> mapEventToState(
    CommentsEvent event,
  ) async* {
    if (event is CommentsFetchComments) {
      yield* _mapCommentsFetchCommentsToState(event);
    } else if (event is CommentsUpdateComments) {
      yield* _mapCommentsUpdateCommentsToState(event);
    } else if (event is CommentsPostComment) {
      yield* _mapCommentsPostCommentsToState(event);
    } else if (event is CommentsDeleteComment) {
      yield* _mapCommentsDeleteCommentsToState(event);
    }
  }

  Stream<CommentsState> _mapCommentsFetchCommentsToState(
    CommentsFetchComments event,
  ) async* {
    yield state.copyWith(status: CommentStatus.loading);
    try {
      final user = await _userRepository.getUserWithId(userId: event.user);
      final isCurrentUser = _authBloc.state.user.uid == event.user;

      _commentsSubscription?.cancel();
      _commentsSubscription =
          _commentRepository.getComments().listen((comments) async {
        final allComments = await Future.wait(comments);
        add(CommentsUpdateComments(comments: allComments));
      });

      yield state.copyWith(
        user: user,
        isCurrentUser: isCurrentUser,
        status: CommentStatus.loaded,
      );
    } catch (err) {
      yield state.copyWith(
        status: CommentStatus.error,
        failure: const Failure(
          message:
              'No se pudieron cargar los mensajes. Por favor, vuelve a intentarlo.',
        ),
      );
    }
  }

  Stream<CommentsState> _mapCommentsUpdateCommentsToState(
    CommentsUpdateComments event,
  ) async* {
    yield state.copyWith(comments: event.comments);
  }

  Stream<CommentsState> _mapCommentsPostCommentsToState(
    CommentsPostComment event,
  ) async* {
    yield state.copyWith(status: CommentStatus.submitting);
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);
      final comment = Comment(
        author: author,
        content: event.content,
        date: DateTime.now(),
      );

      await _commentRepository.createComment(comment: comment);

      yield state.copyWith(status: CommentStatus.loaded);
    } catch (err) {
      yield state.copyWith(
        status: CommentStatus.error,
        failure: const Failure(
          message:
              'No se pudo enviar el mensaje. Por favor, vuelve a intentarlo.',
        ),
      );
    }
  }

  Stream<CommentsState> _mapCommentsDeleteCommentsToState(
      CommentsDeleteComment event) async* {
    yield (state.copyWith(status: CommentStatus.deleting));
    await _commentRepository.deleteComment(commentId: event.commentId);
  }
}
