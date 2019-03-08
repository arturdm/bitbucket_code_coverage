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
            contains(
                """Could not run with both "--token" and "--username" or "--password" provided."""))));
  });

  test("should fail if ran with both file and pattern", () {
    // given
    Iterable<String> arguments = ["post", "--file-pattern", "**/lcov.info", "-f", "lcov.info"];

    // expect
    expect(
        () => BitbucketCodeCoverageCommandRunner().run(arguments),
        throwsA(TypeMatcher<UsageException>().having(
            (UsageException usageException) => usageException.message,
            "message",
            contains("""Could not run with both "--file" and "--file-pattern" provided."""))));
  });
}
