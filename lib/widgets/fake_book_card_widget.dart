import 'package:beamer/beamer.dart';
import 'package:cambrio/models/book.dart';
import 'package:cambrio/pages/book_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pages/edit_chapter.dart';
import '../services/make_epub.dart';

class FakeBookCard extends StatelessWidget {
  final String title;
  // final Map<String,dynamic> chapters;
  // final String bookId;

    const FakeBookCard({Key? key, required this.title}) : super(key: key);

    @override
    Widget build(BuildContext context) {

    return ConstrainedBox(
      constraints: BoxConstraints.loose(Size(125,150 + 2*14*MediaQuery.of(context).textScaleFactor*1.2)),
      child: GestureDetector(
        onTap: () {
          Beamer.of(context).beamToReplacementNamed('/explore', stacked: false);
          // Beamer.of(context).update(
          //   configuration: const RouteInformation(
          //     location: '/explore'
          //   ),
          //   rebuild: true,
          // );
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
                    color: Colors.black.withOpacity(0.3),
                   //  image: DecorationImage(
                   //    image: NetworkImage('https://firebasestorage.googleapis.com/v0/b/cambio-46fdc.appspot.com/o/cambrio-cover2-01.png?alt=media&token=64240a30-a53e-4a1f-8630-de1bac56975a'),
                   //    fit: BoxFit.cover,
                   //  )
                  ),
                  margin: const EdgeInsets.only(top: 8),
                  alignment: Alignment.topCenter,
                  child: const Center(child: Icon(Icons.search,semanticLabel: 'go to search',)),
              ),
              const SizedBox(height: 2), // Spacing between book tile and text
              Container(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SizedBox(
                width: 100,
                  height: 2*14*MediaQuery.of(context).textScaleFactor*1.2,
                  //align text better with book margins
                  child: Text(title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14, height: 1.2),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis)),
              )]),
      ),
    );
  }
}
