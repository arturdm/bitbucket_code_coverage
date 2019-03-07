import 'dart:async';

import 'package:test/test.dart';
import 'package:test_process/test_process.dart';

void main() {
  test("should not fail if ran without parameters", () async {
    // given
    Iterable<String> arguments = [];

    // when
    TestProcess process = await startProcess(arguments);

    // then
    await process.shouldExit(0);
  });

  test("should fail if ran with both token and username", () async {
    // given
    Iterable<String> arguments = ["post", "-t", "token", "-u", "username"];

    // when
    TestProcess process = await startProcess(arguments);

    // then
    await expectLater(
        process.stderr,
        emitsThrough(
            """Could not run with both "--token" and "--username" or "--password" provided."""));
    await process.shouldExit(255);
  });

  test("should fail if ran with both file and pattern", () async {
    // given
    Iterable<String> arguments = ["post", "--file-pattern", "**/lcov.info", "-f", "lcov.info"];

    // when
    TestProcess process = await startProcess(arguments);

    // then
    await expectLater(process.stderr,
        emitsThrough("""Could not run with both "--file" and "--file-pattern" provided."""));
    await process.shouldExit(255);
  });
}

Future<TestProcess> startProcess(Iterable<String> arguments) =>
    TestProcess.start("pub", ["run", "bitbucket_code_coverage"].followedBy(arguments));
