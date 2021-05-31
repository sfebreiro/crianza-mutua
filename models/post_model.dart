import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:crianza_mutua/config/paths.dart';
import 'package:crianza_mutua/models/models.dart';

class Post extends Equatable {
  final String id;
  final User author;
  final String title;
  final String imageUrl;
  final String caption;
  final String link;
  final DateTime date;

  Post({
    this.id,
    @required this.author,
    @required this.title,
    this.imageUrl,
    @required this.caption,
    @required this.link,
    @required this.date,
  });

  @override
  List<Object> get props => [
        id,
        author,
        title,
        imageUrl,
        caption,
        link,
        date,
      ];

  Post copyWith({
    String id,
    User author,
    String title,
    String imageUrl,
    String caption,
    String link,
    DateTime date,
  }) {
    return Post(
      id: id ?? this.id,
      author: author ?? this.author,
      title: title ?? this.title,
      imageUrl: imageUrl ?? this.imageUrl,
      caption: caption ?? this.caption,
      link: link ?? this.link,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'title': title,
      'imageUrl': imageUrl,
      'caption': caption,
      'link': link,
      'date': Timestamp.fromDate(date),
    };
  }

  static Future<Post> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data();
    final authorRef = data['author']; //as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Post(
          id: doc.id,
          author: User.fromDocument(authorDoc),
          title: data['title'] ?? '',
          imageUrl: data['imageUrl'] ?? '',
          caption: data['caption'] ?? '',
          link: data['link'] ?? '',
          date: (data['date'] as Timestamp)?.toDate(),
        );
      }
    }
    return null;
  }
}
