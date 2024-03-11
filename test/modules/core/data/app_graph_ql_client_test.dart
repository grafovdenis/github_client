import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:github_client/modules/core/data/app_graph_ql_client.dart';
import 'package:graphql/client.dart';
import 'package:mocktail/mocktail.dart';

class MockGraphQLClient extends Mock implements GraphQLClient {}

class MockQueryResult extends Mock implements QueryResult {}

class FakeQueryOptions extends Fake implements QueryOptions {}

void main() {
  group('AppGraphQLClient', () {
    late AppGraphQLClient appGraphQLClient;
    late ValueNotifier<String?> token;
    late MockGraphQLClient mockGraphQLClient;

    setUp(() {
      token = ValueNotifier<String?>(null);
      mockGraphQLClient = MockGraphQLClient();

      appGraphQLClient = AppGraphQLClient(
        token,
        client: mockGraphQLClient,
      );
    });

    setUpAll(() {
      registerFallbackValue(FakeQueryOptions());
    });

    test('updates local client on token update', () async {
      final newLocalClient = MockGraphQLClient();

      when(() => mockGraphQLClient.copyWith(link: any(named: 'link')))
          .thenReturn(newLocalClient);

      token.value = 'newToken';

      verify(() => mockGraphQLClient.copyWith(link: any(named: 'link')))
          .called(1);
    });

    test('query executes local client query', () async {
      final result = MockQueryResult();

      when(() => mockGraphQLClient.query(any()))
          .thenAnswer((_) async => result);

      await appGraphQLClient.query(FakeQueryOptions());

      verify(() => mockGraphQLClient.query(any())).called(1);
    });
  });
}
