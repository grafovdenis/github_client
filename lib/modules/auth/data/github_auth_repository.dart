import 'dart:convert';

import 'package:github_client/config.dart';
import 'package:github_client/modules/auth/data/auth_repository.dart';
import 'package:github_client/modules/auth/data/models/identity.dart';
import 'package:github_client/modules/auth/data/web_view_authenticator.dart';
import 'package:http/http.dart';

class GitHubAuthRepository implements AuthRepository {
  final Client _client;
  final WebViewAuthenticator _viewAuthenticator;
  final Config _config;

  GitHubAuthRepository(
    this._client,
    this._config, {
    WebViewAuthenticator? authenticator,
  }) : _viewAuthenticator = authenticator ?? WebViewAuthenticator(_config);

  @override
  Future<Identity?> signIn() async {
    final code = await _viewAuthenticator.getAccessCode();

    return code != null ? await _getIdentity(code) : null;
  }

  Future<Identity?> _getIdentity(String code) async {
    final response = await _client.post(
      Uri.parse('https://github.com/login/oauth/access_token'),
      headers: {'Accept': 'application/json'},
      body: {
        'client_id': _config.githubClientId,
        'client_secret': _config.githubClientSecret,
        'code': code,
      },
    );

    final Map<String, dynamic> body = jsonDecode(response.body);

    return body.containsKey('access_token') && body['token_type'] == 'bearer'
        ? Identity(token: 'Bearer ${body['access_token']}')
        : null;
  }
}
