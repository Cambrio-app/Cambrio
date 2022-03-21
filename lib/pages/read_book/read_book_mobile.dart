

import 'package:universal_io/io.dart';

import 'package:cambrio/pages/read_book/read_book.dart';
import 'package:flutter/material.dart';
import 'package:iridium_reader_widget/views/viewers/epub_screen.dart';

ReadBook getManager() => ReadBookMobile();
class ReadBookMobile extends ReadBook {
  @override
  Future<Map<String, String>> readBook(BuildContext context, {required File file, Map<String,dynamic>? bookmark}) async {
    return (await Navigator.push(context, MaterialPageRoute(builder: (context) =>
        EpubScreen.fromPath(
          filePath: file.path,
          location: bookmark?['location'],
          settings: bookmark?['settings'],
          theme: bookmark?['theme'],
        )
    ))) as Map<String,String>;
  }

}