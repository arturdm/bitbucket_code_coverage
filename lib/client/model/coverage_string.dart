import 'package:collection/collection.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

@immutable
class CoverageString {
  final List<int> covered;
  final List<int> partial;
  final List<int> uncovered;

  CoverageString({List<int> covered, List<int> partial, List<int> uncovered})
      : this.covered = List<int>.unmodifiable(covered ?? <int>[]),
        this.partial = List<int>.unmodifiable(partial ?? <int>[]),
        this.uncovered = List<int>.unmodifiable(uncovered ?? <int>[]);

  String format() => "C:${covered.join(",")};P:${partial.join(",")};U:${uncovered.join(",")}";

  @override
  String toString() => format();

  @override
  bool operator ==(Object other) {
    Function equal = const ListEquality<int>().equals;
    return identical(this, other) ||
        other is CoverageString &&
            runtimeType == other.runtimeType &&
            equal(covered, other.covered) &&
            equal(partial, other.partial) &&
            equal(uncovered, other.uncovered);
  }

  @override
  int get hashCode => covered.hashCode ^ partial.hashCode ^ uncovered.hashCode;

  factory CoverageString.fromString(String coverage) {
    List<String> split = coverage.split(";");
    Map<String, List<int>> lineMap = split
        .asMap()
        .map((_, String value) => MapEntry<String, List<int>>(_type(value), _lineNumbers(value)));

    return CoverageString(covered: lineMap["C"], partial: lineMap["P"], uncovered: lineMap["U"]);
  }

  static String _type(String value) => value.substring(0, 1);

  static Iterable<int> _lineNumbers(String value) => value
      .substring(2)
      .split(",")
      .where((String lineNumberString) => lineNumberString.isNotEmpty)
      .map((String lineNumberString) => int.parse(lineNumberString))
      .toList();
}

class CoverageStringConverter implements JsonConverter<CoverageString, String> {
  const CoverageStringConverter();

  @override
  CoverageString fromJson(String json) => CoverageString.fromString(json);

  @override
  String toJson(CoverageString object) => object?.format();
}
