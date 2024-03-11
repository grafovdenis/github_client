import 'package:github_client/modules/auth/data/auth_repository.dart';
import 'package:github_client/modules/core/data/auth_token_repository.dart';

class AuthUseCase {
  final AuthRepository _repository;
  final AuthTokenRepository _tokenRepository;

  const AuthUseCase(
    this._repository,
    this._tokenRepository,
  );

  Future<void> signIn() async {
    final result = await _repository.signIn();

    if (result != null) {
      _tokenRepository.setToken(result.token);
    }
  }
}
