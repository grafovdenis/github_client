import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/modules/core/data/app_base_client.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockValueListenable extends Mock implements ValueListenable<String?> {}

class MockClient extends Mock implements Client {}

class MockStreamedResponse extends Mock implements StreamedResponse {}

void main() {
  group('AppBaseClient', () {
    late AppBaseClient appBaseClient;
    late MockValueListenable mockToken;
    late MockClient mockHttpClient;

    setUp(() {
      mockToken = MockValueListenable();
      mockHttpClient = MockClient();

      appBaseClient = AppBaseClient(
        token: mockToken,
        client: mockHttpClient,
      );
    });

    test('send should add Authorization header when token is not null',
        () async {
      const fakeToken = 'fake_token';
      final fakeRequest = Request('GET', Uri.parse('https://example.com'));

      when(() => mockToken.value).thenReturn(fakeToken);
      when(() => mockHttpClient.send(fakeRequest))
          .thenAnswer((_) => Future.value(MockStreamedResponse()));

      await appBaseClient.send(fakeRequest);

      expect(fakeRequest.headers['Authorization'], equals(fakeToken));
      verify(() => mockHttpClient.send(fakeRequest)).called(1);
    });

    test('send should not add Authorization header when token is null',
        () async {
      final fakeRequest = Request('GET', Uri.parse('https://example.com'));
      when(() => mockToken.value).thenReturn(null);

      when(() => mockHttpClient.send(fakeRequest))
          .thenAnswer((_) => Future.value(MockStreamedResponse()));

      await appBaseClient.send(fakeRequest);

      expect(fakeRequest.headers, isEmpty);
      verify(() => mockHttpClient.send(fakeRequest)).called(1);
    });
  });
}
