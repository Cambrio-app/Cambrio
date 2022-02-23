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
                  image: DecorationImage(
                    image: NetworkImage(bookSnap.data()?.imageURL ?? 'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/7674aee8-a93d-4e4a-8a60-456b3770bbba/d7jk6bp-9e915b66-3e89-4e4f-99bc-b43dd8245355.jpg/v1/fill/w_746,h_1071,q_70,strp/vintage_ornamental_book_cover_by_boldfrontiers_d7jk6bp-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTI5MSIsInBhdGgiOiJcL2ZcLzc2NzRhZWU4LWE5M2QtNGU0YS04YTYwLTQ1NmIzNzcwYmJiYVwvZDdqazZicC05ZTkxNWI2Ni0zZTg5LTRlNGYtOTliYy1iNDNkZDgyNDUzNTUuanBnIiwid2lkdGgiOiI8PTkwMCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.mwO9qA8W8-XIF_ifzkAI6YD54OBknB9slDFYY08mzyY'),
                    fit: BoxFit.cover,
                  )
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
        // final MakeEpub epubber = MakeEpub(title: bookSnap.data()!.title, authorName:'mmmm', authorId:'mm', bookId:bookSnap.id);

        // epubber.makeEpub(context);
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => BookDetailsPage(bookSnap: bookSnap,),
        ));
      },
      onLongPress: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EditChapter(book_id: bookSnap.id, num_chapters: bookSnap.data()!.num_chapters, )),
        );
      },

    );
  }
}
