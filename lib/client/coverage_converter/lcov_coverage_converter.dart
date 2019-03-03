import 'dart:io';

import 'package:bitbucket_code_coverage/client/coverage_converter/coverage_converter.dart';
import 'package:bitbucket_code_coverage/client/coverage_converter/lcov/report_to_commit_coverage_mapper.dart';
import 'package:bitbucket_code_coverage/client/model/commit_coverage.dart';
import 'package:lcov/lcov.dart';

class LcovCoverageConverter implements CoverageConverter {
  final ReportToCommitCoverageMapper _converter;

  LcovCoverageConverter() : this.withMapper(ReportToCommitCoverageMapper());

  LcovCoverageConverter.withMapper(this._converter) : assert(_converter != null);

  @override
  Future<CommitCoverage> convert(File coverageFile) async {
    String coverage = await coverageFile.readAsString();
    Report report = Report.fromCoverage(coverage);
    return _converter.convert(report);
  }
}
