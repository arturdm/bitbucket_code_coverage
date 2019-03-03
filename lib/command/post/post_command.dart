import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bitbucket_code_coverage/client/code_coverage_service.dart';
import 'package:bitbucket_code_coverage/client/coverage_converter/coverage_converter.dart';
import 'package:bitbucket_code_coverage/client/coverage_converter/lcov_coverage_converter.dart';
import 'package:bitbucket_code_coverage/client/model/commit_coverage.dart';

class PostCommand extends Command<Null> {
  final CoverageConverter coverageConverter = LcovCoverageConverter();

  PostCommand() {
    argParser.addOption("file", abbr: "f", help: "specifies coverage file path");
    argParser.addOption("commit-id", abbr: "c", help: "specifies commit id");
  }

  @override
  String get description => "posts code coverage data";

  @override
  String get name => "post";

  String get coverageFilePath => argResults["file"];

  String get commitId => argResults["commit-id"];

  String get url => globalResults["url"];

  String get token => globalResults["token"];

  String get username => globalResults["username"];

  String get password => globalResults["password"];

  @override
  FutureOr<Null> run() async {
    File coverageFile = File(coverageFilePath);
    CommitCoverage commitCoverage = await coverageConverter.convert(coverageFile);
    return _post(commitCoverage).then((CommitCoverage commitCoverage) => null);
  }

  Future<CommitCoverage> _post(CommitCoverage commitCoverage) {
    CodeCoverageService codeCoverageService =
        CodeCoverageService.from(url: url, token: token, username: username, password: password);
    return codeCoverageService.post(commitId, commitCoverage);
  }
}
