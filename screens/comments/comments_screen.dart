import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:bubble/bubble.dart';

import 'package:crianza_mutua/blocs/auth/auth_bloc.dart';
import 'package:crianza_mutua/config/constants.dart';
import 'package:crianza_mutua/repositories/chat/comment_repository.dart';
import 'package:crianza_mutua/repositories/user/user_repository.dart';
import 'package:crianza_mutua/screens/comments/bloc/comments_bloc.dart';
import 'package:crianza_mutua/widgets/user_profile_image.dart';
import 'package:crianza_mutua/screens/screens.dart';
import 'package:crianza_mutua/widgets/widgets.dart';

class CommentsScreenArgs {
  final String user;

  CommentsScreenArgs({@required this.user});
}

class CommentsScreen extends StatefulWidget {
  static const String routeName = '/comments';

  static Route route({@required CommentsScreenArgs args}) {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<CommentsBloc>(
        create: (_) => CommentsBloc(
          commentRepository: context.read<CommentRepository>(),
          userRepository: context.read<UserRepository>(),
          authBloc: context.read<AuthBloc>(),
        )..add(
            CommentsFetchComments(
              user: args.user,
            ),
          ),
        child: CommentsScreen(),
      ),
    );
  }

  @override
  _CommentsScreenState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends State<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CommentsBloc, CommentsState>(
      listener: (context, state) {
        if (state.status == CommentStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(
              content: state.failure.message,
            ),
          );
        }
      },
      builder: (context, state) {
        return Container(
          color: Colors.orange[50],
          child: SafeArea(
            child: Scaffold(
              backgroundColor: Colors.orange[50],
              body: ListView.builder(
                reverse: true,
                padding: EdgeInsets.only(bottom: kDefaultPadding * 3),
                itemCount: state.comments.length,
                itemBuilder: (BuildContext context, int index) {
                  final comment = state.comments[index];
                  bool isMe = comment.author.id == state.user.id;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 2.0,
                      horizontal: kDefaultPadding / 6,
                    ),
                    child: ListTile(
                      leading: isMe
                          ? null
                          : UserProfileImage(
                              radius: 10,
                              profileImageUrl: comment.author.profileImageUrl,
                            ),
                      title: Bubble(
                        color: isMe ? Colors.blue[100] : Colors.orange[200],
                        margin: isMe
                            ? BubbleEdges.only(top: 0, left: 50.0)
                            : BubbleEdges.only(top: 0, right: 50.0),
                        elevation: 2,
                        alignment:
                            isMe ? Alignment.topRight : Alignment.topLeft,
                        nip: isMe ? BubbleNip.rightTop : BubbleNip.leftTop,
                        child: Column(
                          crossAxisAlignment: isMe
                              ? CrossAxisAlignment.end
                              : CrossAxisAlignment.start,
                          children: [
                            Text(
                              '~' + comment.author.username,
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12.0,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 2.0),
                            Text(
                              comment.content,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                                fontFamily: 'Poirot one',
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                      onTap: () => Navigator.of(context).pushNamed(
                        ProfileScreen.routeName,
                        arguments: ProfileScreenArgs(userId: comment.author.id),
                      ),
                      onLongPress: () {
                        if (isMe) {
                          context.read<CommentsBloc>().add(
                                CommentsDeleteComment(
                                    commentId: comment.commentId),
                              );
                        }
                      },
                    ),
                  );
                },
              ),
              bottomSheet: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    //  if (state.status == CommentStatus.submitting)
                    //  const LinearProgressIndicator(),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            style: TextStyle(fontSize: 14.0),
                            controller: _commentController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration.collapsed(
                                hintText: 'Escribe un mensaje...'),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.send),
                          onPressed: () {
                            final content = _commentController.text.trim();
                            if (content.isNotEmpty) {
                              context.read<CommentsBloc>().add(
                                    CommentsPostComment(
                                      content: content,
                                    ),
                                  );
                              _commentController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
