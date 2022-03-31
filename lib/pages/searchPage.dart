import 'package:cambrio/pages/book_details_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:algolia/algolia.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../models/book.dart';
import '../services/firebase_service.dart';

class SearchingPage extends StatefulWidget {
  const SearchingPage({Key? key}) : super(key: key);

  @override
  State<SearchingPage> createState() => _SearchingPageState();
}

class _SearchingPageState extends State<SearchingPage> {
  TextEditingController _searchText = TextEditingController(text: "");
  /*
  The _results array will hold the data returned by Algolia and we will use this to generate a ListView.
  The _searching boolean will just be used to indicate if searching has completed or not.
  */

  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;
  Algolia algolia = Algolia.init(
    applicationId: '6M9DHL86F0',
    apiKey: '0a7b0ad97e703eac96130ec37b94b267',
  );
  _search() async {
    setState(() {
      _searching = true;
    });
    AlgoliaQuery query = algolia.instance.index(
        'books'); //Interesting how .instance is now working, yesterday it was not working :/

    query = query.search(_searchText.text);

    _results = (await query.getObjects()).hits;
    setState(() {
      _searching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    FirebaseRemoteConfig.instance.fetchAndActivate();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('route:');
    debugPrint(ModalRoute.of(context)?.settings.name);
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FadeInDown(
              child: Row(
                children: [
                  Text(
                    "Find your next read",
                    style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade800,
                        fontFamily: 'Unna',
                        height: 1.5),
                  )
                ],
              ),
            ),
            Container(
              height: 46,
              decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(8)),
              child: TextField(
                controller: _searchText,
                cursorColor: Colors.black,
                onChanged: FirebaseRemoteConfig.instance.getBool('auto_search')
                    ? (_) => _search()
                    : null,
                onEditingComplete: () {

                  // log the search
                  FirebaseAnalytics.instance.logSearch(searchTerm: _searchText.text);
                  _search();
                },
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade700,
                    ),
                    border: InputBorder.none,
                    hintText: "Search",
                    hintStyle: TextStyle(color: Colors.grey.shade500)),
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //IMPORTANT TO NOTE

                /*
                HANDLING HTTP CALLS

                Algolia being a REST API, for each character search
                it will call HTTPs request to the Algolia+firebase server
                on the backend, which means less response time and more calls.

                To solve this what i did is to tell the user to search after he/she
                is finished with the searching word.

                This will reduce the Character search time and will also reduce the number of calls made to the server.
                */

                FlatButton(
                    color: Colors.black,
                    child: Text(
                      "Search",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      FocusManager.instance.primaryFocus?.unfocus();

                      // log the search
                      FirebaseAnalytics.instance.logSearch(searchTerm: _searchText.text);
                      _search();
                    }),
              ],
            ),
            Expanded(
              child: _searching == true
                  ? Center(
                      child: Text("Searching, please wait..."),
                    )
                  : _results.length == 0
                      ? Center(
                          child: Text("No results found."),
                        )
                      : ListView.builder(
                          itemCount: _results.length,
                          itemBuilder: (BuildContext ctx, int index) {
                            AlgoliaObjectSnapshot snap = _results[index];
                            return ListTile(
                              leading: CircleAvatar(
                                child: Text(
                                  (index + 1).toString(),
                                ),
                                // child: Image.network(snap.data["imageURL"],),
                              ),
                              title: Text(snap.data["author_name"]),
                              subtitle: Text(snap.data["title"]),
                              onTap: () async {
                                DocumentSnapshot<Book> bookSnap =
                                    await FirebaseService()
                                        .getBook(book_id: snap.objectID);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          BookDetailsPage(bookSnap: bookSnap)),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
