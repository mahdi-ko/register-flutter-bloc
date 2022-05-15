import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register/bloc/auth/auth_bloc.dart';
import 'package:register/bloc/auth/auth_events.dart';

class Logout extends StatelessWidget {
  const Logout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ' +
            (context.read<AuthenticationBloc>().state.username ?? "")),
      ),
      body: Center(
        child: TextButton(
          child: const Text('Logout'),
          onPressed: () {
            context.read<AuthenticationBloc>().add(LogoutEvent());
          },
        ),
      ),
    );
  }
}
