import 'dart:convert';

import 'package:github_client/modules/search/data/models/paginated_search_result.dart';
import 'package:github_client/modules/search/data/models/search_result_item.dart';
import 'package:github_client/modules/search/data/search_repository.dart';
import 'package:http/http.dart';

class RestSearchRepository implements SearchRepository {
  final BaseClient _client;

  const RestSearchRepository(this._client);

  @override
  Future<PaginatedSearchResult> searchRepositories({
    String? query,
    int pageSize = SearchRepository.defaultPageSize,
    int? page,
    String? after,
  }) async {
    final uri = Uri(
      scheme: 'https',
      host: 'api.github.com',
      path: 'search/repositories',
      queryParameters: {
        'q': query,
        'per_page': '$pageSize',
        'page': '$page',
      },
    ).replace();

    final response = await _client.get(uri);

    final data = json.decode(response.body) as Map<String, dynamic>;
    final items = data['items'] as List?;

    final repos = [
      if (items != null)
        ...items.map(
          (e) => SearchResultItem(
            id: e['node_id'],
            fullName: e['full_name'],
            description: e['description'],
            stars: e['stargazers_count'],
          ),
        )
    ];

    return PaginatedSearchResult(
      items: repos,
      endCursor: null,
      nextPage: (page ?? 0) + 1,
    );
  }
}
