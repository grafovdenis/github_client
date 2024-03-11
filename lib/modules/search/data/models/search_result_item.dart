class SearchResultItem {
  final String id;
  final String fullName;
  final String? description;
  final int stars;

  const SearchResultItem({
    required this.id,
    required this.fullName,
    required this.description,
    required this.stars,
  });
}
