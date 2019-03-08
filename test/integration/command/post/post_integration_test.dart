import 'dart:convert';

import 'package:bitbucket_code_coverage/bitbucket_code_coverage_command_runner.dart';
import 'package:mock_web_server/mock_web_server.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:test_descriptor/test_descriptor.dart';

import 'lcov_factory.dart' as lcov_factory;

String commitId = "deadbaca";

void main() {
  List<String> commonParameters;
  MockWebServer mockWebServer = MockWebServer();
  String lcovContent = lcov_factory.lcov(["lib/first.dart", "lib/second.dart"]);

  setUp(() async {
    await mockWebServer.start();
    commonParameters = ["-v", "--url", "${mockWebServer.url}"];
  });

  tearDown(() {
    mockWebServer.shutdown();
  });

  group("authorization", () {
    String expectedRequestBody = json.encode({
      "files": [
        {"path": "lib/first.dart", "coverage": "${lcov_factory.expectedCoverage()}"},
        {"path": "lib/second.dart", "coverage": "${lcov_factory.expectedCoverage()}"}
      ]
    });
    String expectedResponseBody = json.encode([
      {"path": "lib/first.dart", "coverage": "${lcov_factory.expectedCoverage()}"},
      {"path": "lib/second.dart", "coverage": "${lcov_factory.expectedCoverage()}"}
    ]);

    test("should post lcov coverage data to server using username and password", () async {
      // given
      DirectoryDescriptor parent = d.dir("parent", [d.file("lcov.info", lcovContent)]);
      await parent.create();
      mockWebServer.enqueue(httpCode: 201, body: expectedResponseBody);

      // when
      await BitbucketCodeCoverageCommandRunner().run(commonParameters.followedBy([
        "post",
        "-u",
        "username",
        "-p",
        "password",
        "-f",
        "${parent.io.path}/lcov.info",
        "-c",
        commitId
      ]));

      // then
      StoredRequest request = mockWebServer.takeRequest();
      expectProperPostRequest(request);
      expect(request.headers, containsPair("authorization", "Basic dXNlcm5hbWU6cGFzc3dvcmQ="));
      expect(request.body, equals(expectedRequestBody));
    });

    test("should post lcov coverage data to server using token", () async {
      // given
      FileDescriptor lcovFile = d.file("lcov.info", lcovContent);
      await lcovFile.create();
      String token = "token";
      mockWebServer.enqueue(httpCode: 201, body: expectedResponseBody);

      // when
      await BitbucketCodeCoverageCommandRunner().run(commonParameters
          .followedBy(["-t", token, "post", "-f", lcovFile.io.path, "-c", commitId]));

      // then
      StoredRequest request = mockWebServer.takeRequest();
      expectProperPostRequest(request);
      expect(request.headers, containsPair("authorization", "Bearer $token"));
      expect(request.body, equals(expectedRequestBody));
    });
  });

  test("should post coverage data from multiple files by pattern", () async {
    // given
    DirectoryDescriptor dir = d.dir("project", [
      d.dir("first", [
        d.file("lcov.info", "$lcovContent"),
        d.dir("lib", [d.file("first.dart"), d.file("second.dart")])
      ]),
      d.dir("second", [
        d.file("lcov.info", "$lcovContent"),
        d.dir("lib", [d.file("first.dart"), d.file("second.dart")])
      ])
    ]);
    await dir.create();
    Map<String, Iterable<dynamic>> expectedRequestBody = {
      "files": <Map<String, String>>[
        {"path": "second/lib/first.dart", "coverage": "${lcov_factory.expectedCoverage()}"},
        {"path": "second/lib/second.dart", "coverage": "${lcov_factory.expectedCoverage()}"},
        {"path": "first/lib/first.dart", "coverage": "${lcov_factory.expectedCoverage()}"},
        {"path": "first/lib/second.dart", "coverage": "${lcov_factory.expectedCoverage()}"}
      ]
    };
    mockWebServer.enqueue(httpCode: 201, body: "[]");

    // when
    await BitbucketCodeCoverageCommandRunner().run(commonParameters.followedBy([
      "-t",
      "token",
      "post",
      "-d",
      dir.io.path,
      "--file-pattern",
      "**/lcov.info",
      "-c",
      commitId
    ]));

    // then
    StoredRequest request = mockWebServer.takeRequest();
    expectProperPostRequest(request);
    expect(json.decode(request.body)["files"], unorderedEquals(expectedRequestBody["files"]));
  });
}

void expectProperPostRequest(StoredRequest request) {
  expect(request.method, equals("POST"));
  expect(request.uri.path, equals("/rest/code-coverage/1.0/commits/$commitId"));
  expect(request.headers, containsPair("content-type", "application/json; charset=utf-8"));
}
