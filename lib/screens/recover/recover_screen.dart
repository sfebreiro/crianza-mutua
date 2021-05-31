import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crianza_mutua/config/constants.dart';
import 'package:crianza_mutua/repositories/repositories.dart';
import 'package:crianza_mutua/screens/recover/cubit/recover_cubit.dart';
import 'package:crianza_mutua/widgets/widgets.dart';

class RecoverScreen extends StatelessWidget {
  static const String routeName = '/recover';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<RecoverCubit>(
        create: (_) =>
            RecoverCubit(authRepository: context.read<AuthRepository>()),
        child: RecoverScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocConsumer<RecoverCubit, RecoverState>(
        listener: (context, state) {
          if (state.status == RecoverStatus.error) {
            showDialog(
              context: context,
              builder: (context) => ErrorDialog(content: state.failure.message),
            );
          } else if (state.status == RecoverStatus.success) {
            showDialog(
              context: context,
              builder: (context) => CommonDialog(
                title: 'Enlace enviado',
                content: 'Por favor, revisa tu correo electrónico',
              ),
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
                                  .read<RecoverCubit>()
                                  .emailChanged(value),
                              validator: (value) => !value.contains('@')
                                  ? 'Introduce un email válido'
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
                          'Recuperar',
                          style: TextStyle(
                            fontFamily: 'Poirot One',
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
                          state.status == RecoverStatus.submitting,
                        );
                        print(state.email);
                      },
                    ),
                    TextButton(
                      child: Text(
                        'Volver al login',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Poirot One',
                          fontSize: 14.0,
                          color: kPrimaryColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<RecoverCubit>().sendPasswordResetEmail();
    }
  }
}
