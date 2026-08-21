import 'dart:io';

import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// Selects sqflite's FFI backend for desktop operating systems.
void initializeDatabase() {
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
}
