import 'package:bitbucket_code_coverage/bitbucket_code_coverage_command_runner.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test_api/test_api.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:test_descriptor/test_descriptor.dart';

void main() {
  MockWebServer mockWebServer = MockWebServer();
  String lcovContent = """
SF:lib/first.dart
DA:6,0
DA:7,0
DA:8,0
DA:9,0
LF:101
LH:0
end_of_record
SF:lib/second.dart
DA:11,1
DA:19,1
LF:2
LH:2
end_of_record
""";
  String expectedRequestBody = """{"files":[{"path":"lib/first.dart","coverage":"C:;P:;U:6,7,8,9"},{"path":"lib/second.dart","coverage":"C:11,19;P:;U:"}]}""";
  String expectedResponseBody = """[
  {"path":"lib/first.dart","coverage":"C:6,7,8,9;P:;U:14"},
  {"path":"lib/second.dart","coverage":"C:11,19;P:;U:14"}
]""";

  setUp(() async {
    await mockWebServer.start();
  });

  tearDown(() async {
    await mockWebServer.shutdown();
  });

  test("should post lcov coverage data to server using token", () async {
    String token = "token";
    String commitId = "deadbaca";
    FileDescriptor lcovFile = d.file("lcov.info", lcovContent);
    await lcovFile.create();
    mockWebServer.enqueue(httpCode: 201, body: expectedResponseBody);

    await BitbucketCodeCoverageCommandRunner().run(<String>[
      "-v",
      "--url",
      "${mockWebServer.url}",
      "-t",
      token,
      "-u",
      "username but token takes precedence",
      "-p",
      "password but token takes precedence",
      "post",
      "-f",
      lcovFile.io.path,
      "-c",
      commitId
    ]);

    StoredRequest request = mockWebServer.takeRequest();
    expect(request.method, equals("POST"));
    expect(request.uri.path, equals("/rest/code-coverage/1.0/commits/$commitId"));
    expect(request.headers, containsPair("authorization", "Bearer $token"));
    expect(request.headers, containsPair("content-type", "application/json; charset=utf-8"));
    expect(request.body, equals(expectedRequestBody));
  });

  test("should post lcov coverage data to server using username and password", () async {
    String commitId = "deadbaca";
    FileDescriptor lcovFile = d.file("lcov.info", lcovContent);
    await lcovFile.create();
    mockWebServer.enqueue(httpCode: 201, body: expectedResponseBody);

    await BitbucketCodeCoverageCommandRunner().run(<String>[
      "-v",
      "--url",
      "${mockWebServer.url}",
      "-u",
      "username",
      "-p",
      "password",
      "post",
      "-f",
      lcovFile.io.path,
      "-c",
      commitId
    ]);

    StoredRequest request = mockWebServer.takeRequest();
    expect(request.method, equals("POST"));
    expect(request.uri.path, equals("/rest/code-coverage/1.0/commits/$commitId"));
    expect(request.headers, containsPair("authorization", "Basic dXNlcm5hbWU6cGFzc3dvcmQ="));
    expect(request.headers, containsPair("content-type", "application/json; charset=utf-8"));
    expect(request.body, equals(expectedRequestBody));
  });
}
