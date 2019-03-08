import 'dart:async';

import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:bitbucket_code_coverage/command/post/post_command.dart';

class BitbucketCodeCoverageCommandRunner extends CommandRunner<Null> {
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
    if (topLevelResults["token"] != null &&
        (topLevelResults["username"] != null || topLevelResults["password"] != null)) {
      usageException(
          """Could not run with both "--token" and "--username" or "--password" provided.""");
      return null;
    } else {
      return super.runCommand(topLevelResults);
    }
  }
}
