import 'package:bitbucket_code_coverage/src/client/model/coverage_string.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'file_coverage.g.dart';

@immutable
@JsonSerializable()
@CoverageStringConverter()
class FileCoverage {
  final String path;
  final CoverageString coverage;

  const FileCoverage(this.path, this.coverage);

  Map<String, dynamic> toJson() => _$FileCoverageToJson(this);

  factory FileCoverage.fromJson(Map<String, dynamic> json) => _$FileCoverageFromJson(json);
}
