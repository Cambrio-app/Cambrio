import 'package:cambrio/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'dart:async';
// import 'dart:io';
import 'package:universal_io/io.dart';

import 'package:html/parser.dart'
    as html; // consider changing this to the dart xml package since it's actually for xml
import 'package:xml/xml.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:archive/archive.dart';

import '../models/chapter.dart';

import 'dart:convert' show utf8;

import '../pages/read_book/read_book.dart';

class MakeEpub {
  String title = 'wat';
  late List<Chapter> chapters;
  String language;
  String authorName;
  String bookId;
  String authorId;
  Map<String, dynamic>? bookmark;
  File? zipped;

  MakeEpub(
      {this.title = 'default title',
      required this.authorName,
      required this.authorId,
      required this.bookId,
      this.language = 'en',
      this.bookmark,
      List<Chapter>? chapters}) {
    chapters = chapters ?? <Chapter>[];
    makeEpub(bookmark: bookmark);
  }
  //this code should go here but I can't make an async constructor, so I'll have to refactor with a factory function later.
  // directory = (await Directory('${(await _filePath)}/$bookId').create())

  Future get _filePath async {
    // Application documents directory: /data/user/0/{package_name}/{app_name}
    // final applicationDirectory = await getApplicationDocumentsDirectory();
    // External storage directory: /storage/emulated/0
    // final externalDirectory = await getExternalStorageDirectory();
    // Application temporary directory: /data/user/0/{package_name}/cache
    final tempDirectory = Directory.systemTemp;
    return tempDirectory.path;
  }

  Future<ArchiveFile> _writeToFile(String file, String fileContents) async {
    // make or access the path to your new epub
    // final path = (await Directory('${(await _filePath)}/$bookId').create()).path;
    // Directory('$path/EPUB').create();
    // Directory('$path/META-INF').create();
    // debugPrint('$path');

    // access the file, create the directory if needed, and write to that file.
    // return (await File('$path/$file').create(recursive: true)).writeAsString(fileContents);
    InputStreamBase content = InputStream(utf8.encode(fileContents));
    return ArchiveFile.stream(file, content.length, content);
  }

  Future<String> _loadAsset(String path) async {
    // debugPrint(await rootBundle.toString());
    return await rootBundle.loadString(path);
  }

  Future<ArchiveFile> _generateOpf() async {
    const String specificFile = 'EPUB/package.opf';
    var document =
        XmlDocument.parse(await _loadAsset('assets/ex_epub/$specificFile'));
    document.findAllElements('dc:identifier').first.innerText = bookId;
    document.findAllElements('dc:title').first.innerText = title;
    document.findAllElements('dc:creator').first.innerText = authorName;
    document.findAllElements('dc:language').first.innerText = language;
    // debugPrint(document.outerXml);
    // debugPrint(document.rootElement.children[1].outerXml);

    // debugPrint(document.rootElement.getElement('manifest')!.outerXml);

    // go through all the chapters and add them to the spine and the manifest
    for (var i = 0; i < chapters.length; i++) {
      // write the manifest
      final builder = XmlBuilder();
      builder.element('item', nest: () {
        builder.attribute(
            'href', 'chapter${i + 1}.xhtml'); // i+1 so that we start on 1
        builder.attribute('id', 'ch${i + 1}');
        builder.attribute('media-type', "application/xhtml+xml");
      });
      document.rootElement
          .getElement('manifest')!
          .children
          .add(builder.buildFragment());

      // now write the spine
      final spineBuilder = XmlBuilder();
      spineBuilder.element('itemref', nest: () {
        spineBuilder.attribute('idref', 'ch${i + 1}');
      });
      document.rootElement
          .getElement('spine')!
          .children
          .add(spineBuilder.buildFragment());
    }
    // debugPrint(document.outerXml);
    // (get the file), construct a real directory if it's not made already, Write to file
    return await _writeToFile(specificFile, document.toXmlString());
  }

  Future<ArchiveFile> _generateNav() async {
    const String specificFile = 'EPUB/nav.xhtml';
    var document =
        XmlDocument.parse(await _loadAsset('assets/ex_epub/$specificFile'));
    document.findAllElements('title').first.innerText =
        '$title Table of Contents';
    // debugPrint(document.outerXml);
    // debugPrint(document.rootElement.children.toString());
    // go through all the chapters and add them to the table of contents
    for (var i = 0; i < chapters.length; i++) {
      // write the manifest
      final builder = XmlBuilder();
      builder.element('li', nest: () {
        builder.attribute('id', 'ch${i + 1}'); // i+1 so that we start on 1
        builder.element('a', nest: () {
          builder.attribute('href', 'chapter${i + 1}.xhtml');
          builder.text(chapters[i].chapter_name);
        });
      });
      document
          .findAllElements('ol')
          .first
          .children
          .add(builder.buildFragment());
    }
    // debugPrint(document.outerXml);
    // (get the file), construct a real directory if it's not made already, Write to file
    return await _writeToFile(specificFile, document.toXmlString());
  }

