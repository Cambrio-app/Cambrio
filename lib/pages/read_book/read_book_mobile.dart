import 'package:beamer/beamer.dart';
import 'package:universal_io/io.dart';

import 'package:cambrio/pages/read_book/read_book.dart';
import 'package:flutter/material.dart';
import 'package:iridium_reader_widget/views/viewers/epub_screen.dart';

ReadBook getManager() => ReadBookMobile();

class ReadBookMobile extends ReadBook {
  @override
  Future<Map<String, String>> readBook(BuildContext context,
      {required File file, Map<String, dynamic>? bookmark}) async {
    Widget screen = EpubScreen.fromPath(
      filePath: file.path,
      location: bookmark?['location'],
      settings: bookmark?['settings'],
      theme: bookmark?['theme'],
    );

    MaterialPageRoute route = MaterialPageRoute(builder: (context) => screen);
    PageRoute betterroute = PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 1250),
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Interval(0.75, 1, curve: Curves.ease);

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );

    // await Future.delayed(const Duration(milliseconds:2000));
    // return Beamer.of(context).beamToNamed('/ereader', data: screen) as Map<String,String>;
    return await Navigator.push(context, betterroute) as Map<String, String>;
  }
}
