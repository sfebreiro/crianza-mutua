import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crianza_mutua/blocs/blocs.dart';
import 'package:crianza_mutua/blocs/simple_bloc_observer.dart';
import 'package:crianza_mutua/config/constants.dart';
import 'package:crianza_mutua/config/custom_router.dart';
import 'package:crianza_mutua/repositories/repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = kDebugMode;
  Bloc.observer = SimpleBlocObserver();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<UserRepository>(
          create: (_) => UserRepository(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (_) => StorageRepository(),
        ),
        RepositoryProvider<CommentRepository>(
          create: (_) => CommentRepository(),
        ),
        RepositoryProvider<PostRepository>(
          create: (_) => PostRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primaryColor: kPrimaryColor,
            primarySwatch: kPrimarySwatch,
            scaffoldBackgroundColor: Colors.grey[50],
            accentColor: kPrimaryColor,
            appBarTheme: AppBarTheme(
              iconTheme: IconThemeData(color: kIconColor),
            ),
          ),
          title: 'Crianza Mutua',
          onGenerateRoute: CustomRouter.onGenerateRoute,
          initialRoute: '/splash',
        ),
      ),
    );
  }
}
