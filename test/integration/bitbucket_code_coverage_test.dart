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

  test("should fail if ran with both token and username", () {
    // given
    Iterable<String> arguments = ["post", "-t", "token", "-u", "username"];

    // expect
    expect(
        () => BitbucketCodeCoverageCommandRunner().run(arguments),
        throwsA(TypeMatcher<UsageException>().having(
            (UsageException usageException) => usageException.message,
            "message",
            contains("""Use either "--token" or "--username" with "--password"."""))));
  });

  List.of([
    Row(arguments: ["post"], description: "with neither file nor pattern"),
    Row(
        arguments: ["post", "--file-pattern", "**/lcov.info", "-f", "lcov.info"],
        description: "with both file and pattern")
  ]).forEach((Row row) {
    test("should fail if ran ${row.description}", () {
      // expect
      expect(
          () => BitbucketCodeCoverageCommandRunner().run(row.arguments),
          throwsA(TypeMatcher<UsageException>().having(
              (UsageException usageException) => usageException.message,
              "message",
              contains("""Use either "--file" or "--file-pattern"."""))));
    });
  });
}

class Row {
  final Iterable<String> arguments;
  final String description;

  const Row({this.arguments, this.description});
}
