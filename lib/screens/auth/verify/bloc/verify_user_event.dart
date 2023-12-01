part of 'verify_user_bloc.dart';

sealed class VerifyUserEvent extends Equatable {
  const VerifyUserEvent();

  @override
  List<Object> get props => [];
}

final class VerifyUserEmail extends VerifyUserEvent {
  final String email;
  const VerifyUserEmail({
    required this.email,
  });

  @override
  List<Object> get props => [
        email,
      ];
}

final class VerifyUserPhone extends VerifyUserEvent {
  final String phone;
  const VerifyUserPhone({
    required this.phone,
  });

  @override
  List<Object> get props => [
        phone,
      ];
}

final class SendCodeEvent extends VerifyUserEvent {
  final String code;
  const SendCodeEvent(this.code);
}
