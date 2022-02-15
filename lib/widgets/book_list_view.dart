import 'package:cambrio/models/book.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cambrio/widgets/book_card_widget.dart';

class BookListView extends StatefulWidget {
  final String collectionToPull;
  final String collectionTitle;
  final QueryTypes? queryType;

  const BookListView ({ Key? key, required this.collectionToPull, required this.collectionTitle, this.queryType}): super(key: key);

  @override
  _BookListViewState createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> {
  static const _pageSize = 4;
  final PagingController<DocumentSnapshot<Book>?, DocumentSnapshot<Book>> _pagingController = PagingController(firstPageKey: null, invisibleItemsThreshold: 3);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(DocumentSnapshot<Book>? pageKey) async {
    try {
      // Query _query = FirebaseFirestore.instance
      //     .collection(widget.collectionToPull).orderBy("title", descending: true);
      // if (pageKey != null) {
      //   _query = _query.startAfterDocument(pageKey).limit(_pageSize);
      // } else {
      //   _query = _query.limit(_pageSize);
      // }
      //
      // final QuerySnapshot query =  await _query.get();
      // final List<DocumentSnapshot<Book> newItems = query.docs;
      final List<QueryDocumentSnapshot<Book>> newItems = await FirebaseService().getBookDocs(widget.collectionToPull,pageKey,_pageSize, type: widget.queryType);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // final int nextPageKey = pageKey + newItems.length;
        final nextPageKey = newItems.last;
        _pagingController.appendPage(newItems, nextPageKey);
      }

    } catch (error) {
      _pagingController.error = error;
    }
  }
  @override
  Widget build(BuildContext context) =>
      RefreshIndicator(
          onRefresh: () => Future.sync(
                () => _pagingController.refresh(),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    padding: const EdgeInsets.all(8),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.collectionTitle,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
                        )
                    )),

                Container(
                    height: 200,
                    // this view is dynamically populated with book cards from book.dart, using data received -
                    // - in the form of a DocumentSnapshot<Book. Calling .data() gives a Map, which then resolves into the data we want.
                    child: PagedListView<DocumentSnapshot<Book>?, DocumentSnapshot<Book>>( //used to be PagedGridView
                      scrollDirection: Axis.horizontal,
                      pagingController: _pagingController,

                      builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot<Book>>(
                        // noItemsFoundIndicatorBuilder: (context) => const Text('No more items!'),
                        noMoreItemsIndicatorBuilder: (_) => const Text('no more!',textAlign: TextAlign.center,),

                        itemBuilder: (context, item, index) {
                          // TODO: these comments probably need to be implemented in the book.dart or in make_zip.dart or a seperate database pulling class
                          // CollectionReference users = FirebaseFirestore.instance.collection('books/${item.id}/chapters');
                          // debugPrint((await users.orderBy('order',descending:false).get()).docs.toString());
                          return BookCard(
                            bookSnap: item,
                            // title: item.title,
                            // bookId: item.id,
                            // chapters: ((item.data() as Map<String, dynamic>)["chapters"]) ?? {
                            //   'fakeChapterId0': {
                            //     'chapter_name': 'chapter 1',
                            //     'text': "<p>terribly sorry, the chapters didn't load</p>"
                            //   }
                            // },
                          );
                        },
                      ),
                    )),
              ])
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}
