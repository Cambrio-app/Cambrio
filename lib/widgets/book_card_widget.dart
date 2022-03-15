import 'package:cambrio/models/book.dart';
import 'package:cambrio/pages/book_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/edit_chapter.dart';
import '../services/make_epub.dart';

class BookCard extends StatelessWidget {
  // final String title;
  // final Map<String,dynamic> chapters;
  // final String bookId;

  final DocumentSnapshot<Book> bookSnap;
    const BookCard({Key? key, required this.bookSnap}) : super(key: key);

    @override
    Widget build(BuildContext context) {

    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(125,150 + 2*14*MediaQuery.of(context).textScaleFactor*1.2)),
      child: GestureDetector(
        onTap: () {
          // final MakeEpub epubber = MakeEpub(title: bookSnap.data()!.title, authorName:'mmmm', authorId:'mm', bookId:bookSnap.id);

          // epubber.makeEpub(context);
          Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => BookDetailsPage(bookSnap: bookSnap,),
          ));
        },
        onLongPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditChapter(book: bookSnap.data()!, num_chapters: bookSnap.data()!.num_chapters, )),
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
                      image: NetworkImage(bookSnap.data()?.image_url ?? 'https://firebasestorage.googleapis.com/v0/b/cambio-46fdc.appspot.com/o/cambrio-cover2-01.png?alt=media&token=64240a30-a53e-4a1f-8630-de1bac56975a'),
                      fit: BoxFit.cover,
                    )
                  ),
                  margin: const EdgeInsets.only(top: 8),
                  alignment: Alignment.topCenter),
              const SizedBox(height: 2), // Spacing between book tile and text
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                width: 100,
                  height: 2*14*MediaQuery.of(context).textScaleFactor*1.2,
                  //align text better with book margins
                  child: Text(bookSnap.data()!.title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis)),
              )]),
      ),
    );
  }
}
