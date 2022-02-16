import 'package:cloud_firestore/cloud_firestore.dart';
// TODO: get away from firestore_search. It's not scalable.
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key, }) : super(key: key);

  List<dynamic> bookListFromSnapshot(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((snapshot) => Book.fromJson(snapshot.id, snapshot.data() as Map<String,Object?>)).toList();
  }
  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        FirestoreSearchBar(
          tag: 'example',
        ),
        Expanded(
          child: FirestoreSearchResults.builder(
            tag: 'example',
            firestoreCollectionName: 'books',
            searchBy: 'title',
            initialBody: const Center(child: Text('Initial body'),),
            dataListFromSnapshot: bookListFromSnapshot,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<Book>? dataList = snapshot.data;
                if (dataList!.isEmpty) {
                  return const Center(
                    child: Text('No Results Returned'),
                  );
                }
                return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      final Book data = dataList[index];

                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              '${data.title}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8.0, left: 8.0, right: 8.0),
                            child: Text('${data.num_chapters} chapters',
                                style: Theme.of(context).textTheme.bodyText1),
                          )
                        ],
                      );
                    });
              }

              if (snapshot.connectionState == ConnectionState.done) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('No Results Returned'),
                  );
                }
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        )
      ],
    );
  }
}