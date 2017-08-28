// Copyright (c) 2017, Stéphane Este-Gracias. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:logging/logging.dart';
import 'package:logging_handlers/server_logging_handlers.dart';

// Initialize logger
initLogging(Level level) {
  hierarchicalLoggingEnabled = true;
  Logger.root.level = level;
  Logger.root.onRecord.listen(new LogPrintHandler());
}
