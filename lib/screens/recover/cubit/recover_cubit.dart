import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:crianza_mutua/models/models.dart';
import 'package:crianza_mutua/repositories/repositories.dart';

part 'recover_state.dart';

class RecoverCubit extends Cubit<RecoverState> {
  final AuthRepository _authRepository;

  RecoverCubit({
    @required AuthRepository authRepository,
  })  : _authRepository = authRepository,
        super(RecoverState.initial());

  void emailChanged(String value) {
    emit(state.copyWith(
      email: value,
      status: RecoverStatus.initial,
    ));
  }

  void sendPasswordResetEmail() async {
    if (!state.isFormValid || state.status == RecoverStatus.submitting) return;

    emit(
      state.copyWith(status: RecoverStatus.submitting),
    );

    try {
      await _authRepository.sendPasswordResetEmail(
        email: state.email,
      );
      emit(
        state.copyWith(status: RecoverStatus.success),
      );
    } on Failure catch (err) {
      emit(
        state.copyWith(
          failure: err,
          status: RecoverStatus.error,
        ),
      );
    }
  }
}
