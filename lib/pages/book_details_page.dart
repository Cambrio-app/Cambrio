// import 'dart:html';

import 'dart:math';

import 'package:cambrio/pages/edit_book.dart';
import 'package:cambrio/pages/edit_chapter.dart';
import 'package:cambrio/pages/profile/author_profile_page.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/widgets/alert.dart';
import 'package:cambrio/widgets/back_arrow.dart';
import 'package:cambrio/widgets/shadow_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:html/parser.dart' as htmlparser;
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import '../models/user_profile.dart';
import '../services/make_epub.dart';

import '../models/book.dart';
import '../models/chapter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class BookDetailsPage extends StatefulWidget {
  DocumentSnapshot<Book> bookSnap;
  bool open;

  BookDetailsPage({Key? key, required this.bookSnap, this.open = false})
      : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  List<Chapter> chapters = [
    const Chapter(
        chapter_id: null,
        chapter_name: 'loading',
        text:
            '<span style="padding-top:40px"><pre>\n\n... loading ...\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nloadiing\n\n\n\n\n\n\n\n\n</pre></span>',
        order: 0,
        book_id: 'none',
        time_written: null)
  ];
  int? selected = null;
  bool clicked = false;
  MakeEpub? epubber;
  late final bool isUsersBook;
  late Map<String, dynamic> bookmark;
  ScrollController? scroll_controller;
  @override
  void initState() {
    super.initState();
    clicked = false;
    bookmark = {'location': '{"cfi":" ","idref":"ch${selected ?? 0 + 1}"}'};
    setBookmark().then((_) {
      epubber = MakeEpub(
        title: widget.bookSnap.data()!.title,
        authorName: widget.bookSnap.data()!.author_name,
        authorId: widget.bookSnap.data()!.author_id ?? 'wat',
        bookId: widget.bookSnap.id,
        bookmark: bookmark,
      );
    });

    isUsersBook = FirebaseService().userId == widget.bookSnap.data()?.author_id;

    // report to analytics that the user selected this content
    FirebaseAnalytics.instance.logSelectContent(
      contentType: 'book',
      itemId: widget.bookSnap.id,
    );
    // SchedulerBinding.instance!.addPostFrameCallback((_) {
    //   double offset = MediaQuery.of(context).size.height * 0.35;
    //   scroll_controller = ScrollController(initialScrollOffset:offset);
    // });
  }

  Future<Map<String, dynamic>> setBookmark() async {
    Map<String, dynamic>? newBookmark =
        await FirebaseService().getBookmark(bookId: widget.bookSnap.id);
    if (newBookmark != null) bookmark = newBookmark;
    debugPrint('bookmark retreived: $bookmark');
    return bookmark;
  }

  Future<void> goToEpub() async {
    clicked = true;

    if (clicked == true && !kIsWeb) {
      Future.delayed(const Duration(milliseconds: 100), () async {
        // open a book an retrieve the bookmark from it after.
        Map<String, String>? newBookmark = (await epubber?.openEpub(context, bookmark: bookmark));
        clicked = false;

        if (newBookmark != null) {
          selected = null;
          debugPrint("your last page: $newBookmark");
          FirebaseService().setBookmark(
            bookId: widget.bookSnap.id,
            location: newBookmark['location']!,
            settings: newBookmark['settings']!,
            theme: newBookmark['theme']!,
          );
          // update local bookmark
          bookmark = newBookmark;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // report to analytics that the user went to this page
    FirebaseAnalytics.instance.setCurrentScreen(screenName: 'BookDetails');

    // initialize late because it uses context
    scroll_controller ??= ScrollController(
        initialScrollOffset: MediaQuery.of(context).size.height * 0.35);

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            // maxHeight: 300,
            // minHeight: 200,
            maxWidth: 1000,
            minWidth: 200),
        child: BackArrow(
          child: Scaffold(
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.endFloat,
              floatingActionButton: isUsersBook
                  ? Padding(
                      padding: EdgeInsets.all(
                          MediaQuery.of(context).size.width * 0.02),
                      child: FloatingActionButton(
                        heroTag: 'add',
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        child: const Icon(Icons.add),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditChapter(
                                    book: widget.bookSnap.data()!,
                                    num_chapters: chapters.length,
                                  )),
                        ).then((value) {
                          setState(() {});
                        }),
                      ),
                    )
                  : null,
              body: FutureBuilder<List<Chapter>>(
                  future: FirebaseService().getChapters(widget.bookSnap.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData && snapshot.data != null) {
                      chapters = snapshot.data!;
                    }
                    return ListView(
                      physics: BouncingScrollPhysics(),
                      controller: scroll_controller,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // report to analytics that the user clicked the cover
                            FirebaseAnalytics.instance.logEvent(
                              name: "click_cover",
                            );

                            if (kIsWeb) {
                              Alert()
                                  .error(context,
                                      'The immersive reader is only available on the mobile app. Sorry!')
                                  .then((value) {
                                setState(() {
                                  selected = 0;
                                  scroll_controller!.jumpTo(800);
                                });
                              });
                            }
                            setState(() {
                              goToEpub();
                            });
                          },
                          child: Center(
                            child: AnimatedContainer(
                              width: clicked
                                  ? MediaQuery.of(context).size.width * 0.9
                                  : MediaQuery.of(context).size.width,
                              height: clicked
                                  ? MediaQuery.of(context).size.height * 0.6
                                  : MediaQuery.of(context).size.height * 0.7,
                              // color: clicked ? Colors.red : Colors.blue,
                              alignment: clicked
                                  ? Alignment.center
                                  : AlignmentDirectional.topCenter,
                              duration: const Duration(milliseconds: 1500),
                              curve: (clicked)
                                  ? Curves.easeOutExpo
                                  : Curves.easeOutExpo.flipped,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                image: NetworkImage(widget.bookSnap
                                        .data()
                                        ?.image_url ??
                                    'https://images-wixmp-ed30a86b8c4ca887773594c2.wixmp.com/f/7674aee8-a93d-4e4a-8a60-456b3770bbba/d7jk6bp-9e915b66-3e89-4e4f-99bc-b43dd8245355.jpg/v1/fill/w_746,h_1071,q_70,strp/vintage_ornamental_book_cover_by_boldfrontiers_d7jk6bp-pre.jpg?token=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ1cm46YXBwOjdlMGQxODg5ODIyNjQzNzNhNWYwZDQxNWVhMGQyNmUwIiwiaXNzIjoidXJuOmFwcDo3ZTBkMTg4OTgyMjY0MzczYTVmMGQ0MTVlYTBkMjZlMCIsIm9iaiI6W1t7ImhlaWdodCI6Ijw9MTI5MSIsInBhdGgiOiJcL2ZcLzc2NzRhZWU4LWE5M2QtNGU0YS04YTYwLTQ1NmIzNzcwYmJiYVwvZDdqazZicC05ZTkxNWI2Ni0zZTg5LTRlNGYtOTliYy1iNDNkZDgyNDUzNTUuanBnIiwid2lkdGgiOiI8PTkwMCJ9XV0sImF1ZCI6WyJ1cm46c2VydmljZTppbWFnZS5vcGVyYXRpb25zIl19.mwO9qA8W8-XIF_ifzkAI6YD54OBknB9slDFYY08mzyY'),
                                fit: BoxFit.fitHeight,
                              )),
                              onEnd: () {
                                setState(() {
                                  clicked = false;
                                });
                              },
                            ),
                          ),
                        ),
                        buildName(context),
                        // only show this widget if the book in question is written by this user.
                        if (isUsersBook)
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                            child: ShadowButton(
                                icon: Icons.edit,
                                text: 'Edit Book Details',
                                onclick: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditBook(
                                              bookSnap: widget.bookSnap,
                                            )),
                                  ).then((value) async {
                                    DocumentSnapshot<Book> newSnap =
                                        await widget.bookSnap.reference.get();
                                    setState(() {
                                      widget.bookSnap = newSnap;
                                    });
                                  });
                                }),
                          ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 15, 18, 0),
                          child: Container(child: ExpandableWidget(context)),
                        ),
                        buildDescription(context),
                      ],
                    );
                  })),
        ),
      ),
    );
  }

  Widget buildName(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 25,
          ),
          RichText(
            text: TextSpan(
              text: widget.bookSnap.data()!.title,
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  setState(() {
                    goToEpub();
                  });
                },
              style: const TextStyle(
                fontSize: 35,
                color: Colors.black,
                // fontWeight: FontWeight.w500,
                letterSpacing: 1.1,
                fontFamily: "Unna",
              ),
            ),
          ),
          // const SizedBox(
          //   height: 0,
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MaterialButton(
                padding: const EdgeInsets.all(0),
                onPressed: () async {
                  try {
                    String authorId = (widget.bookSnap.data()?.author_id)!;
                    UserProfile authorProfile =
                        (await FirebaseService().getProfile(uid: authorId))!;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AuthorProfilePage(
                                  profile: authorProfile,
                                )));
                  } on TypeError catch (e) {
                    debugPrint(e.toString());
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('this author never made a profile')));
                  }
                },
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        fontFamily: "Montserrat",
                      ),
                    ),
                  ],
                ),
              ),
              FutureBuilder<bool>(
                  future: FirebaseService().isLiked(widget.bookSnap.id),
                  builder: (context, snapshot) {
                    bool isLiked = (snapshot.data ?? false);
                    return IconButton(
                        iconSize: 24,
                        splashColor: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.3),
                        splashRadius: 200,
                        // constraints: BoxConstraints.loose(Size(30, 30)),
                        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                        onPressed: () {
                          debugPrint('liked/unliked');
                          FirebaseService()
                              .likeOrUnlike(widget.bookSnap.id, isLiked);
                          setState(() {});
                        },
                        icon: (isLiked)
                            ? Icon(
                                Icons.favorite,
                                color: Theme.of(context).colorScheme.primary,
                              )
                            : const Icon(Icons.favorite_border));
                  }),
            ],
          ),
        ],
      );

  Widget buildDescription(BuildContext context) {
    // debugPrint('selected: $selected');
    return SingleChildScrollView(
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
        child: Column(
          children: [
            if (kIsWeb)
              const Text(
                  'Download the Cambrio app for a better reading experience!'),
            const SizedBox(
              height: 4,
            ),

            if (selected == null)
              Text(
                widget.bookSnap.data()?.description ?? 'no description',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  fontFamily: "Montserrat",
                ),
                softWrap: true,
              ),

            if (selected != null && kIsWeb)
              Html(
                  key: ValueKey<int?>(selected),
                  data: chapters[selected!].text),

            const SizedBox(
              height: 40,
            ),
            // Text(
            //   chapters[selected].text,
            //   style: const TextStyle(
            //     fontSize: 15,
            //     fontWeight: FontWeight.normal,
            //     fontFamily: "Montserrat",
            //   ),
            // )
          ],
        ),
      ),
    );
  }

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
  //                 fontFamily: "Montserrat",
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
    return Container(
      decoration: BoxDecoration(
        border: Border.symmetric(
            horizontal:
                BorderSide(width: 0.75, color: Colors.black.withOpacity(0.55))),
      ),
      child: ExpansionTile(
        key: Key(selected.toString()),
        title: const Text(
          "Table of Contents",
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: Colors.black,
            fontFamily: "Montserrat",
          ),
        ),
        iconColor: Colors.black.withOpacity(0.55),
        expandedCrossAxisAlignment: CrossAxisAlignment.center,
        initiallyExpanded: widget.open,
        children: (BuildContext context) {
          List<Widget> widgets = [];
          for (int i = 0; i < chapters.length; i++) {
            widgets.add(const Divider());
            widgets.add(Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      chapters[i].chapter_name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.normal,
                        color: Colors.black,
                        fontFamily: "Montserrat",
                      ),
                    ),
                    onTap: () {
                      // if (!kIsWeb) epubber.makeEpub(context, location: i);

                      // report to analytics that the user clicked the chapter
                      FirebaseAnalytics.instance.logEvent(
                        name: "click_chapter",
                        parameters: {
                          'index': i,
                          'book_id': widget.bookSnap.id,
                        },
                      );

                      setState(() {
                        goToEpub();
                        selected = i;
                      });
                    },
                  ),
                ),
                if (FirebaseService().userId ==
                    widget.bookSnap.data()?.author_id)
                  IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EditChapter(
                                  book: widget.bookSnap.data()!,
                                  chapter: chapters[i],
                                  num_chapters: chapters.length)),
                        ).then((value) async {
                          DocumentSnapshot<Book> newSnap =
                              await widget.bookSnap.reference.get();

                          setState(() {
                            widget.bookSnap = newSnap;
                            // chapters = [
                            //   const Chapter(
                            //       chapter_id: null,
                            //       chapter_name: 'loading',
                            //       text:
                            //       '<span style="padding-top:40px"><pre>\n\n... loading ...\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\nloadiing\n\n\n\n\n\n\n\n\n</pre></span>',
                            //       order: 0)
                            // ];
                          });
                        });
                      },
                      icon: const Icon(Icons.edit)),
              ],
            ));
          }
          return widgets;
        }.call(context),
      ),
    );
  }
}
