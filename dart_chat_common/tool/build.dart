// Copyright (c) 2017, Stéphane Este-Gracias. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:build_runner/build_runner.dart';

import 'build_actions.dart';


main() async {
  var result = await build(buildActions, deleteFilesByDefault: true);
  if (result.status == BuildStatus.failure) {
    exitCode = 1;
  }
}