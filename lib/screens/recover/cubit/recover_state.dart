part of 'recover_cubit.dart';

enum RecoverStatus { initial, submitting, success, error }

class RecoverState extends Equatable {
  final String email;

  final RecoverStatus status;
  final Failure failure;

  bool get isFormValid => email.isNotEmpty;

  const RecoverState({
    @required this.email,
    @required this.status,
    @required this.failure,
  });

  factory RecoverState.initial() {
    return RecoverState(
      email: '',
      status: RecoverStatus.initial,
      failure: const Failure(),
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object> get props => [
        email,
        status,
        failure,
      ];

  RecoverState copyWith({
    String email,
    RecoverStatus status,
    Failure failure,
  }) {
    return RecoverState(
      email: email ?? this.email,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}
