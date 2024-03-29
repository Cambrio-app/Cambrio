import 'package:cambrio/models/book.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/widgets/book_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'fake_book_card_widget.dart';

class BookListView extends StatefulWidget {
  final String collectionToPull;
  final String? collectionTitle;
  final QueryTypes? queryType;

  const BookListView ({ Key? key, required this.collectionToPull, this.collectionTitle, this.queryType}): super(key: key);

  @override
  _BookListViewState createState() => _BookListViewState();
}

class _BookListViewState extends State<BookListView> with
    AutomaticKeepAliveClientMixin<BookListView>{
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
      final List<DocumentSnapshot<Book>> newItems = await FirebaseService().getBookDocs(widget.collectionToPull,pageKey,_pageSize, type: widget.queryType);
      final isLastPage = newItems.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(newItems);
      } else {
        // final int nextPageKey = pageKey + newItems.length;
        final nextPageKey = newItems.last;
        _pagingController.appendPage(newItems, nextPageKey);
      }

    } catch (error) {
      // debugPrint('(dispose error in book_list_view)');
      if(mounted) _pagingController.error = error;
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
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24)
                        )
                    )),

                Container(
                  alignment: Alignment.centerLeft,
                  // fit: FlexFit.loose,
                    height: 150 + MediaQuery.of(context).textScaleFactor*(2 * 18 * 1.1 + 13 + 14 + 5),
                    // color: Colors.green,
                    // this view is dynamically populated with book cards from book.dart, using data received -
                    // - in the form of a DocumentSnapshot<Book. Calling .data() gives a Map, which then resolves into the data we want.
                    child: PagedListView<DocumentSnapshot<Book>?, DocumentSnapshot<Book>>( //used to be PagedGridView
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      pagingController: _pagingController,
                      builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot<Book>>(
                        noMoreItemsIndicatorBuilder: (_) => const FakeBookCard(title: 'Find more books'),
                        firstPageErrorIndicatorBuilder: (_) => const Text('first page error!',textAlign: TextAlign.center,),
                        newPageErrorIndicatorBuilder: (_) => const Text('new page error!',textAlign: TextAlign.center,),
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

  @override
  bool get wantKeepAlive => true;
}
