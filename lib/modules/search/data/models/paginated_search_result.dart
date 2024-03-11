import 'package:github_client/modules/search/data/models/search_result_item.dart';

class PaginatedSearchResult {
  final List<SearchResultItem> items;
  final String? endCursor;
  final int? nextPage;

  const PaginatedSearchResult({
    required this.items,
    required this.endCursor,
    required this.nextPage,
  });
}
