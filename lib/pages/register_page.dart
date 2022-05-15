import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:register/bloc/countries/countries_bloc.dart';
import 'package:register/bloc/countries/countries_events.dart';
import 'package:register/bloc/countries/countries_state.dart';
import 'package:register/bloc/register/register_bloc.dart';
import 'package:register/bloc/register/register_events.dart';
import 'package:register/bloc/register/register_state.dart';
import 'package:register/helpers/form_submission_status.dart';
import 'package:register/helpers/global_constants.dart';

import 'package:flutter/services.dart';
import 'package:register/helpers/validators.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: _RegisterForm(formKey: _formKey),
      floatingActionButton: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) => Visibility(
          //hide button when keyboard is open
          //or the form is submitting
          visible: MediaQuery.of(context).viewInsets.bottom == 0 &&
              state.status != FormSubmissionStatus.submitting,
          child: ElevatedButton(
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                context.read<RegisterBloc>().add(SubmitChangedEvent());
              }
            },
            child: const Text("Sign up"),
          ),
        ),
      ),
    );
  }
}

class _RegisterForm extends StatefulWidget {
  const _RegisterForm({required this.formKey, Key? key}) : super(key: key);
  final GlobalKey<FormState> formKey;
  @override
  State<_RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<_RegisterForm> {
  //for correcting focus from email's input to phone's input
  final FocusNode focusNode = FocusNode();

  @override
  void initState() {
    //initialising countries
    //this could be done from higher up the tree if needed in multiple pages/widgets
    context.read<CountriesBloc>().add((InitCountriesEvent()));
    super.initState();
  }

  @override
  void dispose() {
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          return FormWrapper(
            state: state,
            children: [
              TextFormField(
                initialValue: state.username,
                decoration: _customInputDecoration("name"),
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                validator: (String? val) => usernameValidator(username: val),
                onChanged: (String? val) {
                  context
                      .read<RegisterBloc>()
                      .add(NameChangedEvent(username: val ?? ''));
                },
              ),
              TextFormField(
                initialValue: state.email,
                textInputAction: TextInputAction.next,
                onEditingComplete: () {
                  focusNode.requestFocus();
                },
                keyboardType: TextInputType.emailAddress,
                decoration: _customInputDecoration("Email"),
                validator: (String? val) => emailValidator(email: val),
                onChanged: (String? val) => context
                    .read<RegisterBloc>()
                    .add(EmailChangedEvent(email: val ?? '')),
              ),
              _CountriesDropDown(initialValue: state.country?.code),
              TextFormField(
                textInputAction: TextInputAction.next,
                focusNode: focusNode,
                initialValue: state.phoneNumber,
                decoration: _customInputDecoration("Phone Number"),
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (val) => phoneNumberValidator(
                    phoneNumber: val, country: state.country),
                onChanged: (String? val) => context
                    .read<RegisterBloc>()
                    .add(PhoneNumberChangedEvent(phoneNumber: val ?? "")),
              ),
              TextFormField(
                initialValue: state.password,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                decoration: _customInputDecoration("Password"),
                validator: (String? val) => passwordValidator(password: val),
                onChanged: (String? val) => context
                    .read<RegisterBloc>()
                    .add(PasswordChangedEvent(password: val ?? '')),
              ),
              TextFormField(
                obscureText: true,
                initialValue: state.confirmPassword,
                keyboardType: TextInputType.visiblePassword,
                decoration: _customInputDecoration("Confirm Password"),
                validator: (String? val) => confirmPasswordValidator(
                    password: state.password, confirmPassword: val),
                onChanged: (String? val) => context.read<RegisterBloc>().add(
                    ConfirmPasswordChangedEvent(confirmPassword: val ?? '')),
              ),
            ],
          );
        },
      ),
    );
  }

//extracted for better readability
  InputDecoration _customInputDecoration(String labelText) {
    return InputDecoration(
        labelText: labelText,
        isCollapsed: true,
        contentPadding: AppConstants.inputPadding,
        border:
            const OutlineInputBorder(borderRadius: AppConstants.inputBorder));
  }
}

//extracted for better readability
class _CountriesDropDown extends StatelessWidget {
  final String? initialValue;

  const _CountriesDropDown({Key? key, required this.initialValue})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 51.5),
        padding: AppConstants.inputPadding.copyWith(bottom: 2, top: 2),
        decoration: BoxDecoration(
          borderRadius: AppConstants.inputBorder,
          border: Border.all(
              color: const Color.fromARGB(185, 148, 147, 147), width: 0.5),
        ),
        child: BlocBuilder<CountriesBloc, CountriesState>(
            builder: (context, countriesState) {
          return DropdownButton<String>(
            itemHeight: 62,
            value: initialValue,
            hint: const Text("Countries"),
            isExpanded: true,
            icon: const Icon(Icons.arrow_circle_down),
            iconSize: 20,
            elevation: 16,
            underline: Container(),
            onChanged: (String? val) => context.read<RegisterBloc>().add(
                  CountryChangedEvent(
                    country: countriesState.countries
                        .firstWhere((element) => val == element.code),
                  ),
                ),
            items: countriesState.countries
                .map(
                  (country) => DropdownMenuItem(
                    child: Text(country.name),
                    value: country.code,
                  ),
                )
                .toList(),
          );
        }),
      ),
    );
  }
}

//renders different layout based on oreintation and screen width
class FormWrapper extends StatelessWidget {
  final List<Widget> children;
  final RegisterState state;
  const FormWrapper({required this.children, required this.state, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final width = MediaQuery.of(context).size.width;
    if (state.status == FormSubmissionStatus.submitting) {
      return const Center(child: CircularProgressIndicator());
    }
    return orientation == Orientation.portrait || width < 450
        ? ListView(
            padding: const EdgeInsets.all(16.0),
            children: children
                .map((e) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: e,
                    ))
                .toList())
        : GridView(
            padding: const EdgeInsets.all(16.0),
            children: children,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 4.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10),
          );
  }
}
