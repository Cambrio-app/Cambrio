import 'package:cambrio/models/book.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/widgets/book_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import 'fake_book_card_widget.dart';

class BookGridView extends StatefulWidget {
  final String collectionToPull;
  final String? collectionTitle;
  final QueryTypes? queryType;

  const BookGridView ({ Key? key, required this.collectionToPull, this.collectionTitle, this.queryType}): super(key: key);

  @override
  _BookGridViewState createState() => _BookGridViewState();
}

class _BookGridViewState extends State<BookGridView> with
    AutomaticKeepAliveClientMixin<BookGridView>{
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
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                if (widget.collectionTitle!=null) Container(
                    padding: const EdgeInsets.fromLTRB(8,8,8,0),
                    child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.collectionTitle!,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 24, fontFamily: 'Montserrat')
                        )
                    )),

                Expanded(
                  child: PagedGridView<DocumentSnapshot<Book>?, DocumentSnapshot<Book>>( //used to be PagedGridView
                    // padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    showNewPageProgressIndicatorAsGridChild: false,
                    showNewPageErrorIndicatorAsGridChild: false,
                    showNoMoreItemsIndicatorAsGridChild: true,
                    pagingController: _pagingController,
                    // gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    //   mainAxisSpacing: 2,
                    //   crossAxisCount: 3,
                    //     mainAxisExtent: 150 + MediaQuery.of(context).textScaleFactor*(2 * 18 * 1.1 + 13 + 14 + 5), //was 250
                    //   crossAxisSpacing: 2
                    // ),
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      crossAxisSpacing: 10,
                      maxCrossAxisExtent: 150, //was 150
                      mainAxisExtent: 150 + MediaQuery.of(context).textScaleFactor*(2 * 18 * 1.1 + 13 + 14 + 5), //was 250
                    ),
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
                  ),
                ),
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
