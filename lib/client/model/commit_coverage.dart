import 'package:bitbucket_code_coverage/client/model/file_coverage.dart';
import 'package:json_annotation/json_annotation.dart';

part 'commit_coverage.g.dart';

@JsonSerializable()
class CommitCoverage {
  @JsonKey()
  List<FileCoverage> files;

  Map<String, dynamic> toJson() => _$CommitCoverageToJson(this);

  static CommitCoverage fromJson(Map<String, dynamic> json) {
    return _$CommitCoverageFromJson(json);
  }
}
