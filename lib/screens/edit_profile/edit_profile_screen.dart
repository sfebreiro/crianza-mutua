import 'package:crianza_mutua/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:crianza_mutua/blocs/auth/auth_bloc.dart';
import 'package:crianza_mutua/config/constants.dart';
import 'package:crianza_mutua/helpers/helpers.dart';
import 'package:crianza_mutua/models/models.dart';
import 'package:crianza_mutua/repositories/repositories.dart';
import 'package:crianza_mutua/screens/edit_profile/cubit/edit_profile_cubit.dart';
import 'package:crianza_mutua/widgets/user_profile_image.dart';
import 'package:crianza_mutua/screens/profile/bloc/profile_bloc.dart';
import 'package:crianza_mutua/widgets/widgets.dart';

class EditProfileScreenArgs {
  final BuildContext context;

  const EditProfileScreenArgs({@required this.context});
}

class EditProfileScreen extends StatelessWidget {
  static const String routeName = '/editProfile';

  static Route route({@required EditProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<EditProfileCubit>(
        create: (_) => EditProfileCubit(
          userRepository: context.read<UserRepository>(),
          storageRepository: context.read<StorageRepository>(),
          authRepository: context.read<AuthRepository>(),
          profileBloc: args.context.read<ProfileBloc>(),
        ),
        child: EditProfileScreen(
            user: args.context.read<ProfileBloc>().state.user),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final User user;

  EditProfileScreen({
    Key key,
    @required this.user,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.grey[50],
          elevation: 0,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              color: kIconColor,
              onPressed: () => context.read<AuthBloc>().add(
                    AuthLogoutRequested(),
                  ),
            )
          ],
        ),
        body: BlocConsumer<EditProfileCubit, EditProfileState>(
          listener: (context, state) {
            if (state.status == EditProfileStatus.success) {
              Navigator.of(context).pop();
            } else if (state.status == EditProfileStatus.error) {
              showDialog(
                context: context,
                builder: (context) =>
                    ErrorDialog(content: state.failure.message),
              );
            } else if (state.status == EditProfileStatus.deleting) {
              return CircularProgressIndicator();
            }
          },
          builder: (context, state) {
            return Container(
              child: SingleChildScrollView(
                child: Center(
                  child: Column(
                    children: [
                      if (state.status == EditProfileStatus.submitting)
                        const LinearProgressIndicator(),
                      Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: kDefaultPadding * 2,
                          vertical: kDefaultPadding,
                        ),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () => _selectProfileImage(context),
                              child: UserProfileImage(
                                radius: 50.0,
                                profileImageUrl: user.profileImageUrl,
                                profileImage: state.profileImage,
                              ),
                            ),
                            SizedBox(height: kDefaultPadding * 2),
                            Text(
                              user.email,
                              style: TextStyle(
                                fontFamily: 'Poirot One',
                                fontSize: 16.0,
                              ),
                            ),
                            SizedBox(height: kDefaultPadding * 2),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                //vertical: kDefaultPadding,
                                horizontal: kDefaultPadding,
                              ),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    TextFormField(
                                      style: TextStyle(fontSize: 14.0),
                                      initialValue: user.username,
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        hintText: 'Nombre de usuario',
                                      ),
                                      onChanged: (value) => context
                                          .read<EditProfileCubit>()
                                          .usernameChanged(value),
                                      validator: (value) =>
                                          value.trim().length > 11
                                              ? 'Máximo 11 caracteres'
                                              : null,
                                    ),
                                    SizedBox(height: kDefaultPadding),
                                    TextFormField(
                                      style: TextStyle(fontSize: 14.0),
                                      initialValue: user.bio,
                                      decoration: InputDecoration(
                                        hintText: 'Escribe algo sobre ti',
                                      ),
                                      onChanged: (value) => context
                                          .read<EditProfileCubit>()
                                          .bioChanged(value),
                                      validator: (value) =>
                                          value.trim().length > 100
                                              ? 'Máximo 100 caracteres'
                                              : null,
                                    ),
                                    SizedBox(height: kDefaultPadding * 3),
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
                                  'Actualizar',
                                  style: TextStyle(
                                    fontFamily: 'Poirot One',
                                    fontSize: 16.0,
                                    color: Colors.grey[100],
                                  ),
                                ),
                              ),
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              onPressed: () {
                                _submitForm(
                                  context,
                                  state.status == EditProfileStatus.submitting,
                                );
                              },
                            ),
                            SizedBox(height: kDefaultPadding * 4),
                            TextButton(
                              child: Text(
                                'Condiciones de uso y Política de Privacidad',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: 'Poirot One',
                                  fontSize: 10.0,
                                  color: Colors.black38,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context)
                                    .pushNamed(ConditionsScreen.routeName);
                              },
                            ),
                            TextButton(
                              child: Text(
                                'Eliminar cuenta',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 10.0,
                                  color: Colors.black38,
                                ),
                              ),
                              onPressed: () {
                                context.read<EditProfileCubit>().deleteUser();

                                //  context
                                //      .read<EditProfileCubit>()
                                //      .deleteUserData();

                                Navigator.of(context).pushNamed(
                                  LoginScreen.routeName,
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _selectProfileImage(BuildContext context) async {
    final pickedFile = await ImageHelper.pickImageFromGallery(
      context: context,
      cropStyle: CropStyle.circle,
      title: 'Imagen de perfil',
    );
    if (pickedFile != null) {
      context.read<EditProfileCubit>().profileImageChanged(pickedFile);
    }
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<EditProfileCubit>().submit();
    }
  }
}
