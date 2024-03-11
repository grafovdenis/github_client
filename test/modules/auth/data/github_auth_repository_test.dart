import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/config.dart';
import 'package:github_client/modules/auth/data/github_auth_repository.dart';
import 'package:github_client/modules/auth/data/web_view_authenticator.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockClient extends Mock implements Client {}

class MockWebViewAuthenticator extends Mock implements WebViewAuthenticator {}

void main() {
  group('GitHubAuthRepository', () {
    const mockConfig = Config(
      githubClientId: 'your_client_id',
      githubClientSecret: 'your_client_secret',
    );

    late GitHubAuthRepository authRepository;
    late MockClient mockClient;
    late MockWebViewAuthenticator mockAuthenticator;

    setUp(() {
      mockClient = MockClient();
      mockAuthenticator = MockWebViewAuthenticator();
      authRepository = GitHubAuthRepository(
        mockClient,
        mockConfig,
        authenticator: mockAuthenticator,
      );
    });

    group('signIn', () {
      test('returns Identity on successful authentication', () async {
        const fakeCode = 'fake_code';
        const fakeAccessToken = 'fake_access_token';
        final fakeResponseBody = {
          'access_token': fakeAccessToken,
          'token_type': 'bearer'
        };

        when(() => mockAuthenticator.getAccessCode())
            .thenAnswer((_) async => fakeCode);
        when(() => mockClient.post(
                  Uri.parse('https://github.com/login/oauth/access_token'),
                  headers: any(named: 'headers'),
                  body: any(named: 'body'),
                ))
            .thenAnswer(
                (_) async => Response(jsonEncode(fakeResponseBody), 200));

        final result = await authRepository.signIn();

        expect(result, isNotNull);
        expect(result?.token, equals('Bearer $fakeAccessToken'));
      });

      test('returns null on unsuccessful authentication', () async {
        when(() => mockAuthenticator.getAccessCode())
            .thenAnswer((_) async => null);

        final result = await authRepository.signIn();

        expect(result, isNull);
      });
    });
  });
}
