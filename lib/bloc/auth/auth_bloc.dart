import 'package:flutter_bloc/flutter_bloc.dart';
import './auth_events.dart';
import './auth_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  void _onEvent(
      AuthenticationEvent event, Emitter<AuthenticationState> emit) async {
    if (event is Authenticated) {
      emit(state.copyWith(
        authenticated: true,
        username: event.username,
        token: event.token,
      ));
    } else if (event is LogoutEvent) {
      emit(state.empty());
    }
  }

  AuthenticationBloc() : super(AuthenticationState()) {
    on<AuthenticationEvent>(_onEvent);
  }
}
