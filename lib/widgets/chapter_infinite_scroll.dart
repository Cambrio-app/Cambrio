import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cambrio/widgets/chapter.dart';

class ChapterInfScroll extends StatefulWidget {
  final String collectionToPull;

  const ChapterInfScroll ({ Key? key, required this.collectionToPull}): super(key: key);

  @override
  _ChapterInfScrollState createState() => _ChapterInfScrollState();
}

class _ChapterInfScrollState extends State<ChapterInfScroll> {
  static const _pageSize = 15;

  final PagingController<DocumentSnapshot?, DocumentSnapshot> _pagingController = PagingController(firstPageKey: null, invisibleItemsThreshold: 3);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(DocumentSnapshot? pageKey) async {
    try {
      Query _query = FirebaseFirestore.instance
          .collection(widget.collectionToPull).orderBy("title", descending: true);
      if (pageKey != null) {
        _query = _query.startAfterDocument(pageKey).limit(_pageSize);
      } else {
        _query = _query.limit(_pageSize);
      }

      final QuerySnapshot query =  await _query.get();
      final List<DocumentSnapshot> newItems = query.docs;
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
        child: PagedListView<DocumentSnapshot?, DocumentSnapshot>( //used to be PagedGridView
          scrollDirection: Axis.vertical,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot>(
            // noItemsFoundIndicatorBuilder: (context) => const Text('No more items!'),
            noMoreItemsIndicatorBuilder: (_) => const Text('no more!',textAlign: TextAlign.center,),
            itemBuilder: (context, item, index) => Chapter(
              title: (item.data() as Map<String,dynamic>)["title"],
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



