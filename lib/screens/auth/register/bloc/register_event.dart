part of 'register_bloc.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object> get props => [];
}

final class RegisterUserEvent extends RegisterEvent {
  final String email;
  final String password;
  final String confirmPassword;
  final String dateBirth;
  final String name;
  final String lastName;
  final String phone;
  const RegisterUserEvent({
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.dateBirth,
    required this.name,
    required this.lastName,
    required this.phone,
  });

  @override
  List<Object> get props => [
        email,
        password,
        confirmPassword,
        dateBirth,
        name,
        lastName,
        phone,
      ];
}
