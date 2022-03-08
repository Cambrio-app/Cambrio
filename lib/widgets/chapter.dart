import 'package:cambrio/pages/book_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:cambrio/main.dart';

import '../models/book.dart';
import '../models/chapter.dart';

class ChapterWidget extends StatelessWidget {
  const ChapterWidget({Key? key, required this.chapter}) : super(key: key);
  final Chapter chapter;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Book>>(
      future: FirebaseFirestore.instance.collection('books').doc(chapter.book_id).withConverter<Book>(
        fromFirestore: (snapshot, _) =>
            Book.fromJson(snapshot.id, snapshot.data()!),
        toFirestore: (book, _) => book.toJson(),
      ).get(),
      builder: (context, snapshot) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              if (snapshot.hasData) GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookDetailsPage(bookSnap: snapshot.data!, open: true,)));
                    },
                child: Container(
                    width: 350.0,
                    height: 75.0,
                    child: Align(
                        alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Text(chapter.chapter_name,
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 18, fontFamily: "Unna"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2,),
                            Text("    ${snapshot.data!.data()!.title}",
                                textAlign: TextAlign.left,
                                style: TextStyle(fontSize: 11, fontFamily: "Unna"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      )),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      color: Colors.white,
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
              ),
            ]);
      }
    );
  }
}
