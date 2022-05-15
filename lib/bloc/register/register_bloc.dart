import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register/bloc/auth/auth_bloc.dart';
import 'package:register/bloc/auth/auth_events.dart';
import 'package:register/bloc/auth/auth_repository.dart';
import 'package:register/bloc/countries/countries_bloc.dart';
import 'package:register/helpers/form_submission_status.dart';
import './register_events.dart';
import './register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  void _onEvent(RegisterEvent event, Emitter<RegisterState> emit) async {
    if (event is NameChangedEvent) {
      emit(state.copyWith(username: event.username));
    }
    if (event is EmailChangedEvent) {
      emit(state.copyWith(email: event.email));
    }
    if (event is PasswordChangedEvent) {
      emit(state.copyWith(password: event.password));
    }
    if (event is ConfirmPasswordChangedEvent) {
      emit(state.copyWith(confirmPassword: event.confirmPassword));
    }
    if (event is CountryChangedEvent) {
      emit(state.copyWith(country: event.country));
    }
    if (event is PhoneNumberChangedEvent) {
      emit(state.copyWith(phoneNumber: event.phoneNumber));
    }
    if (event is SubmitChangedEvent) {
      emit(state.copyWith(status: FormSubmissionStatus.submitting));
      try {
        final token = await authRepository.register(
          country: state.country!.name,
          email: state.email,
          phoneNumber: state.phoneNumber,
          username: state.username,
        );
        if (token != null) {
          authenticationBloc.add(Authenticated(
            username: state.username,
            token: token,
          ));
          emit(state.copyWith(
              status: FormSubmissionStatus.success, error: null));
        }
      } on Exception catch (error) {
        emit(
            state.copyWith(status: FormSubmissionStatus.failure, error: error));
      }
    }
  }

  //injecting blocs to RegisterBloc for emitting events after registering
  final AuthRepository authRepository;
  final CountriesBloc countriesBloc;
  final AuthenticationBloc authenticationBloc;
  RegisterBloc(
      {required this.authRepository,
      required this.countriesBloc,
      required this.authenticationBloc})
      : super(RegisterState()) {
    on<RegisterEvent>(_onEvent);

    //listining to countriesBloc changes in order to set default country
    //once the list of countries is fetched
    countriesBloc.stream.listen((countryState) {
      if (countryState.userCountry != null) {
        add(CountryChangedEvent(country: countryState.userCountry!));
      }
    });
  }
}
