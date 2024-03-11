import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/modules/core/data/auth_token_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('AuthTokenRepository', () {
    late AuthTokenRepository authTokenRepository;
    late MockFlutterSecureStorage mockStorage;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      authTokenRepository = AuthTokenRepository(storage: mockStorage);
    });

    group('getToken', () {
      test('should return null initially', () async {
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => null);

        final result = await authTokenRepository.getToken();

        expect(result, isNull);
        expect(authTokenRepository.token.value, isNull);
        verify(() => mockStorage.read(key: any(named: 'key'))).called(1);
      });

      test('should return token from storage', () async {
        const fakeToken = 'fake_token';
        when(() => mockStorage.read(key: any(named: 'key')))
            .thenAnswer((_) async => fakeToken);

        final result = await authTokenRepository.getToken();

        expect(result, equals(fakeToken));
        expect(authTokenRepository.token.value, equals(fakeToken));
        verify(() => mockStorage.read(key: any(named: 'key'))).called(1);
      });
    });

    group('setToken', () {
      test('should write token to storage', () async {
        const fakeToken = 'fake_token';
        when(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: fakeToken,
          ),
        ).thenAnswer((_) async {});

        expect(authTokenRepository.token.value, isNull);

        await authTokenRepository.setToken(fakeToken);

        verify(
          () => mockStorage.write(
            key: any(named: 'key'),
            value: fakeToken,
          ),
        ).called(1);
        expect(authTokenRepository.token.value, equals(fakeToken));
      });
    });
  });
}
