// Copyright (c) 2017, Stéphane Este-Gracias. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_components/angular_components.dart';

import 'package:dart_chat_webdev/services.dart';

import 'package:dart_chat_common/shared.dart';

@Component(
  selector: 'app-header',
  directives: const [
    COMMON_DIRECTIVES,
    formDirectives,
    MaterialButtonComponent,
    MaterialFabComponent,
    MaterialIconComponent,
  ],
  templateUrl: 'app_header.html',
  styleUrls: const ['app_header.css'],
)
class AppHeader {
  final AngularChatService _apiService;

  String username = 'alice';
  String password = 'alicepass';

  ChatUser get user => _apiService?.user;
  String get avatar => _apiService?.user?.avatar ?? "user.png";

  AppHeader(this._apiService);

  Future<Null> login() async => _apiService.login(username, password);
  void logout() => _apiService.logout();
}
