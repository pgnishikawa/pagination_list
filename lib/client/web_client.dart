import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

// REST API endpoint
// Rate Limit = 60 calls / 1hours
const _restApiEndpoint = 'https://api.github.com/repos/flutter/flutter';

final restApiClient = Provider.autoDispose<WebClient>((ref) => WebClient(ref));

class WebClient {
  const WebClient(this.ref);

  final Ref ref;

  // https://docs.github.com/ja/rest/issues/issues
  // GET /issues?state=open&per_page=20&page=1
  Future<List<dynamic>> getOpenIssues(int page) async {
    final ret = await _httpGet(
      '/issues?state=open&per_page=20&page=$page',
    );
    if (ret is List<dynamic>) {
      return ret;
    }

    throw 'ERROR: response parse failed.';
  }

  Future<dynamic> _httpGet(String path) async {
    http.Response response;

    final requestHeaders = {
      'Content-Type': 'application/json; charset=utf-8',
    };
    final url = _restApiEndpoint + path;

    debugPrint("http.get uri: $url");

    try {
      response = await http.get(
        Uri.parse(url),
        headers: requestHeaders,
      );
    } catch (e) {
      throw 'ERROR: http.get: $e';
    }
    var statusCode = response.statusCode;
    debugPrint("HTTP response.statusCode = $statusCode");

    if ((statusCode < 200) || (statusCode > 299)) {
      throw 'ERROR: HTTP status=$statusCode';
    }
    try {
      var ret = json.decode(response.body);
      return ret;
    } catch (e) {
      throw 'ERROR: json.decode: $e';
    }
  }
}
