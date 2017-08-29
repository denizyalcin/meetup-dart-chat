import 'package:args/args.dart';
import 'package:logging/logging.dart';

class ClientConfig {
  String apiUrl;
  String wsUrl;
  String username;
  String password;
  Level log;
}

ClientConfig loadConfig(List<String> args) {
  var parser = new ArgParser()
    ..addOption('host', abbr: 'h', defaultsTo: 'localhost')
    ..addOption('port', abbr: 'p', defaultsTo: '8080')
    ..addFlag('secure', abbr: 's', defaultsTo: false, negatable: false)
    ..addOption('username', abbr: 'U')
    ..addOption('password', abbr: 'P')
    ..addOption('log', abbr: 'l', help: 'Log level', defaultsTo: 'INFO')
    ..addFlag('help');

  // Parse command line arguments
  var results = parser.parse(args);
  if (results['help'] == true) {
    print(parser.usage);
    return null;
  }
  var host = results['host'];
  var port = results['port'];
  var secure = results['secure'];

  return new ClientConfig()
    ..apiUrl = "${secure ? 'https' : 'http'}://${host}:${port}"
    ..wsUrl = "${secure ? 'wss' : 'ws'}://${host}:${port}"
    ..username = results['username']
    ..password = results['password']
    ..log = Logger.root.level = Level.LEVELS.firstWhere(
        (level) => level.name == results['log'],
        orElse: () => Level.ALL);
}
