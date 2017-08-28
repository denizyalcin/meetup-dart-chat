// Copyright (c) 2017, Stéphane Este-Gracias. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:build_runner/build_runner.dart';

import 'build_actions.dart';

main() {
  watch(buildActions, deleteFilesByDefault: true);
}
