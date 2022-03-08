import 'package:cambrio/models/book.dart';
import 'package:cambrio/services/firebase_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cambrio/widgets/book_card_widget.dart';

class BookGridView extends StatefulWidget {
  final String collectionToPull;

  const BookGridView ({ Key? key, required this.collectionToPull}): super(key: key);

  @override
  _BookGridViewState createState() => _BookGridViewState();
}

class _BookGridViewState extends State<BookGridView> {
  static const _pageSize = 15;

  final PagingController<DocumentSnapshot<Book>?, DocumentSnapshot<Book>> _pagingController = PagingController(firstPageKey: null, invisibleItemsThreshold: 3);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }
  // grab books from the database
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
      // final List<DocumentSnapshot> newItems = query.docs;
      final List<DocumentSnapshot<Book>> newItems = await FirebaseService().getBookDocs(widget.collectionToPull,pageKey,_pageSize);
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
        child: PagedGridView<DocumentSnapshot<Book>?, DocumentSnapshot<Book>>( //used to be PagedGridView
          scrollDirection: Axis.horizontal,
          showNewPageProgressIndicatorAsGridChild: false,
          showNewPageErrorIndicatorAsGridChild: false,
          showNoMoreItemsIndicatorAsGridChild: false,
          pagingController: _pagingController,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 250, //was 150
            mainAxisExtent: 150, //was 250
          ),
          builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot<Book>>(
            // noItemsFoundIndicatorBuilder: (context) => const Text('No more items!'),
            noMoreItemsIndicatorBuilder: (_) => const Text('no more!',textAlign: TextAlign.center,),
            itemBuilder: (context, item, index) => BookCard(
              bookSnap: item,
              // title: (item.data() as Map<String,dynamic>)["title"],
              // bookId: item.id,
            ),
          ),
        ),
      );

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }
}



