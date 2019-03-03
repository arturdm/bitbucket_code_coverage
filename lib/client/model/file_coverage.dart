import 'package:bitbucket_code_coverage/client/model/coverage_string.dart';
import 'package:json_annotation/json_annotation.dart';

part 'file_coverage.g.dart';

@JsonSerializable()
@CoverageStringConverter()
class FileCoverage {
  @JsonKey()
  String path;
  @JsonKey()
  CoverageString coverage;

  Map<String, dynamic> toJson() => _$FileCoverageToJson(this);

  static FileCoverage fromJson(Map<String, dynamic> json) {
    return _$FileCoverageFromJson(json);
  }
}
