part of 'edit_profile_cubit.dart';

enum EditProfileStatus { initial, submitting, success, error, deleting }

class EditProfileState extends Equatable {
  final List<Post> post;
  final File profileImage;
  final String username;
  final String email;
  final String bio;
  final EditProfileStatus status;
  final Failure failure;

  const EditProfileState({
    @required this.post,
    @required this.profileImage,
    @required this.username,
    @required this.email,
    @required this.bio,
    @required this.status,
    @required this.failure,
  });

  factory EditProfileState.initial() {
    return const EditProfileState(
      post: [],
      profileImage: null,
      username: '',
      email: '',
      bio: '',
      status: EditProfileStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        post,
        profileImage,
        username,
        email,
        bio,
        status,
        failure,
      ];

  EditProfileState copyWith({
    List<Post> post,
    File profileImage,
    String username,
    String email,
    String bio,
    EditProfileStatus status,
    Failure failure,
  }) {
    return EditProfileState(
      post: post ?? this.post,
      profileImage: profileImage ?? this.profileImage,
      username: username ?? this.username,
      email: email ?? this.email,
      bio: bio ?? this.bio,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
