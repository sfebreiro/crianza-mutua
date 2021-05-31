import 'package:crianza_mutua/models/models.dart';

abstract class BaseUserRepository {
  Future<User> getUserWithId({String userId});
  Future<void> updateUser({User user});
  Future<void> deleteUser({String userId});
}
