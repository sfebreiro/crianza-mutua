import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:crianza_mutua/config/paths.dart';
import 'package:crianza_mutua/models/models.dart';

class Comment extends Equatable {
  final String commentId;
  final User author;
  final String content;
  final DateTime date;

  Comment({
    this.commentId,
    @required this.author,
    @required this.content,
    @required this.date,
  });

  @override
  List<Object> get props => [
        commentId,
        author,
        content,
        date,
      ];

  Comment copyWith({
    String id,
    User author,
    String content,
    DateTime date,
  }) {
    return Comment(
      commentId: id ?? this.commentId,
      author: author ?? this.author,
      content: content ?? this.content,
      date: date ?? this.date,
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'author':
          FirebaseFirestore.instance.collection(Paths.users).doc(author.id),
      'content': content,
      'date': Timestamp.fromDate(date),
    };
  }

  static Future<Comment> fromDocument(DocumentSnapshot doc) async {
    if (doc == null) return null;
    final data = doc.data();
    final authorRef = data['author']; //as DocumentReference;
    if (authorRef != null) {
      final authorDoc = await authorRef.get();
      if (authorDoc.exists) {
        return Comment(
          commentId: doc.id,
          author: User.fromDocument(authorDoc),
          content: data['content'] ?? '',
          date: (data['date'] as Timestamp)?.toDate(),
        );
      }
    }
    return null;
  }
}