  Future<ArchiveFile> _generateContainer() async {
    const String specificFile = 'META-INF/container.xml';
    var document =
        XmlDocument.parse(await _loadAsset('assets/ex_epub/$specificFile'));
    // (get the file), construct a real directory if it's not made already, Write to file
    return await _writeToFile(specificFile, document.toXmlString());
  }

  Future<ArchiveFile> _generateCss() async {
    const String specificFile = 'EPUB/epubbooks.css';
    var pureText = await _loadAsset('assets/ex_epub/$specificFile');
    // debugPrint(pureText);

    // (get the file), construct a real directory if it's not made already, Write to file
    return await _writeToFile(specificFile, pureText);
  }

  Future<ArchiveFile> _generateMimetype() async {
    const String specificFile = 'mimetype';
    var pureText = await _loadAsset('assets/ex_epub/$specificFile');
    // (get the file), construct a real directory if it's not made already, Write to file
    return await _writeToFile(specificFile, pureText);
  }

  Future<ArchiveFile> _generateTitlePage() async {
    const String specificFile = 'EPUB/titlepage.xhtml';
    var document =
        XmlDocument.parse(await _loadAsset('assets/ex_epub/$specificFile'));
    document.findAllElements('h1').first.innerText = title;
    document.findAllElements('h2').first.innerText = 'by $authorName';
    document
        .findAllElements('body')
        .first
        .attributes
        .add(XmlAttribute(XmlName('class'), 'titlepage'));
    document
        .findAllElements('div')
        .first
        .attributes
        .add(XmlAttribute(XmlName('class'), 'titlepage'));
    // debugPrint(document.toXmlString());
    // (get the file), construct a real directory if it's not made already, Write to file
    return await _writeToFile(specificFile, document.toXmlString());
  }

  Future<List<ArchiveFile>> _generateChapters() async {
    // TODO: add pagelist, so that pages display properly in ereaders

    List<ArchiveFile> result = [];
    String template = 'EPUB/titlepage.xhtml';
    var returnfile = ArchiveFile.string(
        'assets/ex_epub/$template', 'this page should never show');
    for (var i = 0; i < chapters.length; i++) {
      String specificFile =
          'EPUB/chapter${i + 1}.xhtml'; // +1 to make the chapters start at 1
      var document =
          XmlDocument.parse(await _loadAsset('assets/ex_epub/$template'));
      // String chapterText = XmlDocumentFragment.parse(chapters[i].text, entityMapping: XmlDefaultEntityMapping.html()).innerXml;

      // TODO: Find a better way to get rid of or fix tags that don't self-close. This is happening because html allows, but xhtml doesn't allow tags that don't close.
      var parse = html.parse(chapters[i].text);
      parse.getElementsByTagName('br').forEach((element) {
        element.remove();
      });
      parse.getElementsByTagName('col').forEach((element) {
        element.remove();
      });
      parse.getElementsByTagName('img').forEach((element) {
        element.remove();
      });

      var innerHtml2 = parse;
      String chapterText = innerHtml2.body!.innerHtml;
      // debugPrint(chapterText);
      chapterText = XmlDocumentFragment.parse(chapterText,
              entityMapping: const XmlDefaultEntityMapping.html5())
          .innerXml;
      //
      document.findAllElements('div').first.innerXml = chapterText;
      // debugPrint("ya doc, fren: ${chapterText}");
      // debugPrint("ya full, fren: ${document.toXmlString(entityMapping: XmlDefaultEntityMapping.xml())}");

      // debugPrint(specificFile);
      // (get the file), construct a real directory if it's not made already, Write to file
      returnfile = await _writeToFile(specificFile,
          document.toXmlString(entityMapping: const XmlDefaultEntityMapping.xml()));
      result.add(returnfile);
      // returnfile = await _writeToFile(specificFile, chapterText);
    }
    return result;
  }

