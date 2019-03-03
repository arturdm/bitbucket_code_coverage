import 'package:args/command_runner.dart';
import 'package:bitbucket_code_coverage/command/post/post_command.dart';

class BitbucketCodeCoverageCommandRunner extends CommandRunner<Null> {
  BitbucketCodeCoverageCommandRunner()
      : super("bitbucket_code_coverage",
            "Converts and publishes coverage data to BitBucket server.") {
    argParser.addFlag("verbose",
        abbr: "v", negatable: false, help: "makes the output more verbose");
    argParser.addOption("url", help: "sets the Bitbucket server url");
    argParser.addOption("username", abbr: "u", help: "sets the username for Bitbucket server");
    argParser.addOption("password", abbr: "p", help: "sets the user password for Bitbucket server");
    argParser.addOption("token",
        abbr: "t",
        help: "sets the token for Bitbucket server (takes precedence over username and password)");
    addCommand(PostCommand());
  }
}
