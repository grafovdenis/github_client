import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/modules/search/data/rest_search_repository.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';

class MockBaseClient extends Mock implements BaseClient {}

class FakeUri extends Fake implements Uri {}

void main() {
  group('RestSearchRepository', () {
    late RestSearchRepository restSearchRepository;
    late MockBaseClient mockBaseClient;

    setUp(() {
      mockBaseClient = MockBaseClient();
      restSearchRepository = RestSearchRepository(mockBaseClient);
    });

    setUpAll(() {
      registerFallbackValue(FakeUri());
    });

    test('searchRepositories returns PaginatedSearchResult', () async {
      const query = 'flutter';
      const pageSize = 10;
      const page = 1;

      const mockResponse = '''
        {
          "items": [
            {
              "node_id": "1",
              "full_name": "owner/repo1",
              "description": "Description 1",
              "stargazers_count": 100
            },
            {
              "node_id": "2",
              "full_name": "owner/repo2",
              "description": "Description 2",
              "stargazers_count": 200
            }
          ]
        }
      ''';

      when(() => mockBaseClient.get(any())).thenAnswer(
        (_) async => Response(mockResponse, 200),
      );

      final result = await restSearchRepository.searchRepositories(
        query: query,
        pageSize: pageSize,
        page: page,
      );

      expect(result.items, hasLength(2));
      expect(result.endCursor, isNull);
      expect(result.nextPage, page + 1);

      verify(() => mockBaseClient.get(any())).called(1);
    });
  });
}
