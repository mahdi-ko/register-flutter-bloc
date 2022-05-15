import 'package:register/bloc/countries/country_repository.dart';

abstract class RegisterEvent {}

class NameChangedEvent extends RegisterEvent {
  final String username;

  NameChangedEvent({required this.username});
}

class EmailChangedEvent extends RegisterEvent {
  final String email;

  EmailChangedEvent({required this.email});
}

class PasswordChangedEvent extends RegisterEvent {
  final String password;
  PasswordChangedEvent({required this.password});
}

class ConfirmPasswordChangedEvent extends RegisterEvent {
  final String confirmPassword;

  ConfirmPasswordChangedEvent({required this.confirmPassword});
}

class CountryChangedEvent extends RegisterEvent {
  final Country country;

  CountryChangedEvent({required this.country});
}

class PhoneNumberChangedEvent extends RegisterEvent {
  final String phoneNumber;

  PhoneNumberChangedEvent({required this.phoneNumber});
}

class SubmitChangedEvent extends RegisterEvent {}
