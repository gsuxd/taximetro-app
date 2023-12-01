part of 'verify_user_bloc.dart';

sealed class VerifyUserState extends Equatable {
  const VerifyUserState();
  
  @override
  List<Object> get props => [];
}

final class VerifyUserInitial extends VerifyUserState {}
