import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/modules/core/data/app_graph_ql_client.dart';
import 'package:github_client/modules/search/data/gql_search_repository.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';

class MockAppGraphQLClient extends Mock implements AppGraphQLClient {}

class NonEmptyMockQueryResult extends Mock implements QueryResult {
  @override
  bool get hasException => false;

  @override
  Map<String, dynamic>? get data => {
        'search': {
          'edges': [
            {
              'node': {
                'id': '1',
                'nameWithOwner': 'user/repo',
                'description': 'Description',
                'stargazerCount': 100,
              },
            },
          ],
          'pageInfo': {
            'endCursor': 'fakeEndCursor',
          },
        },
      };
}

class EmptyMockQueryResult extends Mock implements QueryResult {
  @override
  bool get hasException => false;

  @override
  Map<String, dynamic>? get data => {
        'search': {},
      };
}

class InvalidMockQueryResult extends Mock implements QueryResult {
  @override
  bool get hasException => true;

  @override
  Map<String, dynamic>? get data => {};

  @override
  OperationException? get exception => OperationException();
}

class FakeQueryOptions extends Fake implements QueryOptions {}

void main() {
  group('GqlSearchRepository', () {
    late GqlSearchRepository gqlSearchRepository;
    late MockAppGraphQLClient mockGraphQLClient;

    setUp(() {
      mockGraphQLClient = MockAppGraphQLClient();
      gqlSearchRepository = GqlSearchRepository(mockGraphQLClient);
    });

    setUpAll(() {
      registerFallbackValue(FakeQueryOptions());
    });

    group('searchRepositories', () {
      const fakeQuery = 'flutter';
      const fakePageSize = 10;

      test(
        'should return PaginatedSearchResult with List<SearchResult>',
        () async {
          final fakeResult = NonEmptyMockQueryResult();

          when(() => mockGraphQLClient.query(any()))
              .thenAnswer((_) async => fakeResult);

          final result = await gqlSearchRepository.searchRepositories(
            query: fakeQuery,
            pageSize: fakePageSize,
          );

          expect(result.items, hasLength(1));
          expect(result.nextPage, isNull);
          expect(result.endCursor, equals('fakeEndCursor'));

          verify(() => mockGraphQLClient.query(any())).called(1);
        },
      );

      test(
        'should return PaginatedSearchResult with empty List<SearchResult>',
        () async {
          final fakeResult = EmptyMockQueryResult();

          when(() => mockGraphQLClient.query(any()))
              .thenAnswer((_) async => fakeResult);

          final result = await gqlSearchRepository.searchRepositories(
            query: fakeQuery,
            pageSize: fakePageSize,
          );

          expect(result.items, isEmpty);
          expect(result.nextPage, isNull);
          expect(result.endCursor, isNull);

          verify(() => mockGraphQLClient.query(any())).called(1);
        },
      );

      test('should throw Exception', () async {
        final fakeResult = InvalidMockQueryResult();

        when(() => mockGraphQLClient.query(any()))
            .thenAnswer((_) async => fakeResult);

        expectLater(
          gqlSearchRepository.searchRepositories(
            query: fakeQuery,
            pageSize: fakePageSize,
          ),
          throwsException,
        );

        verify(() => mockGraphQLClient.query(any())).called(1);
      });
    });
  });
}
