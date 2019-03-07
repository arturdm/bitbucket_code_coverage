// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'file_coverage.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FileCoverage _$FileCoverageFromJson(Map json) {
  return $checkedNew('FileCoverage', json, () {
    final val = FileCoverage(
        $checkedConvert(json, 'path', (v) => v as String),
        $checkedConvert(
            json,
            'coverage',
            (v) => v == null
                ? null
                : const CoverageStringConverter().fromJson(v as String)));
    return val;
  });
}

Map<String, dynamic> _$FileCoverageToJson(FileCoverage instance) =>
    <String, dynamic>{
      'path': instance.path,
      'coverage': instance.coverage == null
          ? null
          : const CoverageStringConverter().toJson(instance.coverage)
    };
