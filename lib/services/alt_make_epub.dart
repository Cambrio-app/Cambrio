//
// import 'dart:html';
//
// import 'package:cambrio/models/book.dart';
// import 'package:cambrio/models/chapter.dart';
// import 'package:epub_viewer/epub_viewer.dart';
// import 'package:epubx/epubx.dart';
// import 'package:flutter/material.dart';
//
// import 'firebase_service.dart';
//
// class MakeEpub {
//   String title = 'wat';
//   late List<Chapter> chapters;
//   String language;
//   String authorName;
//   String bookId;
//   String authorId;
//
//   MakeEpub(
//       {this.title = 'default title', required this.authorName, required this.authorId, required this.bookId, this.language = 'en', List<
//           Chapter>? chapters}) :
//         chapters = chapters ?? <Chapter>[];
//
//   Future<File?>? makeEpub(BuildContext context, ) async {
//     // get the chapters from the database
//     chapters = await FirebaseService().getChapters(bookId);
//
//     EpubBook epub = EpubBook();
//     // final Book book = ;
//
//     epub.Author = 'mmmmm';
//     epub.Title = title;
//
//
//     // view the epub
//     EpubViewer.setConfig(
//         themeColor: Theme.of(context).primaryColor,
//         identifier: "iosBook",
//         scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
//         allowSharing: true,
//         enableTts: true,
//         nightMode: true);
//     // EpubViewer.open(zippedFile.path);
//
//     // return made;
//   }
//   }