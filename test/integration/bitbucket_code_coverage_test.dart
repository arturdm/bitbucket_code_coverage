import 'package:args/command_runner.dart';
import 'package:bitbucket_code_coverage/bitbucket_code_coverage_command_runner.dart';
import 'package:test/test.dart';

void main() {
  test("should not fail if ran without parameters", () {
    // given
    Iterable<String> arguments = [];

    // expect
    expect(() => BitbucketCodeCoverageCommandRunner().run(arguments), returnsNormally);
  });

  final Iterable<String> post = ["post"];
  final Iterable<String> url = ["--url", "http://localhost:7990"];
  final Iterable<String> username = ["-u", "username"];
  final Iterable<String> password = ["-p", "password"];
  final Iterable<String> token = ["-t", "token"];
  final Iterable<String> file = ["-f", "build/lcov.info"];
  final Iterable<String> filePattern = ["--file-pattern", "**/lcov.info"];

  List.of([
    Row(
        arguments: post,
        expectedMessage: """Use "--url" to point to your Bitbucket server.""",
        description: "without url"),
    Row(
        arguments: [url, post].fold([], mergeIterables),
        expectedMessage: """Use either "--token" or "--username" with "--password".""",
        description: "with neither token nor username"),
    Row(
        arguments: [url, post, token, username, password].fold([], mergeIterables),
        expectedMessage: """Use either "--token" or "--username" with "--password".""",
        description: "with both token and username"),
    Row(
        arguments: [url, post, token].fold([], mergeIterables),
        expectedMessage: """Use either "--file" or "--file-pattern".""",
        description: "with neither file nor pattern"),
    Row(
        arguments: [url, post, token, file, filePattern].fold([], mergeIterables),
        expectedMessage: """Use either "--file" or "--file-pattern".""",
        description: "with both file and pattern"),
    Row(
        arguments: [url, post, token, file].fold([], mergeIterables),
        expectedMessage: """Use "--commit-id" to specify the commit id.""",
        description: "without commit id"),
  ]).forEach((Row row) {
    test("should fail if ran ${row.description}", () {
      expect(
          () => BitbucketCodeCoverageCommandRunner().run(row.arguments),
          throwsA(TypeMatcher<UsageException>().having(
              (UsageException usageException) => usageException.message,
              "message",
              contains(row.expectedMessage))));
    });
  });
}

class Row {
  final Iterable<String> arguments;
  final String expectedMessage;
  final String description;

  const Row({this.arguments, this.expectedMessage, this.description});
}

Iterable<T> mergeIterables<T>(Iterable<T> first, Iterable<T> second) => first.followedBy(second);
