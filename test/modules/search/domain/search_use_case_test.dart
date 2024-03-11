import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/modules/search/data/models/paginated_search_result.dart';
import 'package:github_client/modules/search/data/search_repository.dart';
import 'package:github_client/modules/search/domain/search_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSearchRepository extends Mock implements SearchRepository {}

void main() {
  group('SearchUseCase', () {
    late SearchUseCase searchUseCase;
    late MockSearchRepository mockRepository;

    setUp(() {
      mockRepository = MockSearchRepository();
      searchUseCase = SearchUseCase(mockRepository);
    });

    group('searchRepositories', () {
      test('fetches the first page', () async {
        const query = 'flutter';

        const searchResult = PaginatedSearchResult(
          items: [],
          endCursor: 'fake_end_cursor',
          nextPage: 2,
        );

        when(
          () => mockRepository.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            after: any(named: 'after'),
          ),
        ).thenAnswer((_) => Future.value(searchResult));

        final result = await searchUseCase.searchRepositories(query: query);

        final captured = verify(
          () => mockRepository.searchRepositories(
            query: captureAny(named: 'query'),
            page: captureAny(named: 'page'),
            after: captureAny(named: 'after'),
          ),
        ).captured;

        expect(result, equals(searchResult));
        expect(captured, ['flutter', 1, null]);
      });

      test('fetches the second page', () async {
        const query = 'flutter';

        const searchResult = PaginatedSearchResult(
          items: [],
          endCursor: 'fake_end_cursor',
          nextPage: 2,
        );

        const secondResult = PaginatedSearchResult(
          items: [],
          endCursor: 'another_end_cursor',
          nextPage: 3,
        );

        when(
          () => mockRepository.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            after: any(named: 'after'),
          ),
        ).thenAnswer((_) => Future.value(searchResult));

        await searchUseCase.searchRepositories(query: query);

        when(
          () => mockRepository.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            after: any(named: 'after'),
          ),
        ).thenAnswer((_) => Future.value(secondResult));

        final nextResult = await searchUseCase.searchRepositories(query: query);

        final captured = verify(
          () => mockRepository.searchRepositories(
            query: captureAny(named: 'query'),
            page: captureAny(named: 'page'),
            after: captureAny(named: 'after'),
          ),
        ).captured;

        expect(captured, ['flutter', 1, null, 'flutter', 2, 'fake_end_cursor']);

        expect(nextResult, secondResult);
      });

      test('resets pagination on new query', () async {
        const query = 'flutter';

        const searchResult = PaginatedSearchResult(
          items: [],
          endCursor: 'fake_end_cursor',
          nextPage: 2,
        );

        const secondResult = PaginatedSearchResult(
          items: [],
          endCursor: 'fake_end_cursor',
          nextPage: 2,
        );

        when(
          () => mockRepository.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            after: any(named: 'after'),
          ),
        ).thenAnswer((_) => Future.value(searchResult));

        await searchUseCase.searchRepositories(query: query);

        when(
          () => mockRepository.searchRepositories(
            query: any(named: 'query'),
            page: any(named: 'page'),
            after: any(named: 'after'),
          ),
        ).thenAnswer((_) => Future.value(secondResult));

        final nextResult =
            await searchUseCase.searchRepositories(query: 'dart');

        final captured = verify(
          () => mockRepository.searchRepositories(
            query: captureAny(named: 'query'),
            page: captureAny(named: 'page'),
            after: captureAny(named: 'after'),
          ),
        ).captured;

        expect(captured, ['flutter', 1, null, 'dart', 1, null]);

        expect(nextResult, secondResult);
      });
    });
  });
}
