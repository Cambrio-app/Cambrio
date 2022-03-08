import 'package:cambrio/services/ChapterQueryService.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:cambrio/widgets/chapter.dart';

import '../models/book.dart';
import '../models/chapter.dart';
import '../services/firebase_service.dart';

class ChapterInfScroll extends StatefulWidget {
  final String collectionToPull;

  const ChapterInfScroll ({ Key? key, required this.collectionToPull}): super(key: key);

  @override
  _ChapterInfScrollState createState() => _ChapterInfScrollState();
}

class _ChapterInfScrollState extends State<ChapterInfScroll> {
  static const _pageSize = 15;

  final PagingController<DocumentSnapshot<Chapter>?, DocumentSnapshot<Chapter>> _pagingController = PagingController(firstPageKey: null, invisibleItemsThreshold: 3);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
    super.initState();
  }

  Future<void> _fetchPage(DocumentSnapshot<Chapter>? pageKey) async {
    try {
      final List<DocumentSnapshot<Chapter>> newItems = (await ChapterQueryService().getChapterDocs(widget.collectionToPull,pageKey,_pageSize)).cast<DocumentSnapshot<Chapter>>();
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
        child: PagedListView<DocumentSnapshot<Chapter>?, DocumentSnapshot<Chapter>>( //used to be PagedGridView
          scrollDirection: Axis.vertical,
          pagingController: _pagingController,
          builderDelegate: PagedChildBuilderDelegate<DocumentSnapshot<Chapter>>(
            // noItemsFoundIndicatorBuilder: (context) => const Text('No more items!'),
            noMoreItemsIndicatorBuilder: (_) => const Text('no more!',textAlign: TextAlign.center,),
            itemBuilder: (context, item, index) => ChapterWidget(
              chapter: item.data()!,
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



