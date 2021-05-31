import 'package:crianza_mutua/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crianza_mutua/config/constants.dart';
import 'package:crianza_mutua/screens/create_post/cubit/create_post_cubit.dart';
import 'package:crianza_mutua/widgets/widgets.dart';

class CreatePostScreen extends StatelessWidget {
  static const String routeName = '/createPost';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => CreatePostScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: Text(
                'Comparte una noticia',
                style: TextStyle(
                  color: kTextColor,
                ),
              ),
            ),
            body: BlocConsumer<CreatePostCubit, CreatePostState>(
              listener: (context, state) {
                if (state.status == CreatePostStatus.success) {
                  _formKey.currentState.reset();
                  context.read<CreatePostCubit>().reset();

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: Colors.orange[300],
                      duration: const Duration(seconds: 1),
                      content: Text('Post creado'),
                    ),
                  );
                } else if (state.status == CreatePostStatus.error) {
                  showDialog(
                    context: context,
                    builder: (context) =>
                        ErrorDialog(content: state.failure.message),
                  );
                }
              },
              builder: (context, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: kDefaultPadding,
                    horizontal: kDefaultPadding,
                  ),
                  child: Container(
                    alignment: Alignment.bottomCenter,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          //GestureDetector(
                          //  onTap: () => _selectPostImage(context),
                          //  child: Container(
                          //    height: MediaQuery.of(context).size.height / 2,
                          //    width: double.infinity,
                          //    color: Colors.grey[200],
                          //    child: state.postImage != null
                          //        ? Image.file(
                          //            state.postImage,
                          //            fit: BoxFit.cover,
                          //          )
                          //        : const Icon(
                          //            Icons.image,
                          //            color: Colors.grey,
                          //            size: 100.0,
                          //          ),
                          //  ),
                          //),
                          if (state.status == CreatePostStatus.submitting)
                            const CircularProgressIndicator(),
                          Padding(
                            padding: const EdgeInsets.all(kDefaultPadding * 2),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    style: TextStyle(fontSize: 14.0),
                                    decoration:
                                        InputDecoration(hintText: 'Título'),
                                    onChanged: (value) => context
                                        .read<CreatePostCubit>()
                                        .postTitleChanged(value),
                                    validator: (value) =>
                                        value.trim().length > 30 ||
                                                value.trim().isEmpty
                                            ? 'Máximo 30 caracteres'
                                            : null,
                                  ),
                                  SizedBox(height: kDefaultPadding * 2),
                                  // TextFormField(
                                  //   decoration: InputDecoration(
                                  //       hintText:
                                  //           'Di algo acerca de la noticia'),
                                  //   onChanged: (value) => context
                                  //      .read<CreatePostCubit>()
                                  //       .postCaptionChanged(value),
                                  //   validator: (value) => value.trim().isEmpty
                                  //       ? 'Escribe algo'
                                  //       : null,
                                  // ),
                                  // SizedBox(height: kDefaultPadding * 2),
                                  TextFormField(
                                      style: TextStyle(fontSize: 14.0),
                                      keyboardType: TextInputType.url,
                                      decoration: InputDecoration(
                                          hintText: 'Pega tu link'),
                                      onChanged: (value) => context
                                          .read<CreatePostCubit>()
                                          .postLinkChanged(value),
                                      validator: (value) {
                                        bool _validURL =
                                            Uri.parse(value).isAbsolute;

                                        if (!_validURL) {
                                          return 'Revisa tu URL - Empiezan por http:// o https://';
                                        } else {
                                          return null;
                                        }
                                      }),
                                  SizedBox(height: kDefaultPadding * 2),
                                  ElevatedButton(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: kDefaultPadding,
                                        vertical: kDefaultPadding / 4,
                                      ),
                                      child: Text(
                                        'Subir',
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
                                          borderRadius:
                                              BorderRadius.circular(18.0),
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _submitForm(
                                        context,
                                        //state.postImage,
                                        state.status ==
                                            CreatePostStatus.submitting,
                                      );
                                    },
                                  ),
                                ],
                              ),
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
        ),
      ),
    );
  }

  //void _selectPostImage(BuildContext context) async {
  //  final pickedFile = await ImageHelper.pickImageFromGallery(
  //    context: context,
  //    cropStyle: CropStyle.rectangle,
  //    title: 'Crear post',
  //  );
  //  if (pickedFile != null) {
  //    context.read<CreatePostCubit>().postImageChanged(pickedFile);
  //  }
  //}

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      context.read<CreatePostCubit>().submit();
      Navigator.of(context).pushNamed(FeedScreen.routeName);
    }
  }
}