  void addChapter(String id, String name, String text, int order) {
    chapters.add(Chapter(
        chapter_id: id,
        chapter_name: name,
        text: text,
        order: order,
        book_id: '??',
        time_written: null));
  }

  void makeEpub({int? location, Map<String, dynamic>? bookmark}) async {
    // pull up the path to where the temporary epub will go
    // final path = await _extFile;

    chapters = await FirebaseService().getChapters(bookId);
    // for web, it may be possible to simply pass the files directly from each of these functions, and we can avoid needing dart:io.
    Archive archive = Archive();
    archive.addFile(await _generateOpf());
    archive.addFile(await _generateNav());
    archive.addFile(await _generateContainer());
    archive.addFile(await _generateMimetype());
    archive.addFile(await _generateTitlePage());
    for (ArchiveFile archiveFile in await _generateChapters()) {
      archive.addFile(archiveFile);
    }
    archive.addFile(await _generateCss());

    var encoder = ZipEncoder();
    List<int> zippedList = encoder.encode(archive) ?? [];
    // debugPrint('${(await _generateCss()).path} and whatever');
    // Zip a directory to out.zip using the zipDirectory convenience method

    File('${(await _filePath)}/$bookId.epub').writeAsBytesSync(zippedList);
    zipped = File('${(await _filePath)}/$bookId.epub');
    // encoder.zipDirectory(Directory('${(await _filePath)}/$bookId'), filename: '${(await _filePath)}/$bookId.epub');

    // await for (var entity in
    // Directory('${(await _filePath)}').list(recursive: true, followLinks: false)) {
    //   print(entity.path);
    // }
    // String filepath = '${(await _filePath)}/$bookId.epub';
    // File zippedFile = File(filepath);
    //share the file
    // debugPrint(await modifiedFile.readAsString());
    // print(modifiedFile.path);
    // debugPrint(Directory('${(await _filePath)}/goodbook').listSync().toString());
    // Share.shareFiles([file.path]);  // method that is very useful for testing, and perhaps essential for future feature.
    // Stream<PaginationInfo> locationStream;
  }

  Future<Map<String, String>> openEpub(BuildContext context, {Map<String, dynamic>? bookmark}) async {
    debugPrint('getting: $bookmark');
    Map<String, String> lastLocation = await ReadBook.instance
        .readBook(context, file: zipped!, bookmark: bookmark ?? this.bookmark); //error occurs because zipped isn't ready yet
    return lastLocation;
  }

  // this version is for if it's necessary to use the html parser instead of the xml parser.
  // Future<File> make_epub() async{
  //   debugPrint("it is beginning");
  //   var document = parse(
  //       '''<?xml version="1.0" encoding="UTF-8"?>
  //   <package xmlns="http://www.idpf.org/2007/opf" version="3.0" unique-identifier="uid">
  //   <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
  //   <dc:identifier id="uid">totallyuniqueidentifierrighthere</dc:identifier>
  //   <dc:title>wonderful title of my beautiful book</dc:title>
  //   <dc:creator>Jaden</dc:creator>
  //   <dc:language>en</dc:language>
  //   <meta property="dcterms:modified">2012-02-27T16:38:35Z</meta>
  //   </metadata>
  //   <manifest>
  //   <item href="titlepage.xhtml" id="ttl" media-type="application/xhtml+xml"/>
  //   <item href="nav.xhtml" id="nav" media-type="application/xhtml+xml" properties="nav"/>
  //   </manifest>
  //   <spine>
  //   <itemref idref="ttl"/>
  //   <itemref idref="nav" linear="no"/>
  //   </spine>
  //   </package>
  //       ''');
  //   // print(document.outerHtml);    // debugPrint(_localPath);
  //   document.getElementsByTagName('dc\\:title')[0].text = 'ya boi';
  //   // document.findAllElements('dc:title').first.setAttribute('dc:title','wowowo');
  //   // print(document.getElementsByTagName('dc\\:title')[0].outerHtml);
  //   // print(document.findAllElements('dc:title'));
  //   final file = await _extFile;
  //   // Write the file
  //   // print(document.outerHtml);
  //   File modifiedFile = await file.writeAsString(document.body!.innerHtml);
  //   // File modifiedFile = await file.writeAsString(document.toXmlString());
  //   //share the file
  //   // print(await modifiedFile.readAsString());
  //   // print(await modifiedFile.readAsString());
  //   // print(modifiedFile.path);
  //   Share.shareFiles(['${modifiedFile.path}']);
  //   return modifiedFile;
  //   // return 'placeholder for file location';
  // }
}
