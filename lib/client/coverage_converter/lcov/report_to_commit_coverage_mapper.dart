import 'package:bitbucket_code_coverage/client/model/commit_coverage.dart';
import 'package:bitbucket_code_coverage/client/model/coverage_string.dart';
import 'package:bitbucket_code_coverage/client/model/file_coverage.dart';
import 'package:lcov/lcov.dart';

class ReportToCommitCoverageMapper {
  const ReportToCommitCoverageMapper();

  CommitCoverage convert(Report report) {
    return CommitCoverage()
      ..files = report.records
          .map((Record record) => FileCoverage()
            ..path = record.sourceFile
            ..coverage = _toCoverageString(record))
          .toList();
  }

  CoverageString _toCoverageString(Record record) {
    List<int> uncovered = record.lines.data
        .where((LineData lineData) => lineData.executionCount == 0)
        .map((LineData lineData) => lineData.lineNumber)
        .toList();

    List<int> partial = record.branches.data
        .where((BranchData branchData) => branchData.taken == 0)
        .map((BranchData branchData) => branchData.lineNumber)
        .toList();

    List<int> covered = record.lines.data
        .where((LineData lineData) => lineData.executionCount != 0)
        .map((LineData lineData) => lineData.lineNumber)
        .where((int lineNumber) => !partial.contains(lineNumber))
        .toList();

    return CoverageString(covered: covered, partial: partial, uncovered: uncovered);
  }
}
