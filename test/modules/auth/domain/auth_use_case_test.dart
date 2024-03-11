import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/modules/auth/data/auth_repository.dart';
import 'package:github_client/modules/auth/data/models/identity.dart';
import 'package:github_client/modules/auth/domain/auth_use_case.dart';
import 'package:github_client/modules/core/data/auth_token_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAuthTokenRepository extends Mock implements AuthTokenRepository {}

void main() {
  group('AuthUseCase', () {
    late AuthUseCase authUseCase;
    late MockAuthRepository mockRepository;
    late MockAuthTokenRepository mockStorage;

    setUp(() {
      mockRepository = MockAuthRepository();
      mockStorage = MockAuthTokenRepository();
      authUseCase = AuthUseCase(mockRepository, mockStorage);
    });

    group('signIn', () {
      test('calls repository and sets token on successful authentication',
          () async {
        const fakeToken = 'fake_token';
        const fakeIdentity = Identity(token: fakeToken);

        when(() => mockRepository.signIn())
            .thenAnswer((_) async => fakeIdentity);
        when(() => mockStorage.setToken(any())).thenAnswer((_) async {});

        await authUseCase.signIn();

        verify(() => mockRepository.signIn()).called(1);
        verify(() => mockStorage.setToken(fakeToken)).called(1);
      });

      test('does not set token on unsuccessful authentication', () async {
        when(() => mockRepository.signIn()).thenAnswer((_) async => null);

        await authUseCase.signIn();

        verify(() => mockRepository.signIn()).called(1);
        verifyNever(() => mockStorage.setToken(any()));
      });
    });
  });
}
