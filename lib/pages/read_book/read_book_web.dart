

import 'package:universal_io/io.dart';

import 'package:cambrio/pages/read_book/read_book.dart';
import 'package:flutter/material.dart';

ReadBook getManager() => ReadBookWeb();
class ReadBookWeb extends ReadBook {
  @override
  Future<Map<String, String>> readBook(BuildContext context, {required File file, Map<String,dynamic>? bookmark}) {
    throw UnimplementedError();
  }

}