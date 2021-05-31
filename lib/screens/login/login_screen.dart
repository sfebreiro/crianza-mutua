import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/cupertino.dart';

import 'package:crianza_mutua/config/constants.dart';
import 'package:crianza_mutua/repositories/repositories.dart';
import 'package:crianza_mutua/screens/login/cubit/login_cubit.dart';
import 'package:crianza_mutua/screens/screens.dart';
import 'package:crianza_mutua/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
        create: (_) =>
            LoginCubit(authRepository: context.read<AuthRepository>()),
        child: LoginScreen(),
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
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
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
              backgroundColor: Colors.grey[50],
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
                              vertical: kDefaultPadding,
                              horizontal: kDefaultPadding * 3),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                style: TextStyle(fontSize: 14.0),
                                decoration: InputDecoration(hintText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                                onChanged: (value) => context
                                    .read<LoginCubit>()
                                    .emailChanged(value),
                                validator: (value) => !value.contains('@')
                                    ? 'Introduce un email válido'
                                    : null,
                              ),
                              SizedBox(height: kDefaultPadding),
                              TextFormField(
                                obscureText: true,
                                style: TextStyle(fontSize: 14.0),
                                decoration:
                                    InputDecoration(hintText: 'Contraseña'),
                                onChanged: (value) => context
                                    .read<LoginCubit>()
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
                            'Entrar',
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
                            state.status == LoginStatus.submitting,
                          );
                        },
                      ),
                      Column(
                        children: [
                          TextButton(
                            child: Text(
                              'Recuperar contraseña',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: kPrimaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(RecoverScreen.routeName);
                            },
                          ),
                          TextButton(
                            child: Text(
                              '¿No tienes cuenta? Crea una ahora',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14.0,
                                color: kPrimaryColor,
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context)
                                  .pushNamed(SignupScreen.routeName);
                            },
                          ),
                        ],
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
      context.read<LoginCubit>().logInWithCredentials();
    }
  }
}
