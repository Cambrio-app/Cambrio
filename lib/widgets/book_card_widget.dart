import 'package:cambrio/models/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epub_viewer/epub_viewer.dart';
import 'package:flutter/material.dart';
import '../services/make_epub.dart';

class BookCard extends StatelessWidget {
  // final String title;
  // final Map<String,dynamic> chapters;
  // final String bookId;

  final DocumentSnapshot<Book> bookSnap;
  const BookCard({Key? key, required this.bookSnap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // margin: EdgeInsets.all(8),
            // mainAxisAlignment: MainAxisAlignment.end,
            Container(
                width: 100.0, //was 125
                height: 140.0, //was 170
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondaryVariant,
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black,
                      offset: Offset(
                        3, // Move to right 3  horizontally
                        3, // Move to bottom 3 Vertically
                      ),
                    )
                  ],
                ),
                padding: const EdgeInsets.all(0),
                alignment: Alignment.topCenter),
            const SizedBox(height: 2), // Spacing between book tile and text
            Container(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
              width: 100,
                //align text better with book margins
                child: Text(bookSnap.data()!.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis)),
            )]),
      onTap: () {
        // TODO: bookID right now the title but cleaned, but it needs to be the actual id.
        // final MakeEpub epubber = MakeEpub(title: bookSnap.data()!.title, authorName:'mmmm', authorId:'mm', bookId:bookSnap.data()!.title.replaceAll(RegExp(r"[^a-zA-Z0-9]"), ''));
        final MakeEpub epubber = MakeEpub(title: bookSnap.data()!.title, authorName:'mmmm', authorId:'mm', bookId:bookSnap.id);

        // epubber.addChapter('chapter 1', '<p>whatevs</p>');
        // epubber.addChapter('chapter 2', '<p>lots of goood stuff</p>');
        // epubber.addChapter('chapter tree', '<p>the end</p>');
        epubber.makeEpub(context);

        // EpubViewer.setConfig(
        //     themeColor: Theme.of(context).primaryColor,
        //     identifier: "iosBook",
        //     scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
        //     allowSharing: true,
        //     enableTts: true,
        //     nightMode: true);
        // EpubViewer.openAsset("assets/ex_epub)");
      },

    );
  }
}