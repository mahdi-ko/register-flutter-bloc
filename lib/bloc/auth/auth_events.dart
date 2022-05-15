abstract class AuthenticationEvent {}

class Authenticated extends AuthenticationEvent {
  final String username;
  final String token;

  Authenticated({
    required this.username,
    required this.token,
  });
}

class LogoutEvent extends AuthenticationEvent {}
