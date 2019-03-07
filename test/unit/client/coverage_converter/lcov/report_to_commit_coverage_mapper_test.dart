import 'package:bitbucket_code_coverage/client/coverage_converter/lcov/report_to_commit_coverage_mapper.dart';
import 'package:bitbucket_code_coverage/client/model/commit_coverage.dart';
import 'package:bitbucket_code_coverage/client/model/coverage_string.dart';
import 'package:lcov/lcov.dart';
import 'package:test/test.dart';

void main() {
  test("should map Report to CommitCoverage", () async {
    // given
    ReportToCommitCoverageMapper converter = ReportToCommitCoverageMapper();
    Report report = Report.fromCoverage("""
SF:lib/first.dart
BRDA:2,0,0,-
BRF:1
BRH:1
DA:1,0
DA:2,1
DA:3,1
LF:3
LH:3
end_of_record
SF:lib/second.dart
DA:1,1
DA:2,1
LF:2
LH:2
end_of_record
    """);

    // when
    CommitCoverage commitCoverage = await converter.convert(report, "root", "root/lcov.info");

    // then
    expect(commitCoverage.files, hasLength(2));
    expect(commitCoverage.files[0].path, equals("lib/first.dart"));
    expect(commitCoverage.files[0].coverage, equals(CoverageString.fromString("C:3;P:2;U:1")));
    expect(commitCoverage.files[1].path, equals("lib/second.dart"));
    expect(commitCoverage.files[1].coverage, equals(CoverageString.fromString("C:1,2;P:;U:")));
  });
}
