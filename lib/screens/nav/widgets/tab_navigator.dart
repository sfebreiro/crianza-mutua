import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:crianza_mutua/blocs/auth/auth_bloc.dart';
import 'package:crianza_mutua/config/custom_router.dart';
import 'package:crianza_mutua/enums/enums.dart';
import 'package:crianza_mutua/repositories/chat/comment_repository.dart';
import 'package:crianza_mutua/repositories/repositories.dart';
import 'package:crianza_mutua/repositories/user/user_repository.dart';
import 'package:crianza_mutua/screens/comments/bloc/comments_bloc.dart';
import 'package:crianza_mutua/screens/create_post/cubit/create_post_cubit.dart';
import 'package:crianza_mutua/screens/feed/bloc/feed_bloc.dart';
import 'package:crianza_mutua/screens/profile/bloc/profile_bloc.dart';
import 'package:crianza_mutua/screens/screens.dart';

class TabNavigator extends StatelessWidget {
  static const String tabNavigatorRoot = '/';

  final GlobalKey<NavigatorState> navigatorKey;
  final BottomNavItem item;

  const TabNavigator({
    Key key,
    @required this.navigatorKey,
    @required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final routeBuilders = _routeBuilders();

    return Navigator(
      key: navigatorKey,
      initialRoute: tabNavigatorRoot,
      onGenerateInitialRoutes: (_, initialRoute) {
        return [
          MaterialPageRoute(
            settings: RouteSettings(name: tabNavigatorRoot),
            builder: (context) => routeBuilders[initialRoute](context),
          ),
        ];
      },
      onGenerateRoute: CustomRouter.onGenerateNestedRoute,
    );
  }

  Map<String, WidgetBuilder> _routeBuilders() {
    return {tabNavigatorRoot: (context) => _getScreen(context, item)};
  }

  Widget _getScreen(BuildContext context, BottomNavItem item) {
    switch (item) {
      case BottomNavItem.feed:
        return BlocProvider<FeedBloc>(
          create: (context) => FeedBloc(
            postRepository: context.read<PostRepository>(),
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(
              FeedFecthPosts(
                  //user: context.read<AuthBloc>().state.user.uid
                  ),
            ),
          child: FeedScreen(),
        );

      case BottomNavItem.add:
        return BlocProvider<CreatePostCubit>(
          create: (context) => CreatePostCubit(
            postRepository: context.read<PostRepository>(),
            storageRepository: context.read<StorageRepository>(),
            authBloc: context.read<AuthBloc>(),
          ),
          child: CreatePostScreen(),
        );

      case BottomNavItem.chat:
        return BlocProvider<CommentsBloc>(
          create: (context) => CommentsBloc(
            commentRepository: context.read<CommentRepository>(),
            userRepository: context.read<UserRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(
              CommentsFetchComments(
                user: context.read<AuthBloc>().state.user.uid,
              ),
            ),
          child: CommentsScreen(),
        );
      case BottomNavItem.profile:
        return BlocProvider<ProfileBloc>(
          create: (_) => ProfileBloc(
            userRepository: context.read<UserRepository>(),
            postRepository: context.read<PostRepository>(),
            authBloc: context.read<AuthBloc>(),
          )..add(
              ProfileLoadUser(userId: context.read<AuthBloc>().state.user.uid),
            ),
          child: ProfileScreen(),
        );
      default:
        return Scaffold(
          body: Center(
            child: Text('Upss, algo ha salido mal'),
          ),
        );
    }
  }
}
