import 'package:flutter/material.dart';

import 'package:dart_chat_common/client.dart';
import 'package:dart_chat_common/shared.dart';

class ChatMessages extends StatefulWidget {
  final ChatService _chatService;

  ChatMessages(this._chatService);

  @override
  State createState() => new _ChatMessagesState(_chatService);
}

class _ChatMessagesState extends State<ChatMessages> {
  final ChatService _chatService;

  ChatUser get user => _chatService?.user;
  Map<String,ChatUser> get users => _chatService?.users;
  List<ChatMessage> get messages => _chatService.messages;

  _ChatMessagesState(this._chatService) {
    _chatService.onMessage = (message) {
      this.setState(() => null);
    };
  }

  void sendMessage(String text) => _chatService?.sendMessage(text);

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: <Widget>[
        new Flexible(
          child: messages.isEmpty
              ? new Text('Nobody has said anything yet... Break the silence!')
              : new ListView.builder(
              itemCount: messages.length,
              itemBuilder: (_, int i) {
                return new ListTile(
                  title: new Text(
                    users[messages[i].userId]?.username,
                    style: new TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: new Text(messages[i].text),
                );
              }),
        ),
        new Divider(height: 1.0),
        new Container(
          decoration: new BoxDecoration(color: Theme.of(context).cardColor),
          child: new Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0),
            child: new TextField(
              decoration: new InputDecoration(labelText: 'Send a message...'),
              onSubmitted: (String text) {
                if (text.trim().isNotEmpty) {
                  sendMessage(text);
                }
              },
            ),
          ),
        )
      ],
    );
  }
}
