// Copyright 2017, the Flutter project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/io.dart';

import 'package:dart_chat_common/client.dart';
import 'package:dart_chat_common/shared.dart';

final _log = new Logger('flutter');

var config = new ClientConfig()
  ..apiUrl = 'http://192.168.100.10:8080'
  ..wsUrl = 'ws://192.168.100.10:8080'
  ..username = defaultTargetPlatform == TargetPlatform.iOS ? 'charlie' : 'dan'
  ..password = defaultTargetPlatform == TargetPlatform.iOS ? 'charliepass' : 'danpass';

ChatService service;

void main() {
  runApp(new DartChatApp());
}

class DartChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Dart Chat',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  State createState() => new ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> with TickerProviderStateMixin {
  List<ChatMessage> _messages = [];
  TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  @override
  void initState() {
    super.initState();

    service ??= new ChatService(
      new IOClient(),
      (url) => new IOWebSocketChannel.connect(url),
      config.apiUrl,
      config.wsUrl,
    );
    service.login(config.username, config.password).then((user) {
      if (user == null) {
        _log.shout("Wrong credentials");
        // TODO Pop-up message
      }
    });

    service.onMessage = (message) => _addMessage(message);
  }

  void _handleMessageChanged(String text) {
    setState(() {
      _isComposing = text.trim().isNotEmpty;
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    service.sendMessage(text);
  }

  void _addMessage(ChatMessage message) {
    setState(() {
      _messages.insert(0, message);
    });
  }

  Widget _buildTextComposer() {
    return new IconTheme(
        data: new IconThemeData(color: Theme.of(context).accentColor),
        child: new Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: new Row(children: [
              new Flexible(
                child: new TextField(
                  controller: _textController,
                  onSubmitted: _handleSubmitted,
                  onChanged: _handleMessageChanged,
                  decoration: new InputDecoration.collapsed(hintText: 'Send a message'),
                ),
              ),
              new Container(
                  margin: new EdgeInsets.symmetric(horizontal: 4.0),
                  child: new IconButton(
                    icon: new Icon(Icons.send),
                    onPressed: _isComposing ? () => _handleSubmitted(_textController.text) : null,
                  )),
            ])));
  }

  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Dart Chat'),
        ),
        body: new Column(children: [
          new Flexible(
              child: new ListView.builder(
            padding: new EdgeInsets.all(8.0),
            reverse: true,
            itemBuilder: (_, int index) => new ChatMessageListItem(_messages[index]),
            itemCount: _messages.length,
          )),
          new Divider(
            height: 1.0,
          ),
          new Container(
            decoration: new BoxDecoration(color: Theme.of(context).cardColor),
            child: _buildTextComposer(),
          ),
        ]));
  }
}

class ChatMessageListItem extends StatelessWidget {
  ChatMessageListItem(this.message);

  final ChatMessage message;

  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            new Container(
              margin: const EdgeInsets.only(right: 16.0),
              child: new Icon(Icons.person),
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                new Text(
                  service?.users[message.userId]?.username,
                  style: new TextStyle(fontWeight: FontWeight.bold),
                ),
                new Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: new Text(message.text),
                ),
              ],
            ),
          ],
        ));
  }
}
