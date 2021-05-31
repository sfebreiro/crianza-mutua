import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:crianza_mutua/repositories/post/post_repository.dart';
import 'package:crianza_mutua/blocs/blocs.dart';
import 'package:crianza_mutua/config/constants.dart';
import 'package:crianza_mutua/repositories/user/user_repository.dart';
import 'package:crianza_mutua/screens/nav/widgets/widgets.dart';
import 'package:crianza_mutua/screens/profile/bloc/profile_bloc.dart';
import 'package:crianza_mutua/screens/screens.dart';
import 'package:crianza_mutua/widgets/widgets.dart';

class ProfileScreenArgs {
  final String userId;

  ProfileScreenArgs({@required this.userId});
}

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';

  static Route route({@required ProfileScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<ProfileBloc>(
        create: (_) => ProfileBloc(
          userRepository: context.read<UserRepository>(),
          postRepository: context.read<PostRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(
            ProfileLoadUser(
              userId: args.userId,
            ),
          ),
        child: ProfileScreen(),
      ),
    );
  }

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.grey[50],
          appBar: AppBar(
            backgroundColor: Colors.grey[50],
            elevation: 0,
            actions: [
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: () async {
                  context.read<ProfileBloc>().add(ProfileLoadUser(
                      userId: context.read<AuthBloc>().state.user.uid));
                  return true;
                },
              ),
              SizedBox(width: kDefaultPadding / 2),
              if (state.isCurrentUser)
                IconButton(
                  icon: const Icon(
                    Icons.settings_outlined,
                    size: 28,
                  ),
                  iconSize: 30.0,
                  color: kPrimarySwatch,
                  onPressed: () => Navigator.of(context).pushNamed(
                    EditProfileScreen.routeName,
                    arguments: EditProfileScreenArgs(context: context),
                  ),
                ),
            ],
          ),
          body: _buildBody(state),
        );
      },
    );
  }

  Widget _buildBody(ProfileState state) {
    switch (state.status) {
      case ProfileStatus.loading:
        return const Center(child: CircularProgressIndicator());

      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<ProfileBloc>().add(
                  ProfileLoadUser(
                      userId: context.read<AuthBloc>().state.user.uid),
                );
            return true;
          },
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    UserProfileImage(
                      radius: 50.0,
                      profileImageUrl: state.user.profileImageUrl,
                    ),
                    SizedBox(height: kDefaultPadding),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '~',
                          style: TextStyle(
                            fontFamily: 'Poirot One',
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            color: kPrimarySwatch,
                          ),
                        ),
                        Text(
                          state.user.username,
                          style: TextStyle(
                            fontFamily: 'Poirot One',
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: kDefaultPadding),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
                      child: Text(
                        state.user.bio,
                        style: TextStyle(
                          fontFamily: 'Poirot One',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                  ],
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final post = state.posts[index];
                    final isMe = post.author.id == state.user.id;
                    return GestureDetector(
                      onTap: () async {
                        if (await canLaunch(post.link)) {
                          await launch(
                            post.link,
                            forceSafariVC: false,
                            forceWebView: false,
                            headers: <String, String>{
                              'my_header_key': 'my_header_value'
                            },
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Colors.orange[300],
                              duration: const Duration(seconds: 2),
                              content: Text(
                                  'No se ha podido acceder a este link. Lo revisaremos.'),
                            ),
                          );
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
//                          vertical: kDefaultPadding / 6,
                          horizontal: kDefaultPadding / 2,
                        ),
                        child: isMe
                            ? Card(
                                color: Colors.orange[200],
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 1.0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                    top: kDefaultPadding / 2,
                                    left: kDefaultPadding,
                                    right: kDefaultPadding,
                                    bottom: kDefaultPadding / 2,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            post.title,
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          if (state.isCurrentUser)
                                            IconButton(
                                              icon: Icon(Icons.dangerous),
                                              color: kIconColor,
                                              onPressed: () {
                                                context.read<ProfileBloc>().add(
                                                    ProfileDeletePost(
                                                        postId: post.id));
                                                context.read<ProfileBloc>().add(
                                                      ProfileLoadUser(
                                                          userId: context
                                                              .read<AuthBloc>()
                                                              .state
                                                              .user
                                                              .uid),
                                                    );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    backgroundColor:
                                                        Colors.orange[300],
                                                    duration: const Duration(
                                                        seconds: 1),
                                                    content:
                                                        Text('Post eliminado'),
                                                  ),
                                                );
                                              },
                                            ),
                                        ],
                                      ),
                                      if (!state.isCurrentUser)
                                        SizedBox(height: kDefaultPadding / 2),
                                      Text(
                                        post.link,
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          fontStyle: FontStyle.italic,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      SizedBox(height: kDefaultPadding / 2),
                                    ],
                                  ),
                                ),
                              )
                            : null,
                      ),
                    );
                  },
                  childCount: state.posts.length,
                ),
              ),
            ],
          ),
        );
    }
  }
}
