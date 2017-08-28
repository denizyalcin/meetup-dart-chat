// Copyright (c) 2017, Stéphane Este-Gracias. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/io.dart';

import 'package:dart_chat_common/client.dart';
import 'package:dart_chat_common/shared.dart';

final _log = new Logger('client');

Future<Null> main(List<String> args) async {
  var config = loadConfig(args);
  if (config == null) {
    exit(1);
  }
  initLogging(config.log);

  // Read username & password
  var username = config.username;
  var password = config.password;
  if (username == null) {
    stdout.write("Username: ");
    username = stdin.readLineSync();
  }
  if (password == null) {
    stdout.write("Password: ");
    stdin.echoMode = false;
    password = stdin.readLineSync();
    stdin.echoMode = true;
    stdout.writeln();
  }

  // Create Chat Service.
  var service = new ChatService(
    new IOClient(),
    (url) => new IOWebSocketChannel.connect(url),
    config.apiUrl,
    config.wsUrl,
    onMessage: onMessage,
  );
  var user = await service.login(username, password);
  if (user == null) {
    stderr.writeln("Wrong credentials");
    exit(1);
  }

  // Listen on stdin
  stdin.transform(new Utf8Decoder()).transform(new LineSplitter()).listen(
    (String text) {
      if (text.trim().isNotEmpty) {
        service.sendMessage(text);
      }
    },
  );
}

// TODO Implement AnsiTerminal
void onMessage(ChatMessage message) {
  print(message.text);
}
