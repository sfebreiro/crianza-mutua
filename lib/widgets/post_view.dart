import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:crianza_mutua/config/constants.dart';
import 'package:crianza_mutua/extensions/extensions.dart';
import 'package:crianza_mutua/models/models.dart';

class PostView extends StatelessWidget {
  final Post post;

  const PostView({
    Key key,
    @required this.post,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: kDefaultPadding / 4,
        horizontal: kDefaultPadding,
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
            left: kDefaultPadding / 2,
            right: kDefaultPadding / 2,
          ),
          child: ExpansionTile(
            expandedAlignment: Alignment.centerLeft,
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  post.title,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: kDefaultPadding / 2),
                Text(
                  post.caption,
                  style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: kDefaultPadding / 2),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: post.author.username + '  ',
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          color: Colors.black54,
                        ),
                      ),
                      TextSpan(
                        text: post.date.timeAgo(),
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          fontSize: 14.0,
                          color: Colors.black45,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            children: [
              TextButton(
                  child: Text(
                    post.link,
                    style: TextStyle(
                        fontStyle: FontStyle.italic, color: kTextColor),
                  ),
                  onPressed: () async {
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
                          duration: const Duration(seconds: 1),
                          content: Text('No se ha podido acceder a este link'),
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
