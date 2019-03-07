import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bitbucket_code_coverage/client/code_coverage_service.dart';
import 'package:bitbucket_code_coverage/client/coverage_converter/coverage_converter.dart';
import 'package:bitbucket_code_coverage/client/coverage_converter/lcov_coverage_converter.dart';
import 'package:bitbucket_code_coverage/client/model/commit_coverage.dart';
import 'package:bitbucket_code_coverage/command/post/converter_strategy.dart';

class PostCommand extends Command<Null> {
  PostCommand() {
    argParser.addOption("file", abbr: "f", help: "specifies coverage file path");
    argParser.addOption("file-pattern", help: "specifies coverage file pattern");
    argParser.addOption("working-directory", abbr: "d", help: "specifies the working directory");
    argParser.addOption("commit-id", abbr: "c", help: "specifies commit id");
  }

  @override
  String get description => "posts code coverage data";

  @override
  String get name => "post";

  String get coverageFilePath => argResults["file"];

  String get coverageFilePattern => argResults["file-pattern"];

  String get workingDirectory => argResults["working-directory"];

  String get commitId => argResults["commit-id"];

  String get url => globalResults["url"];

  String get token => globalResults["token"];

  String get username => globalResults["username"];

  String get password => globalResults["password"];

  @override
  FutureOr<Null> run() async {
    _validateArguments();

    String currentDirectory = workingDirectory == null ? Directory.current.path : workingDirectory;
    CoverageConverter coverageConverter = LcovCoverageConverter(currentDirectory);
    ConverterStrategy strategy =
        ConverterStrategy.from(coverageFilePath, coverageFilePattern, workingDirectory);
    CommitCoverage commitCoverage = await strategy.convertWith(coverageConverter);
    return _post(commitCoverage).then((CommitCoverage commitCoverage) => null);
  }

  Future<CommitCoverage> _post(CommitCoverage commitCoverage) {
    CodeCoverageService codeCoverageService =
        CodeCoverageService.from(url: url, token: token, username: username, password: password);
    return codeCoverageService.post(commitId, commitCoverage);
  }

  void _validateArguments() {
    if (coverageFilePattern != null && coverageFilePath != null) {
      usageException("""Could not run with both "--file" and "--file-pattern" provided.""");
    }
  }
}
