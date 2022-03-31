import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/widgets/book_list_view.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

class LibraryPage extends StatelessWidget {
  const LibraryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    // report to analytics that the user went to this page
    FirebaseAnalytics.instance
        .setCurrentScreen(
        screenName: 'Library'
    );
    // return Column(
    //   mainAxisSize: MainAxisSize.min,
    return ListView(

      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      children: const [
        // BookListView(collectionToPull: 'books', collectionTitle: "Books We Know You'll Hate", queryType: QueryTypes.hated),
        BookListView(collectionToPull: 'books', collectionTitle: "Subscriptions", queryType: QueryTypes.subscribed),
        BookListView(collectionToPull: 'books', collectionTitle: "Liked Books", queryType: QueryTypes.saved),
        // BookListView(collectionToPull: 'books', collectionTitle: "Randomly Recommended", queryType: QueryTypes.random),
        BookListView(collectionToPull: 'books', collectionTitle: "Popular Books", queryType: QueryTypes.loved),
        // BookListView(collectionToPull: 'books', collectionTitle: "Dr.userfill\$private. /.medical_information {//doctorLastName} Prescribed These Books", queryType: QueryTypes.random),
      ],
    );
  }
}
