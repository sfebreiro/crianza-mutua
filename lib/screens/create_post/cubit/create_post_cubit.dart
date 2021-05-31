import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:crianza_mutua/blocs/auth/auth_bloc.dart';
import 'package:crianza_mutua/models/models.dart';
import 'package:crianza_mutua/repositories/repositories.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _postRepository;
  // ignore: unused_field
  final StorageRepository _storageRepository;
  final AuthBloc _authBloc;

  CreatePostCubit({
    @required PostRepository postRepository,
    @required StorageRepository storageRepository,
    @required AuthBloc authBloc,
  })  : _postRepository = postRepository,
        _storageRepository = storageRepository,
        _authBloc = authBloc,
        super(CreatePostState.initial());

  void postImageChanged(File file) {
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void postTitleChanged(String title) {
    emit(state.copyWith(title: title, status: CreatePostStatus.initial));
  }

  void postCaptionChanged(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void postLinkChanged(String link) {
    emit(state.copyWith(link: link, status: CreatePostStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);

      // final postImageUrl = await _storageRepository.uploadPostImage(
      //  image: state.postImage,
      // );

      final post = Post(
        author: author,
        // imageUrl: postImageUrl,
        title: state.title,
        caption: state.caption,
        link: state.link,
        date: DateTime.now(),
      );

      await _postRepository.createPost(post: post);

      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (err) {
      emit(
        state.copyWith(
            status: CreatePostStatus.error,
            failure: Failure(
                message:
                    'Algo ha salido mal, no se ha podido crear el post. Por favor, vuelve a intentarlo.')),
      );
    }
  }

  void reset() {
    emit(CreatePostState.initial());
  }
}
