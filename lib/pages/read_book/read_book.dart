

import 'package:flutter/material.dart';
import 'package:universal_io/io.dart';
import 'read_book_stub.dart'
if (dart.library.io) 'read_book_mobile.dart'
if (dart.library.js) 'read_book_web.dart';

abstract class ReadBook {
  static ReadBook? _instance;

  static ReadBook get instance {
    _instance ??= getManager();
    return _instance!;
  }

  Future<Map<String,String>> readBook(BuildContext context, {required File file, Map<String,dynamic>? bookmark});
}