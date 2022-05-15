class AuthenticationState {
  final bool authenticated;
  final String? username;
  final String? token;

  AuthenticationState({
    this.authenticated = false,
    this.username,
    this.token,
  });
  AuthenticationState copyWith({
    bool authenticated = false,
    String? username,
    String? token,
  }) {
    return AuthenticationState(
      authenticated: authenticated,
      username: username,
      token: token,
    );
  }

  AuthenticationState empty() {
    return AuthenticationState(
      authenticated: false,
      username: null,
      token: null,
    );
  }
}
