part of 'create_post_cubit.dart';

enum CreatePostStatus { initial, submitting, success, error }

class CreatePostState extends Equatable {
  final File postImage;
  final String title;
  final String caption;
  final String link;
  final CreatePostStatus status;
  final Failure failure;

  const CreatePostState({
    this.postImage,
    @required this.title,
    @required this.caption,
    @required this.link,
    @required this.status,
    @required this.failure,
  });

  factory CreatePostState.initial() {
    return const CreatePostState(
      postImage: null,
      title: '',
      caption: '',
      link: '',
      status: CreatePostStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        postImage,
        title,
        caption,
        link,
        status,
        failure,
      ];

  CreatePostState copyWith({
    File postImage,
    String title,
    String caption,
    String link,
    CreatePostStatus status,
    Failure failure,
  }) {
    return CreatePostState(
      postImage: postImage ?? this.postImage,
      title: title ?? this.title,
      caption: caption ?? this.caption,
      link: link ?? this.link,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
