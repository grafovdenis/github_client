import 'package:github_client/modules/core/data/app_base_client.dart';
import 'package:github_client/modules/core/data/app_graph_ql_client.dart';
import 'package:github_client/modules/core/data/auth_token_repository.dart';
import 'package:github_client/modules/search/data/gql_search_repository.dart';
import 'package:github_client/modules/search/data/rest_search_repository.dart';
import 'package:github_client/modules/search/data/search_repository.dart';
import 'package:http/http.dart';

const _networkClient = String.fromEnvironment(
  'NETWORK_CLIENT',
  defaultValue: 'rest',
);

const _restClient = 'rest';
const _gqlClient = 'gql';

SearchRepository createSearchRepository(
  AuthTokenRepository tokenRepository,
  Client client, {
  String networkClient = _networkClient,
}) {
  if (networkClient == _restClient) {
    return RestSearchRepository(
      AppBaseClient(
        token: tokenRepository.token,
        client: client,
      ),
    );
  } else if (networkClient == _gqlClient) {
    return GqlSearchRepository(
      AppGraphQLClient(tokenRepository.token),
    );
  } else {
    throw UnimplementedError();
  }
}
