import 'package:github_client/modules/core/data/app_graph_ql_client.dart';
import 'package:github_client/modules/search/data/models/paginated_search_result.dart';
import 'package:github_client/modules/search/data/models/search_result_item.dart';
import 'package:github_client/modules/search/data/search_repository.dart';
import 'package:graphql/client.dart';

const String _searchRepositoriesQuery = r'''
query Search($query: String!, $first: Int, $after:String) {
  search(query: $query, type: REPOSITORY, first: $first, after: $after) {
    edges {
      node {
        ... on Repository {
          id
          nameWithOwner
          description
          stargazerCount
        }
      }
    }
    pageInfo {
      endCursor
    }
  }
}
''';

class GqlSearchRepository implements SearchRepository {
  final AppGraphQLClient _client;

  const GqlSearchRepository(this._client);

  @override
  Future<PaginatedSearchResult> searchRepositories({
    String? query,
    int pageSize = SearchRepository.defaultPageSize,
    int? page,
    String? after,
  }) async {
    final options = QueryOptions(
      document: gql(_searchRepositoriesQuery),
      variables: {
        'query': query,
        'first': pageSize,
        'after': after,
      },
    );

    final result = await _client.query(options);

    if (result.hasException) {
      throw result.exception!;
    }

    final edges = result.data?['search']?['edges'] as List?;

    final endCursor =
        result.data?['search']?['pageInfo']?['endCursor'] as String?;

    final repositories = [
      if (edges != null)
        ...edges.map(
          (e) => SearchResultItem(
            id: e['node']['id'],
            fullName: e['node']['nameWithOwner'],
            description: e['node']['description'],
            stars: e['node']['stargazerCount'],
          ),
        )
    ];

    return PaginatedSearchResult(
      items: repositories,
      endCursor: endCursor,
      nextPage: null,
    );
  }
}
