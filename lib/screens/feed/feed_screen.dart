import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:crianza_mutua/config/constants.dart';
import 'package:crianza_mutua/blocs/auth/auth_bloc.dart';
import 'package:crianza_mutua/repositories/post/post_repository.dart';
import 'package:crianza_mutua/repositories/user/user_repository.dart';
import 'package:crianza_mutua/screens/feed/bloc/feed_bloc.dart';
import 'package:crianza_mutua/widgets/widgets.dart';
import 'package:crianza_mutua/extensions/extensions.dart';

class FeedScreenArgs {
  final String user;

  FeedScreenArgs({@required this.user});
}

class FeedScreen extends StatefulWidget {
  static const String routeName = '/feed';

  static Route route({@required FeedScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<FeedBloc>(
        create: (_) => FeedBloc(
          postRepository: context.read<PostRepository>(),
          userRepository: context.read<UserRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(
            FeedFecthPosts(
                //   user: args.user,
                ),
          ),
        child: FeedScreen(),
      ),
    );
  }

  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FeedBloc, FeedState>(
      listener: (context, state) {
        if (state.status == FeedStatus.error) {
          showDialog(
              context: context,
              builder: (context) =>
                  ErrorDialog(content: state.failure.message));
        } //else if (state.status == FeedStatus.paginating) {
        //ScaffoldMessenger.of(context).showSnackBar(
        //  SnackBar(
        //    backgroundColor: Colors.orange[300],
        //    duration: Duration(seconds: 1),
        //    content: Text('Cargando más posts'),
        //  ),
        //);
        //}
      },
      builder: (context, state) {
        return Container(
          color: Colors.white,
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.grey[50],
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: Text('Noticias compartidas'),
                actions: [
                  if (state.status == FeedStatus.loaded)
                    IconButton(
                      icon: Icon(Icons.refresh),
                      onPressed: () async {
                        context.read<FeedBloc>().add(
                              FeedFecthPosts(
                                  //user: context.read<AuthBloc>().state.user.uid
                                  ),
                            );
                        return true;
                      },
                    ),
                ],
              ),
              body: _buildBody(state),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(FeedState state) {
    switch (state.status) {
      case FeedStatus.loading:
        return const Center(child: CircularProgressIndicator());

      default:
        return RefreshIndicator(
          onRefresh: () async {
            context.read<FeedBloc>().add(
                  FeedFecthPosts(
                      //user: context.read<AuthBloc>().state.user.uid
                      ),
                );
            return true;
          },
          child: Container(
            margin: EdgeInsets.only(top: kDefaultPadding / 2.5),
            child: ListView.builder(
              itemCount: state.post.length,
              itemBuilder: (BuildContext context, int index) {
                final post = state.post[index];
                // bool isMe = post.author.id == state.user.id;
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
                    padding: const EdgeInsets.only(
                      //top: kDefaultPadding / 6,
                      //bottom: kDefaultPadding / 6,
                      left: kDefaultPadding / 2,
                      right: kDefaultPadding / 2,
                    ),
                    child: Card(
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
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              post.title,
                              style: const TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
                            Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: '~' + post.author.username + '    ',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color: Colors.black54,
                                    ),
                                  ),
                                  TextSpan(
                                    text: post.date.timeAgo(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12.0,
                                      color: Colors.black45,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
    }
  }
}
