// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commit_coverage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommitCoverage _$CommitCoverageFromJson(Map json) {
  return $checkedNew('CommitCoverage', json, () {
    final val = CommitCoverage();
    $checkedConvert(
        json,
        'files',
        (v) => val.files = (v as List)
            ?.map((e) => e == null ? null : FileCoverage.fromJson(e as Map))
            ?.toList());
    return val;
  });
}

Map<String, dynamic> _$CommitCoverageToJson(CommitCoverage instance) =>
    <String, dynamic>{'files': instance.files};
