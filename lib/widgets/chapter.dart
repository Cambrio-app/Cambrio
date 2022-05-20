import 'package:cambrio/pages/book_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/chapter.dart';
import 'package:intl/intl.dart';

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
        DateTime? date = chapter.time_written?.toDate();

        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              if (snapshot.hasData) GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => BookDetailsPage(bookSnap: snapshot.data!, open: true,)));
                    },
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 600,
                    minHeight: 65,
                  ),
                  child: Container(
                      width: 0.85*MediaQuery.of(context).size.width,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(10, 7, 7, 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(chapter.chapter_name,
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 24, fontFamily: "Unna"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2,),
                            Text("${snapshot.data!.data()!.title}  |  ${(date!=null)?DateFormat('EEEE, MMMM d').format(date):'?'}",
                                textAlign: TextAlign.left,
                                style: const TextStyle(fontSize: 14, fontFamily: "Montserrat"),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
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
                      alignment: Alignment.topLeft
                  ),
                ),
              ),
            ]);
      }
    );
  }
}
