import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'verify_user_event.dart';
part 'verify_user_state.dart';

class VerifyUserBloc extends Bloc<VerifyUserEvent, VerifyUserState> {
  VerifyUserBloc() : super(VerifyUserInitial()) {
    on<VerifyUserEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
