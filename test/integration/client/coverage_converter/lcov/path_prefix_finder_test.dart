import 'package:bitbucket_code_coverage/client/coverage_converter/lcov/path_prefix_finder.dart';
import 'package:test/test.dart';
import 'package:test_descriptor/test_descriptor.dart' as d;
import 'package:test_descriptor/test_descriptor.dart';

void main() {
  test("should return path prefix", () async {
    // given
    DirectoryDescriptor parent = d.dir("project", [
      d.dir("build", [d.file("lcov.info", "")]),
      d.dir("lib", [d.file("first.dart", "")])
    ]);
    await parent.create();
    String workingDirectory = parent.io.parent.path;

    PathPrefixFinder finder = PathPrefixFinder();
    String sourceFilePath = "lib/first.dart";
    String lcovPath = "$workingDirectory/project/build/lcov.info";

    // when
    String pathPrefix = await finder.findPrefix(workingDirectory, lcovPath, sourceFilePath);

    // then
    expect(pathPrefix, equals("project"));
  });
}
