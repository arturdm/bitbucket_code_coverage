String lcov(List<String> paths) {
  return paths.map((String path) => fileCoverage(path)).join();
}

String fileCoverage(String path) {
  return """SF:$path
BRDA:2,0,0,-
BRF:1
BRH:1
DA:1,1
DA:2,1
DA:3,0
LF:3
LH:3
end_of_record
""";
}

String expectedCoverage() {
  return "C:1;P:2;U:3";
}
