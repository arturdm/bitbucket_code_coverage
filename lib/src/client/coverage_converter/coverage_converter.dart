import 'dart:async';
import 'dart:io';

import 'package:bitbucket_code_coverage/src/client/model/commit_coverage.dart';

abstract class CoverageConverter {
  Future<CommitCoverage> convert(File coverageFile);
}
