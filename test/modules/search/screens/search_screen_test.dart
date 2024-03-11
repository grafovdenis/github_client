import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/modules/search/data/models/paginated_search_result.dart';
import 'package:github_client/modules/search/data/models/search_result_item.dart';
import 'package:github_client/modules/search/domain/search_use_case.dart';
import 'package:github_client/modules/search/screens/search_screen.dart';
import 'package:mocktail/mocktail.dart';
import 'package:provider/provider.dart';

class MockSearchUseCase extends Mock implements SearchUseCase {}

void main() {
  group('SearchScreen', () {
    late MockSearchUseCase mockUseCase;

    setUp(() {
      mockUseCase = MockSearchUseCase();
    });

    testWidgets('on null search results', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Provider<SearchUseCase>(
            create: (_) => mockUseCase,
            child: const SearchScreen(),
          ),
        ),
      );

      expect(find.text('Start by typing the search query'), findsOneWidget);
    });

    testWidgets('on empty search results', (WidgetTester tester) async {
      const mockResult = PaginatedSearchResult(
        items: [],
        endCursor: null,
        nextPage: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<SearchUseCase>(
            create: (_) => mockUseCase,
            child: const SearchScreen(),
          ),
        ),
      );

      when(() => mockUseCase.searchRepositories(query: any(named: 'query')))
          .thenAnswer(
        (_) => Future.value(mockResult),
      );

      await tester.enterText(find.byType(TextField), 'flutter');

      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('No results found'), findsOneWidget);

      verify(() => mockUseCase.searchRepositories(query: any(named: 'query')))
          .called(1);
    });

    testWidgets('with paginated list', (WidgetTester tester) async {
      final mockResult = PaginatedSearchResult(
        items: List.generate(
          15,
          (index) => SearchResultItem(
            id: 'search_result_$index',
            fullName: 'name_$index',
            description: 'description_$index',
            stars: index,
          ),
        ),
        endCursor: null,
        nextPage: null,
      );

      when(() => mockUseCase.searchRepositories(query: any(named: 'query')))
          .thenAnswer((_) => Future.value(mockResult));

      await tester.pumpWidget(
        MaterialApp(
          home: Provider<SearchUseCase>(
            create: (_) => mockUseCase,
            child: const SearchScreen(),
          ),
        ),
      );

      await tester.enterText(find.byType(TextField), 'flutter');

      await tester.pump(const Duration(milliseconds: 500));

      final listFinder = find.byType(Scrollable).last;
      final itemFinder = find.text('name_6');

      expect(listFinder, findsOneWidget);

      await tester.scrollUntilVisible(
        itemFinder,
        500,
        scrollable: listFinder,
      );
      await tester.pumpAndSettle();

      verify(() => mockUseCase.searchRepositories(query: any(named: 'query')))
          .called(2);
    });
  });
}
