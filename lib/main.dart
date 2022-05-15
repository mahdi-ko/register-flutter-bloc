import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register/bloc/auth/auth_bloc.dart';
import 'package:register/bloc/auth/auth_repository.dart';
import 'package:register/bloc/auth/auth_state.dart';
import 'package:register/bloc/countries/countries_bloc.dart';
import 'package:register/bloc/register/register_bloc.dart';
import 'package:register/helpers/global_constants.dart';
import 'package:register/pages/logout_page.dart';
import 'package:register/pages/register_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (ctx) => AuthRepository(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider<CountriesBloc>(
            create: ((context) => CountriesBloc()),
          ),
          BlocProvider<AuthenticationBloc>(
            create: ((context) => AuthenticationBloc()),
          ),
          BlocProvider<RegisterBloc>(
            create: ((context) => RegisterBloc(
                  authRepository: context.read<AuthRepository>(),
                  countriesBloc: context.read<CountriesBloc>(),
                  authenticationBloc: context.read<AuthenticationBloc>(),
                )),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Register app',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
              primary: AppConstants.primaryColor,
            ),
          ),
          routes: {
            "/": (context) =>
                BlocBuilder<AuthenticationBloc, AuthenticationState>(
                    builder: (context, state) {
                  return state.authenticated ? const Logout() : RegisterPage();
                }),
          },
        ),
      ),
    );
  }
}
