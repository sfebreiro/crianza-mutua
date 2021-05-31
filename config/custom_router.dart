import 'package:flutter/material.dart';

import 'package:crianza_mutua/screens/screens.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          settings: const RouteSettings(name: '/'),
          builder: (_) => const Scaffold(),
        );

      case SplashScreen.routeName:
        return SplashScreen.route();

      case LoginScreen.routeName:
        return LoginScreen.route();

      case SignupScreen.routeName:
        return SignupScreen.route();

      case RecoverScreen.routeName:
        return RecoverScreen.route();

      case NavScreen.routeName:
        return NavScreen.route();

      case ConditionsScreen.routeName:
        return ConditionsScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route onGenerateNestedRoute(RouteSettings settings) {
    print('Nested Route: ${settings.name}');
    switch (settings.name) {
      case ProfileScreen.routeName:
        return ProfileScreen.route(args: settings.arguments);

      case EditProfileScreen.routeName:
        return EditProfileScreen.route(args: settings.arguments);

      case CommentsScreen.routeName:
        return CommentsScreen.route(args: settings.arguments);

      case FeedScreen.routeName:
        return FeedScreen.route(args: settings.arguments);

      case CreatePostScreen.routeName:
        return CreatePostScreen.route();

      case ConditionsScreen.routeName:
        return ConditionsScreen.route();

      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
