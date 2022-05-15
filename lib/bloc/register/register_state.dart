import 'package:register/bloc/countries/country_repository.dart';
import 'package:register/helpers/form_submission_status.dart';

class RegisterState {
  final String username;
  final String email;
  final String password;
  final String confirmPassword;
  final Country? country;
  final String phoneNumber;
  final FormSubmissionStatus status;
  final Exception? error;

  RegisterState(
      {this.username = '',
      this.email = '',
      this.password = '',
      this.confirmPassword = '',
      this.country,
      this.phoneNumber = '',
      this.status = FormSubmissionStatus.initial,
      this.error});

  RegisterState copyWith(
      {String? username,
      String? email,
      String? password,
      String? confirmPassword,
      Country? country,
      String? phoneNumber,
      FormSubmissionStatus? status,
      Exception? error}) {
    return RegisterState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      country: country ?? this.country,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }
}
