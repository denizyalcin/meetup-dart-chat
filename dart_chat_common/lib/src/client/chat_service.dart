// Copyright (c) 2017, Stéphane Este-Gracias. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:http/http.dart';
import 'package:logging/logging.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'package:dart_chat_common/client.dart';
import 'package:dart_chat_common/shared.dart';

final Logger _log = new Logger("client.chat_service");

typedef WebSocketChannel WebsocketBuilder(String url);

class ChatService {
  final BaseClient client;
  final String apiUrl;
  final String wsUrl;
  final WebsocketBuilder wsBuilder;
  ChatMessageHook onMessage;

  String get _wsEndpoint => "$wsUrl/ws";

  ChatApi _chatApi;
  WebsocketManagerClient _wsClient;
  WebSocketChannel _channel;

  ChatUser user;
  List<ChatMessage> messages = <ChatMessage>[];
  Map<String,ChatUser> users = <String,ChatUser>{};

  ChatService(this.client, this.wsBuilder, this.apiUrl, this.wsUrl, {this.onMessage}) {
    _chatApi = new ChatApi(client, apiUrl);
  }

  Future<ChatUser> login(String username, String password) async {
    var token = await _chatApi.authUser(username, password);
    var tokenData = new AuthTokenCodec().decode(token.token, withValidation: false);
    user = await getChatUser(tokenData.userId);

    if (user != null) {
      _channel = wsBuilder(_wsEndpoint);
      _wsClient = new WebsocketManagerClient(_channel, token, (ChatMessage message) async {
        await getChatUser(message.userId);
        messages.add(message);
        if (onMessage != null) {
          onMessage(message);
        }
      });
    }

    return user;
  }

  Future<Null> logout() async {
    user = null;
  }

  FutureOr<ChatUser> getChatUser(String id) async {
    if (users.containsKey(id)) {
      return users[id];
    } else {
      var user = await _chatApi.getChatUser(id);
      users[user.id] = user;
      return user;
    }
  }

  void sendMessage(String text) {
    _wsClient.broadcastObject(_channel, new ChatMessage()
      ..userId = user.id
      ..text = text);
  }
}
