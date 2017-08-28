// Copyright (c) 2017, Stéphane Este-Gracias. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:dart_chat_common/shared.dart';

import 'package:dart_chat_webdev/services.dart';

import '../app_header/app_header.dart';
import '../../directives/vu_hold_focus.dart';
import '../../directives/vu_scroll_down.dart';

@Component(
  selector: 'dart-chat-app',
  templateUrl: 'app_component.html',
  directives: const [
    COMMON_DIRECTIVES,
    formDirectives,
    AppHeader,
    VuScrollDown,
    VuHoldFocus,
  ],
  providers: const [AngularChatService],
  pipes: const [COMMON_PIPES],
  styleUrls: const ['app_component.css'],
)
class AppComponent {
  final AngularChatService _chatService;

  String inputText = "";

  ChatUser get user => _chatService?.user;
  List<ChatMessage> get messages => _chatService?.messages;

  AppComponent(this._chatService);

  ChatUser getChatUser(String id) => _chatService?.users[id];
  String getAvatar(String id) => _chatService?.users[id]?.avatar ?? "user.png";

  void sendTextMessage() {
    if (inputText.trim().isNotEmpty) {
      _chatService.sendMessage(inputText);
      inputText = "";
    }
  }
}
