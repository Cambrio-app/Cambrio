import 'package:cambrio/pages/profile/author_profile_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// TODO: get away from firestore_search. It's not scalable.
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/chapter.dart';
import '../models/user_profile.dart';
import '../services/make_epub.dart';
import 'add_book.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<bool> isSelected = [false];

  List<dynamic> bookListFromSnapshot(QuerySnapshot querySnapshot) {
    if (isSelected[0]) {
      return querySnapshot.docs
          .map((snapshot) =>
          UserProfile.fromJson(snapshot.id, snapshot.data() as Map<String, Object?>))
          .toList();
    }
    else {
      return querySnapshot.docs
        .map((snapshot) =>
            Book.fromJson(snapshot.id, snapshot.data() as Map<String, Object?>))
        .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: FirestoreSearchBar(
                tag: 'example',
              ),
            ),
            ToggleButtons(
              children: const <Widget>[
                Icon(Icons.account_box_sharp),
              ],
              isSelected: isSelected,
              onPressed: (int index) {
                setState(() {
                  for (int buttonIndex = 0;
                      buttonIndex < isSelected.length;
                      buttonIndex++) {
                    if (buttonIndex == index) {
                      isSelected[buttonIndex] = !isSelected[buttonIndex];
                    } else {
                      isSelected[buttonIndex] = false;
                    }
                  }
                });
              },
            )
          ],
        ),
        Expanded(
          child: FirestoreSearchResults.builder(
            tag: 'example',
            firestoreCollectionName: isSelected[0] ? 'user_profiles' : 'books',
            searchBy: isSelected[0] ? 'handle' : 'title',
            initialBody: const Center(
              child: Text('Search through all of the books ever written or all of the Authors on Cambrio.'),
            ),
            dataListFromSnapshot: bookListFromSnapshot,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                late dynamic dataList;
                if (isSelected[0]) {
                  dataList = snapshot.data as List<UserProfile>;
                } else {
                  dataList = snapshot.data as List<Book>;
                }
                if (dataList!.isEmpty) {
                  return const Center(
                    child: Text('No Results Returned'),
                  );
                }
                return ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      late final dynamic data;
                      if (isSelected[0]) {
                        data = dataList[index] as UserProfile;
                      } else {
                        data = dataList[index] as Book;
                      }

                      return InkWell(
                        onTap: () {
                          if (isSelected[0]) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AuthorProfilePage(profile: data,))
                            );
                          } else {
                            final MakeEpub epubber = MakeEpub(title: data.title, authorName:'mmmm', authorId:'mm', bookId:data.id);
                            epubber.makeEpub(context);
                          }
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                '${isSelected[0] ? data.handle : data.title}',
                                style: Theme.of(context).textTheme.headline6,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 8.0, left: 8.0, right: 8.0),
                              child: Text(
                                  isSelected[0]
                                      ? '${data.full_name}'
                                      : '${data.num_chapters} chapters',
                                  style: Theme.of(context).textTheme.bodyText1),
                            )
                          ],
                        ),
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
