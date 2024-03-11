import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:github_client/config.dart';
import 'package:github_client/github_client_app.dart';
import 'package:github_client/modules/auth/data/github_auth_repository.dart';
import 'package:github_client/modules/auth/domain/auth_use_case.dart';
import 'package:github_client/modules/core/data/auth_token_repository.dart';
import 'package:github_client/modules/search/data/search_repository_factory.dart';
import 'package:github_client/modules/search/domain/search_use_case.dart';
import 'package:http/http.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final tokenRepository = AuthTokenRepository(
    storage: const FlutterSecureStorage(),
  );
  final httpClient = Client();

  final token = await tokenRepository.getToken();

  final initialLocation = token == null ? '/signIn' : '/';

  final SearchUseCase searchUseCase = SearchUseCase(
    createSearchRepository(tokenRepository, httpClient),
  );

  final AuthUseCase authUseCase = AuthUseCase(
    GitHubAuthRepository(
      httpClient,
      const Config(),
    ),
    tokenRepository,
  );

  runApp(
    GitHubClientApp(
      initialRoute: initialLocation,
      searchUseCase: searchUseCase,
      authUseCase: authUseCase,
    ),
  );
}
