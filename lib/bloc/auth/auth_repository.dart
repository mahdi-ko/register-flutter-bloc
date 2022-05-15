//just mimicing sending an async post request with Future.delayed

class AuthRepository {
  Future<String?> register({
    required String username,
    required String email,
    required String country,
    required String phoneNumber,
  }) async {
    try {
      //should be send request to register api with the new user's data
      //recieve token as response
      //decode the response and return the token
      await Future.delayed(const Duration(seconds: 1));
      return 'token from server';
    } catch (error) {
      throw Exception("Register Failed");
    }
  }
}
