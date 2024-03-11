import 'package:flutter/foundation.dart';
import 'package:graphql/client.dart';

class AppGraphQLClient {
  static const _uri = 'https://api.github.com/graphql';

  final ValueListenable<String?> _token;

  late GraphQLClient _client;

  AppGraphQLClient(
    this._token, {
    GraphQLClient? client,
  }) {
    _client = client ??
        GraphQLClient(
          link: _link,
          cache: GraphQLCache(),
        );

    _token.addListener(() {
      _client = _client.copyWith(link: _link);
    });
  }

  Future<QueryResult> query<TParsed>(QueryOptions<TParsed> options) =>
      _client.query(options);

  Link get _link {
    final token = _token.value;

    return HttpLink(
      _uri,
      defaultHeaders: token != null ? {'Authorization': token} : {},
    );
  }
}
