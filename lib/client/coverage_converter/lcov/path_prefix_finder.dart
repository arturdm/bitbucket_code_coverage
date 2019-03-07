import 'dart:async';
import 'dart:io';

import 'package:path/path.dart' as p;

class PathPrefixFinder {
  const PathPrefixFinder();

  Future<String> findPrefix(String root, String lcovPath, String sourceFilePath) {
    Directory lcovDirectory = File(lcovPath).parent;

    return _parentPathsUntil(lcovDirectory, Directory(root))
        .firstWhere((FileSystemEntity entity) => existsSync(entity, sourceFilePath))
        .then((FileSystemEntity entity) => relative(entity, root))
        .catchError((_) => "");
  }

  String relative(FileSystemEntity entity, String root) => p.relative(entity.path, from: root);

  bool existsSync(FileSystemEntity entity, String sourceFilePath) =>
      File("${entity.path}/$sourceFilePath").existsSync();

  Stream<FileSystemEntity> _parentPathsUntil(Directory from, Directory to) async* {
    do {
      yield from;
      from = from.parent;
    } while (from.path != to.path && from.path != from.parent.path);
    yield from;
  }
}
