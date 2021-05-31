import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:crianza_mutua/models/models.dart';
import 'package:crianza_mutua/repositories/repositories.dart';
import 'package:crianza_mutua/repositories/user/user_repository.dart';
import 'package:crianza_mutua/screens/profile/bloc/profile_bloc.dart';

part 'edit_profile_state.dart';

class EditProfileCubit extends Cubit<EditProfileState> {
  final UserRepository _userRepository;
  final StorageRepository _storageRepository;
  final AuthRepository _authRepository;
  final ProfileBloc _profileBloc;

  EditProfileCubit({
    @required UserRepository userRepository,
    @required StorageRepository storageRepository,
    @required AuthRepository authRepository,
    @required ProfileBloc profileBloc,
  })  : _userRepository = userRepository,
        _storageRepository = storageRepository,
        _authRepository = authRepository,
        _profileBloc = profileBloc,
        super(EditProfileState.initial()) {
    final user = _profileBloc.state.user;
    emit(state.copyWith(
      username: user.username,
      email: user.email,
      bio: user.bio,
    ));
  }

  void profileImageChanged(File image) {
    emit(state.copyWith(
      profileImage: image,
      status: EditProfileStatus.initial,
    ));
  }

  void usernameChanged(String username) {
    emit(state.copyWith(
      username: username,
      status: EditProfileStatus.initial,
    ));
  }

  void bioChanged(String bio) {
    emit(state.copyWith(
      bio: bio,
      status: EditProfileStatus.initial,
    ));
  }

  void submit() async {
    emit(state.copyWith(status: EditProfileStatus.submitting));
    try {
      final user = _profileBloc.state.user;

      var profileImageUrl = user.profileImageUrl;
      if (state.profileImage != null) {
        profileImageUrl = await _storageRepository.uploadProfileImage(
          url: profileImageUrl,
          image: state.profileImage,
        );
      }

      final updatedUser = user.copyWith(
        username: state.username,
        bio: state.bio,
        profileImageUrl: profileImageUrl,
      );

      await _userRepository.updateUser(user: updatedUser);

      _profileBloc.add(
        ProfileLoadUser(userId: user.id),
      );

      emit(
        state.copyWith(status: EditProfileStatus.success),
      );
    } catch (err) {
      emit(
        state.copyWith(
          status: EditProfileStatus.error,
          failure: const Failure(
              message:
                  'No se ha podido actualizar el perfil. Por favor vuelve a intentarlo.'),
        ),
      );
    }
  }

  void deleteUser() async {
    emit(state.copyWith(status: EditProfileStatus.deleting));
    await _authRepository.deleteUser();
  }

  // Isn´t use yet because if the userId is deleted I need to delete the post and messages too
  void deleteUserData() async {
    final user = _profileBloc.state.user;
    emit(state.copyWith(status: EditProfileStatus.deleting));
    await _userRepository.deleteUser(userId: user.id);
  }
}
