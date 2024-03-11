import 'package:github_client/modules/auth/data/models/identity.dart';

abstract class AuthRepository {
  Future<Identity?> signIn();
}
