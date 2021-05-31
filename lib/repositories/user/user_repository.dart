import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';

import 'package:crianza_mutua/config/paths.dart';
import 'package:crianza_mutua/models/user_model.dart';
import 'package:crianza_mutua/repositories/repositories.dart';

class UserRepository extends BaseUserRepository {
  final FirebaseFirestore _firebaseFirestore;

  UserRepository({FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Future<User> getUserWithId({@required String userId}) async {
    final doc =
        await _firebaseFirestore.collection(Paths.users).doc(userId).get();
    return doc.exists ? User.fromDocument(doc) : User.empty;
  }

  @override
  Future<void> updateUser({@required User user}) async {
    await _firebaseFirestore
        .collection(Paths.users)
        .doc(user.id)
        .update(user.toDocument());
  }

  // Isn´t use yet because if the userId is deleted I need to delete the post and messages too
  @override
  Future<void> deleteUser({@required String userId}) async {
    await _firebaseFirestore.collection(Paths.users).doc(userId).delete();
  }
}
