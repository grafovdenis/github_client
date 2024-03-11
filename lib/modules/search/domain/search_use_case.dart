import 'package:github_client/modules/search/data/models/paginated_search_result.dart';
import 'package:github_client/modules/search/data/search_repository.dart';

class SearchUseCase {
  final SearchRepository _repository;

  String? _previousQuery;
  int? _page;
  String? _after;

  SearchUseCase(this._repository);

  Future<PaginatedSearchResult> searchRepositories({
    String? query,
  }) async {
    if (query != _previousQuery) {
      _resetPagination();
    }

    final result = await _repository.searchRepositories(
      query: query,
      page: _page,
      after: _after,
    );

    _previousQuery = query;
    _page = result.nextPage;
    _after = result.endCursor;

    return result;
  }

  void _resetPagination() {
    _page = 1;
    _after = null;
  }
}
