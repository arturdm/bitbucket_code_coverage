import 'package:bitbucket_code_coverage/client/model/file_coverage.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'commit_coverage.g.dart';

@immutable
@JsonSerializable()
class CommitCoverage {
  final List<FileCoverage> files;

  const CommitCoverage(this.files);

  Map<String, dynamic> toJson() => _$CommitCoverageToJson(this);

  factory CommitCoverage.fromJson(Map<String, dynamic> json) => _$CommitCoverageFromJson(json);
}
