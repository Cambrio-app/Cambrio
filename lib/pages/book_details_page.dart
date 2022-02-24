// import 'dart:html';

import 'package:cambrio/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:html/parser.dart' as htmlparser;
// import 'package:html/dom.dart' as dom;
// import 'package:flutter_html/flutter_html.dart';
import '../services/make_epub.dart';


import '../models/book.dart';
import '../models/chapter.dart';

class BookDetailsPage extends StatefulWidget {
  final DocumentSnapshot<Book> bookSnap;

  const BookDetailsPage({Key? key, required this.bookSnap}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  List<Chapter> chapters = [
    const Chapter(
        chapter_id: null, chapter_name: 'loading', text: '<span style="padding-top:40px"><pre>\n\n... loading ...\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nloadiing\n\n\n\n\n\n\n\n\n</pre></span>', order: 0)
  ];
  int selected = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<List<Chapter>>(
            future: FirebaseService().getChapters(widget.bookSnap.id),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                chapters = snapshot.data!;

              }
              return ListView(
                physics: BouncingScrollPhysics(),
                controller: ScrollController(initialScrollOffset: MediaQuery.of(context).size.height*0.35),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: NetworkImage(widget.bookSnap.data()?.imageURL ??
                            'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/7674aee8-a93d-4e4a-8a60-456b3770bbba/d7jk6bp-9e915b66-3e89-4e4f-99bc-b43dd8245355.jpg/v1/fill/w_746,h_1071,q_70,strp/vintage_ornamental_book_cover_by_boldfrontiers_d7jk6bp-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTI5MSIsInBhdGgiOiJcL2ZcLzc2NzRhZWU4LWE5M2QtNGU0YS04YTYwLTQ1NmIzNzcwYmJiYVwvZDdqazZicC05ZTkxNWI2Ni0zZTg5LTRlNGYtOTliYy1iNDNkZDgyNDUzNTUuanBnIiwid2lkdGgiOiI8PTkwMCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.mwO9qA8W8-XIF_ifzkAI6YD54OBknB9slDFYY08mzyY'),
                        fit: BoxFit.cover,
                      )),
                      height: MediaQuery.of(context).size.height * 0.7,
                      width: MediaQuery.of(context).size.width,
                    ),
                  ),
                  buildName(),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(child: ExpandableWidget(context)),
                  ),
                  buildDescription(),
                ],
              );
            }));
  }

  Widget buildName() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            widget.bookSnap.data()!.title,
            style: const TextStyle(
              fontSize: 23,
              color: Colors.black,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.1,
              fontFamily: "Unna",
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.person,
                color: Colors.black,
                size: 14,
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                widget.bookSnap.data()!.author_name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: "Montserrat-Semibold",
                ),
              ),
            ],
          ),
        ],
      );

  Widget buildDescription() => SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(
                height: 4,
              ),
              Text(
                widget.bookSnap.data()?.description ?? 'no description',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Montserrat-Semibold",
                ),
                softWrap: true,
              ),
              // Html(data:chapters[selected].text),
              const SizedBox(
                height: 40,
              ),
              // Text(
              //   chapters[selected].text,
              //   style: const TextStyle(
              //     fontSize: 15,
              //     fontWeight: FontWeight.normal,
              //     fontFamily: "Montserrat-Semibold",
              //   ),
              // )
            ],
          ),
        ),
      );

  // Widget TableOfContentDropDownButton() => Container(
  //       color: Colors.black,
  //       height: 40,
  //       padding: const EdgeInsets.only(bottom: 2, right: 2),
  //       child: MaterialButton(
  //         minWidth: MediaQuery.of(context).size.width,
  //         height: 40,
  //         onPressed: () {},
  //         color: Colors.white,
  //         elevation: 0,
  //         shape: const RoundedRectangleBorder(
  //           side: BorderSide(
  //             color: Colors.black,
  //             width: 2,
  //             style: BorderStyle.solid,
  //           ),
  //         ),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: const [
  //             Text(
  //               "Table of Contents",
  //               style: TextStyle(
  //                 fontWeight: FontWeight.w600,
  //                 fontSize: 14,
  //                 fontFamily: "Montserrat-Semibold",
  //               ),
  //             ),
  //             Spacer(),
  //             Icon(
  //               Icons.arrow_drop_down,
  //               color: Colors.black,
  //               size: 20,
  //             ),
  //           ],
  //         ),
  //       ),
  //     );

  Widget ExpandableWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ExpansionTile(
        // key: Key(selected.toString()),
        title: const Text(
          "Table of Contents",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.normal,
            color: Colors.black,
            fontFamily: "Montserrat-Semibold",
          ),
        ),
        expandedCrossAxisAlignment: CrossAxisAlignment.center,
        initiallyExpanded: false,

        children: () {
          List<Widget> widgets = [];
          for (int i=0; i<chapters.length; i++) {
            widgets.add(
                const Divider()
            );
            widgets.add(ListTile(
              title: Text(
                chapters[i].chapter_name,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.normal,
                  color: Colors.black,
                  fontFamily: "Montserrat-Semibold",
                ),
              ),
              onTap: () {
                final MakeEpub epubber = MakeEpub(title: widget.bookSnap.data()!.title, authorName: widget.bookSnap.data()!.author_name, authorId: widget.bookSnap.data()!.author_id ?? 'wat', bookId:widget.bookSnap.id);
                epubber.makeEpub(context, location: i);
                // setState(() {
                //   selected = i;
                // });
              },

            ));
          }
          return widgets;
        }.call(),
      ),
    );
  }
}
