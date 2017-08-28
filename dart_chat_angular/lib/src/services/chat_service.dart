// Copyright (c) 2017, Stéphane Este-Gracias. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';

import 'package:dart_chat_common/client.dart';
import 'package:dart_chat_common/shared.dart';

@Injectable()
class AngularChatService {
  final ChatService _chatService;

  ChatUser get user => _chatService?.user;
  List<ChatMessage> get messages => _chatService?.messages;
  Map<String,ChatUser> get users => _chatService?.users;

  AngularChatService(this._chatService);

  Future<ChatUser> login(String username, String password) => _chatService.login(username, password);
  Future<Null> logout() => _chatService.logout();
  void sendMessage(String text) => _chatService?.sendMessage(text);
}
