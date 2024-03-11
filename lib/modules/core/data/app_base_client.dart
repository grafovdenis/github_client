import 'package:flutter/foundation.dart';
import 'package:http/http.dart';

class AppBaseClient extends BaseClient {
  final ValueListenable<String?> token;
  final Client client;

  AppBaseClient({
    required this.token,
    required this.client,
  });

  @override
  Future<StreamedResponse> send(BaseRequest request) {
    final token = this.token.value;

    if (token != null) {
      request.headers['Authorization'] = token;
    }

    return client.send(request);
  }
}
