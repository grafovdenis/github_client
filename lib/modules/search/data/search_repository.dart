import 'package:github_client/modules/search/data/models/paginated_search_result.dart';

abstract class SearchRepository {
  static const defaultPageSize = 15;

  Future<PaginatedSearchResult> searchRepositories({
    String? query,
    int pageSize = defaultPageSize,
    int? page,
    String? after,
  });
}
