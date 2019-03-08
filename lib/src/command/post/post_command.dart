import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:bitbucket_code_coverage/bitbucket_code_coverage.dart';
import 'package:bitbucket_code_coverage/src/client/coverage_converter/coverage_converter.dart';
import 'package:bitbucket_code_coverage/src/client/coverage_converter/lcov_coverage_converter.dart';
import 'package:bitbucket_code_coverage/src/client/model/commit_coverage.dart';
import 'package:bitbucket_code_coverage/src/command/post/converter_strategy.dart';
import 'package:logging/logging.dart';

class PostCommand extends Command<Null> {
  final Logger logger = Logger.root;

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

  String get coverageFilePath => _fromArgResults("file");

  String get coverageFilePattern => _fromArgResults("file-pattern");

  String get workingDirectory => _fromArgResults("working-directory");

  String get commitId => _fromArgResults("commit-id");

  String get url => _fromGlobalResults("url");

  String get token => _fromGlobalResults("token");

  String get username => _fromGlobalResults("username");

  String get password => _fromGlobalResults("password");

  T _fromArgResults<T>(String name) => argResults[name] as T;

  T _fromGlobalResults<T>(String name) => globalResults[name] as T;

  @override
  FutureOr<Null> run() async {
    _validateArguments();

    String currentDirectory = workingDirectory == null ? Directory.current.path : workingDirectory;
    CoverageConverter coverageConverter = LcovCoverageConverter(currentDirectory);
    ConverterStrategy strategy =
        ConverterStrategy.from(coverageFilePath, coverageFilePattern, workingDirectory);
    CommitCoverage commitCoverage = await strategy.convertWith(coverageConverter);

    return _post(commitCoverage);
  }

  Future<Null> _post(CommitCoverage commitCoverage) {
    logger.info("Publishing coverage data to ${url} of commit ${commitId}");
    CodeCoverageService codeCoverageService =
        CodeCoverageService.from(url: url, token: token, username: username, password: password);
    return codeCoverageService.post(commitId, commitCoverage).then((CommitCoverage commitCoverage) {
      logger.info("Published coverage data to ${url}");
    });
  }

  void _validateArguments() {
    if (_fileAndFilePatternProvided() || _neitherFileNorFilePatternProvided()) {
      usageException("""Use either "--file" or "--file-pattern".""");
    }

    if (_noCommitIdProvided()) {
      usageException("""Use "--commit-id" to specify the commit id.""");
    }
  }

  bool _fileAndFilePatternProvided() => coverageFilePattern != null && coverageFilePath != null;

  bool _neitherFileNorFilePatternProvided() =>
      coverageFilePattern == null && coverageFilePath == null;

  bool _noCommitIdProvided() => commitId == null;
}
