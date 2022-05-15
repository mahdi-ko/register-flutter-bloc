import 'package:register/bloc/countries/country_repository.dart';

String? _nullValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return "Please fill out this field";
  }
  return null;
}

String? usernameValidator({required String? username}) {
  String? errorMessage;
  errorMessage = _nullValidator(username);
  return errorMessage;
}

String? emailValidator({required String? email}) {
  String? errorMessage;
  errorMessage = _nullValidator(email);
  errorMessage ??=
      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(email!)
          ? null
          : "Please enter a valid email";
  return errorMessage;
}

String? passwordValidator({required String? password}) {
  String? errorMessage;
  errorMessage = _nullValidator(password);
  errorMessage ??=
      password!.length >= 7 ? null : "Please enter at least 7 characters";
  errorMessage ??= password!.contains(RegExp(r'[0-9]'))
      ? null
      : "Please enter at least 1 number";
  errorMessage ??= password!.contains(RegExp(r'[A-Z]'))
      ? null
      : "Please enter at least 1 capital letter";
  errorMessage ??= password!.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))
      ? null
      : "Please enter at least 1 special character";
  return errorMessage;
}

String? confirmPasswordValidator(
    {required String? password, required String? confirmPassword}) {
  String? errorMessage;
  errorMessage = _nullValidator(confirmPassword);
  if (confirmPassword != '') {
    errorMessage ??=
        password == confirmPassword ? null : "Passwords does not match";
  }
  return errorMessage;
}

String? phoneNumberValidator(
    {required String? phoneNumber, required Country? country}) {
  String? errorMessage;
  errorMessage = _nullValidator(phoneNumber);
  errorMessage ??= country != null ? null : "Please select a country first";
  if (country?.code != null) {
    errorMessage ??= phoneNumber!.startsWith(country!.phoneCode.toString())
        ? null
        : "Phone code should be " + country.phoneCode.toString();
  }
  errorMessage ??= phoneNumber!.length == country!.phoneDigits
      ? null
      : "Phone must consist of ${country.phoneDigits} digits";
  return errorMessage;
}
