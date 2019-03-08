import 'dart:async';
import 'dart:io';

import 'package:bitbucket_code_coverage/src/client/coverage_converter/coverage_converter.dart';
import 'package:bitbucket_code_coverage/src/client/coverage_converter/lcov/report_to_commit_coverage_mapper.dart';
import 'package:bitbucket_code_coverage/src/client/model/commit_coverage.dart';
import 'package:lcov/lcov.dart';

class LcovCoverageConverter implements CoverageConverter {
  final String _workingDirectory;
  final ReportToCommitCoverageMapper _mapper;

  LcovCoverageConverter(this._workingDirectory,
      [this._mapper = const ReportToCommitCoverageMapper()])
      : assert(_mapper != null);

  @override
  Future<CommitCoverage> convert(File coverageFile) async {
    String coverage = await coverageFile.readAsString();
    Report report = Report.fromCoverage(coverage);
    return _mapper.convert(report, _workingDirectory, coverageFile.path);
  }
}
