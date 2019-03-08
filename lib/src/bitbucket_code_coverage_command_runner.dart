import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:logging/logging.dart';

import 'command/post/post_command.dart';

class BitbucketCodeCoverageCommandRunner extends CommandRunner<Null> {
  final Logger logger = Logger.root;

  BitbucketCodeCoverageCommandRunner()
      : super("bitbucket_code_coverage",
            "Converts and publishes coverage data to BitBucket server.") {
    argParser.addFlag("verbose",
        abbr: "v", negatable: false, help: "makes the output more verbose");
    argParser.addOption("url", help: "sets the Bitbucket server url, e.g. http://localhost:7990");
    argParser.addOption("username", abbr: "u", help: "sets the username for Bitbucket server");
    argParser.addOption("password", abbr: "p", help: "sets the user password for Bitbucket server");
    argParser.addOption("token",
        abbr: "t", help: "sets the Personal Access Token for Bitbucket server");
    addCommand(PostCommand());
  }

  @override
  FutureOr<Null> runCommand(ArgResults topLevelResults) {
    _configureLogger(topLevelResults);
    if (_argumentsAreValid(topLevelResults)) {
      return super.runCommand(topLevelResults);
    } else {
      return null;
    }
  }

  void _configureLogger(ArgResults topLevelResults) {
    bool verbose = topLevelResults["verbose"] as bool;
    logger.level = verbose ? Level.ALL : Level.WARNING;
  }

  bool _argumentsAreValid(ArgResults results) {
    if (results.command == null) return true;

    if (results["url"] == null) {
      usageException("""Use "--url" to point to your Bitbucket server.""");
      return false;
    }

    if (_tokenAndUsernameOrPasswordProvided(results) || _neitherTokenNorPasswordProvided(results)) {
      usageException("""Use either "--token" or "--username" with "--password".""");
      return false;
    }

    return true;
  }

  bool _tokenAndUsernameOrPasswordProvided(ArgResults results) =>
      results["token"] != null && (results["username"] != null || results["password"] != null);

  bool _neitherTokenNorPasswordProvided(ArgResults results) =>
      results["token"] == null && (results["username"] == null || results["password"] == null);
}
