import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crianza_mutua/screens/screens.dart';
import 'package:crianza_mutua/config/constants.dart';
import 'package:crianza_mutua/repositories/repositories.dart';
import 'package:crianza_mutua/screens/signup/cubit/signup_cubit.dart';
import 'package:crianza_mutua/widgets/widgets.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (_) =>
            SignupCubit(authRepository: context.read<AuthRepository>()),
        child: SignupScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: SafeArea(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: kDefaultPadding),
                      Icon(
                        Icons.child_friendly_outlined,
                        color: kLogoColor,
                        size: 80.0,
                      ),
                      Text(
                        'Crianza Mutua',
                        style: TextStyle(
                          fontSize: 32.0,
                          fontFamily: 'Poiret One',
                          fontWeight: FontWeight.bold,
                          color: kLogoColor,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      Form(
                        key: _formKey,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kDefaultPadding * 3),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                style: TextStyle(fontSize: 14.0),
                                decoration: InputDecoration(
                                    hintText: 'Nombre de usuario'),
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .usernameChanged(value),
                                validator: (value) => value.trim().length > 11
                                    ? 'Máximo 11 caracteres'
                                    : null,
                              ),
                              SizedBox(height: kDefaultPadding),
                              TextFormField(
                                style: TextStyle(fontSize: 14.0),
                                decoration: InputDecoration(hintText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .emailChanged(value),
                                validator: (value) => !value.contains('@')
                                    ? 'Introduce un email válido'
                                    : null,
                              ),
                              SizedBox(height: kDefaultPadding),
                              TextFormField(
                                style: TextStyle(fontSize: 14.0),
                                obscureText: true,
                                decoration:
                                    InputDecoration(hintText: 'Contraseña'),
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .passwordChanged(value),
                                validator: (value) => value.trim().length < 6
                                    ? 'La contraseña debe tener al menos 6 caracteres'
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ),
                      ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: kDefaultPadding,
                            vertical: kDefaultPadding / 4,
                          ),
                          child: Text(
                            'Crear cuenta',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Colors.grey[100],
                            ),
                          ),
                        ),
                        style: ButtonStyle(
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          _submitForm(
                            context,
                            state.status == SignupStatus.submitting,
                          );
                        },
                      ),
                      TextButton(
                        child: Text(
                          '¿Ya tienes cuenta? Entra ahora',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poirot One',
                            fontSize: 14.0,
                            color: kPrimaryColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      SizedBox(height: kDefaultPadding),
                    ],
                  ),
                ),
              ),
              bottomSheet: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: TextButton(
                  child: Text(
                    'Al usar los servicios de Crianza Mutua App estás aceptando nuestras Condiciones de uso y Política de Privacidad',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poirot One',
                      fontSize: 10.0,
                      color: Colors.black38,
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pushNamed(ConditionsScreen.routeName);
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }
}
