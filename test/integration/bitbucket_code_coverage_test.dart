import 'package:bitbucket_code_coverage/bitbucket_code_coverage_command_runner.dart';
import 'package:test/test.dart';

void main() {
  test("should not fail if ran without parameters", () async {
    expect(() => BitbucketCodeCoverageCommandRunner().run(<String>[]), returnsNormally);
  });
}
