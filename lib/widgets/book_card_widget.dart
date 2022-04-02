import 'package:beamer/beamer.dart';
import 'package:cambrio/models/book.dart';
import 'package:cambrio/pages/book_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/edit_chapter.dart';
import '../services/make_epub.dart';
import '../util/numbers_display.dart';

class BookCard extends StatelessWidget {
  // final String title;
  // final Map<String,dynamic> chapters;
  // final String bookId;

  final DocumentSnapshot<Book> bookSnap;
  const BookCard({Key? key, required this.bookSnap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(
          125, 150 + 2 * 14 * MediaQuery.of(context).textScaleFactor * 1.2)),
      child: GestureDetector(
        onTap: () {
          // final MakeEpub epubber = MakeEpub(title: bookSnap.data()!.title, authorName:'mmmm', authorId:'mm', bookId:bookSnap.id);
          debugPrint(
              Beamer.of(context).currentBeamLocation.pathPatterns.toString());
          // epubber.makeEpub(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BookDetailsPage(
              bookSnap: bookSnap,
            ),
          ));
        },
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => EditChapter(
                      book: bookSnap.data()!,
                      num_chapters: bookSnap.data()!.num_chapters,
                    )),
          );
        },
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
                    borderRadius: BorderRadius.circular(5),
                    // borderRadius: BorderRadius.all(20),
                    image: DecorationImage(
                      image: NetworkImage(bookSnap.data()?.image_url ??
                          'https://firebasestorage.googleapis.com/v0/b/cambio-46fdc.appspot.com/o/cambrio-cover2-01.png?alt=media&token=64240a30-a53e-4a1f-8630-de1bac56975a'),
                      fit: BoxFit.cover,
                    )),
                margin: const EdgeInsets.only(top: 8),
                alignment: Alignment.topCenter),
            const SizedBox(height: 2), // Spacing between book tile and text
            Container(
              // color: Colors.green,
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: SizedBox(
                  width: 100,
                  height:  MediaQuery.of(context).textScaleFactor*(2 * 18 * 1.1 + 13 + 14 + 5),
                  //align text better with book margins
                  child: Column(
                    children: [
                      Text(bookSnap.data()!.title,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            height: 1.06,
                            fontFamily: 'Unna',
                            letterSpacing: 0.5,
                            color: Colors.black.withOpacity(0.75),

                          ),
                          // textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: true, applyHeightToLastDescent: true),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis),
                      Text(
                        bookSnap
                            .data()!
                            .author_name
                            .characters
                            .replaceAll(Characters(''), Characters('\u{200B}'))
                            .toString(),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.normal,
                          color: Colors.black,
                          fontFamily: "Montserrat",
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: false,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          (false) ?
                          Icon(Icons.favorite,
                              color: Theme.of(context).colorScheme.primary, size: 15):
                          const Icon(Icons.favorite_border,
                              color: Colors.black45, size: 15),
                          const SizedBox(width: 2),
                          Text(
                            compactify(bookSnap.data()!.likes),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: bookSnap.data()!.likes>99 ? FontWeight.bold:FontWeight.normal,
                              color: Colors.black.withOpacity(0.75),
                              fontFamily: "Montserrat",
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      )
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
  }
}
