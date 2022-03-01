import 'package:cambrio/models/book.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/widgets/book_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BookListView extends StatefulWidget {
  final String collectionToPull;
  final String? collectionTitle;
  final QueryTypes? queryType;

  const BookListView ({ Key? key, required this.collectionToPull, this.collectionTitle, this.queryType}): super(key: key);

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
            mainAxisSize: MainAxisSize.max,
              children: [

                if (widget.collectionTitle!=null) Container(
                    padding: const EdgeInsets.fromLTRB(8,8,8,0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.collectionTitle!,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25)
                        )
                    )),

                Container(
                  // fit: FlexFit.loose,
                    height: 150 + 2*14*MediaQuery.of(context).textScaleFactor*1.2,
                    // color: Colors.green,
                    // this view is dynamically populated with book cards from book.dart, using data received -
                    // - in the form of a DocumentSnapshot<Book. Calling .data() gives a Map, which then resolves into the data we want.
                    child: PagedListView<DocumentSnapshot<Book>?, DocumentSnapshot<Book>>( //used to be PagedGridView
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot<Book>>(
                        noMoreItemsIndicatorBuilder: (_) => const Text('no more!',textAlign: TextAlign.center,),
                        itemBuilder: (context, item, index) {
                          return BookCard(
                            bookSnap: item,
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
