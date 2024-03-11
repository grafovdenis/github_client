import 'package:flutter/material.dart';
import 'package:github_client/modules/auth/domain/auth_use_case.dart';
import 'package:github_client/modules/search/domain/search_use_case.dart';
import 'package:github_client/router.dart';
import 'package:provider/provider.dart';

class GitHubClientApp extends StatelessWidget {
  final String initialRoute;
  final SearchUseCase searchUseCase;
  final AuthUseCase authUseCase;

  const GitHubClientApp({
    super.key,
    required this.initialRoute,
    required this.searchUseCase,
    required this.authUseCase,
  });

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => searchUseCase),
        Provider(create: (_) => authUseCase),
      ],
      child: MaterialApp.router(
        routerConfig: router(initialRoute),
      ),
    );
  }
}
