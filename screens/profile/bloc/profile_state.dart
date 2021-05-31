part of 'profile_bloc.dart';

enum ProfileStatus { initial, loading, loaded, error, deleting }

class ProfileState extends Equatable {
  final User user;
  final List<Post> posts;
  final bool isCurrentUser;
  final ProfileStatus status;
  final Failure failure;

  const ProfileState({
    @required this.user,
    @required this.posts,
    @required this.isCurrentUser,
    @required this.status,
    @required this.failure,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      user: User.empty,
      posts: [],
      isCurrentUser: false,
      status: ProfileStatus.initial,
      failure: Failure(),
    );
  }

  @override
  List<Object> get props => [
        user,
        posts,
        isCurrentUser,
        status,
        failure,
      ];

  ProfileState copyWith({
    User user,
    List<Post> posts,
    bool isCurrentUser,
    ProfileStatus status,
    Failure failure,
  }) {
    return ProfileState(
      user: user ?? this.user,
      posts: posts ?? this.posts,
      isCurrentUser: isCurrentUser ?? this.isCurrentUser,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
