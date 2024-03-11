import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/modules/core/data/auth_token_repository.dart';
import 'package:github_client/modules/search/data/gql_search_repository.dart';
import 'package:github_client/modules/search/data/rest_search_repository.dart';
import 'package:github_client/modules/search/data/search_repository_factory.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthTokenRepository extends Mock implements AuthTokenRepository {
  MockAuthTokenRepository() {
    when(() => token).thenReturn(ValueNotifier(null));
  }
}

class MockClient extends Mock implements Client {}

void main() {
  group('createSearchRepository', () {
    late AuthTokenRepository mockTokenRepository;
    late Client mockClient;

    setUp(() {
      mockTokenRepository = MockAuthTokenRepository();
      mockClient = MockClient();
    });

    test('returns RestSearchRepository when networkClient is "rest"', () {
      const networkClient = 'rest';

      final repository = createSearchRepository(
        mockTokenRepository,
        mockClient,
        networkClient: networkClient,
      );

      expect(repository, isA<RestSearchRepository>());
    });

    test('returns GqlSearchRepository when networkClient is "gql"', () {
      const networkClient = 'gql';

      final repository = createSearchRepository(
        mockTokenRepository,
        mockClient,
        networkClient: networkClient,
      );

      expect(repository, isA<GqlSearchRepository>());
    });

    test('throws UnimplementedError for unknown networkClient', () {
      const networkClient = 'unknown';

      expect(
        () => createSearchRepository(
          mockTokenRepository,
          mockClient,
          networkClient: networkClient,
        ),
        throwsA(isA<UnimplementedError>()),
      );
    });
  });
}
