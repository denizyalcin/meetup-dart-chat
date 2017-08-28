// Copyright (c) 2017, Stéphane Este-Gracias. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:http/browser_client.dart';
import 'package:web_socket_channel/html.dart';

import 'package:dart_chat_common/client.dart';
import 'package:dart_chat_webdev/src/components/app_component/app_component.dart';

main() {
  bootstrap(AppComponent, [
    new Provider(ChatService,
        useValue: new ChatService(
          new BrowserClient(),
          (url) => new HtmlWebSocketChannel.connect(url),
          "http://localhost:8080",
          "ws://localhost:8080",
        )),
  ]);
}
