import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:github_client/config.dart';

class WebViewAuthenticator {
  static const _redirectUri = 'com.example.client://login_callback';

  final Config _config;

  const WebViewAuthenticator(this._config);

  Future<String?> getAccessCode() async {
    final result = await FlutterWebAuth2.authenticate(
      url:
          'https://github.com/login/oauth/authorize?client_id=${_config.githubClientId}&redirect_uri=$_redirectUri',
      callbackUrlScheme: 'com.example.client',
    );

    return Uri.parse(result).queryParameters['code'];
  }
}
