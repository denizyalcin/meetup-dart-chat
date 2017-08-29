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
  TextEditingController _textController = new TextEditingController();
  bool _isComposing = false;

  ChatUser get user => _chatService?.user;
  Map<String, ChatUser> get users => _chatService?.users;
  List<ChatMessage> get messages => _chatService.messages;
  void sendMessage(String text) => _chatService?.sendMessage(text);

  _ChatMessagesState(this._chatService) {
    _chatService.onMessage = (message) {
      this.setState(() => null);
    };
  }

  void _handleMessageChanged(String text) {
    setState(() {
      _isComposing = text.trim().isNotEmpty;
    });
  }

  void _handleSubmitted(String text) {
    _textController.clear();
    setState(() {
      _isComposing = false;
    });
    sendMessage(text);
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
    return new Column(children: [
      new Flexible(
          child: new ListView.builder(
        padding: new EdgeInsets.all(8.0),
        itemBuilder: (_, int index) => new ChatMessageListItem(_chatService, messages[index]),
        itemCount: messages.length,
      )),
      new Divider(
        height: 1.0,
      ),
      new Container(
        decoration: new BoxDecoration(color: Theme.of(context).cardColor),
        child: _buildTextComposer(),
      ),
    ]);
  }
}

class ChatMessageListItem extends StatelessWidget {
  final ChatService chatService;
  final ChatMessage message;

  ChatUser get user => chatService?.users[message.userId];

  ChatMessageListItem(this.chatService, this.message);

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
                  user?.username,
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
