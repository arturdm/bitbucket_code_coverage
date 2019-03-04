import 'dart:async';
import 'dart:convert';

import 'package:bitbucket_code_coverage/client/model/commit_coverage.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:meta/meta.dart';

abstract class CodeCoverageService {
  Future<CommitCoverage> post(String commitId, CommitCoverage commitCoverage);

  static CodeCoverageService from(
      {@required String url, String token, String username, String password}) {
    assert(url != null);
    assert(token != null || (username != null && password != null));
    return _DefaultCodeCoverageService(
        baseUrl: url, token: token, username: username, password: password);
  }
}

class _DefaultCodeCoverageService implements CodeCoverageService {
  final String baseUrl;
  final String token;
  final String username;
  final String password;

  _DefaultCodeCoverageService({String baseUrl, this.token, this.username, this.password})
      : this.baseUrl = baseUrl.endsWith("/") ? baseUrl.substring(0, baseUrl.length - 1) : baseUrl;

  @override
  Future<CommitCoverage> post(String commitId, CommitCoverage commitCoverage) {
    return http
        .post("$baseUrl/rest/code-coverage/1.0/commits/$commitId",
            headers: <String, String>{
              "Authorization": _toAuthorization(token, username, password),
              "Content-Type": "application/json"
            },
            body: json.encode(commitCoverage.toJson()))
        .then((Response response) =>
            CommitCoverage.fromJson(<String, dynamic>{"files": json.decode(response.body)}));
  }

  String _toAuthorization(String token, String username, String password) {
    if (token != null) {
      return "Bearer $token";
    } else {
      return "Basic ${base64Encode(utf8.encode("$username:$password"))}";
    }
  }
}
