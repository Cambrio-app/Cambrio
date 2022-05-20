import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chapter.dart';
import 'firebase_service.dart';

class ChapterQueryService {
  final userId = FirebaseService().userId;
  late List<String> subs;
  Future<List<DocumentSnapshot<Chapter>>> getChapterDocs(
      String collectionToPull,
      DocumentSnapshot<Chapter>? lastDocument,
      int pageSize,
      {QueryTypes? type = QueryTypes.subscribed}) async {
    late Query _query;
    // switch (type) {

    // case QueryTypes.subscribed:
    String uid = FirebaseService().userId; // get current user id
    //get the list of ids of the current user's author subscriptions
    subs = (await FirebaseFirestore.instance
            .collection('user_profiles/$uid/liked_books')
            .limit(10)
            //     .withConverter<AuthorSubscription>(
            //   fromFirestore: (snapshot, _) =>
            //       AuthorSubscription.fromJson(snapshot.id, snapshot.data()!),
            //   toFirestore: (sub, _) => sub.toJson(),
            // )
            .get())
        .docs
        .map((sub) => sub.id)
        .toList();
    // _query = FirebaseFirestore.instance
    //     .collectionGroup('chapters')
    //     .where('book_id', whereIn: subs.isEmpty ? ['1skenow34'] : subs)
    //     .orderBy('time_written')
    //     .withConverter<Chapter>(
    //   fromFirestore: (snapshot, _) =>
    //       Chapter.fromJson(snapshot.id, snapshot.data()!),
    //   toFirestore: (book, _) => book.toJson(),
    // );
    //     break;
    //   default:
    //     _query = FirebaseFirestore.instance
    //         .collection(collectionToPull)
    //         .orderBy("title", descending: true)
    //         .withConverter<Chapter>(
    //       fromFirestore: (snapshot, _) =>
    //           Chapter.fromJson(snapshot.id, snapshot.data()!),
    //       toFirestore: (book, _) => book.toJson(),
    //     );
    //     break;
    // }

    late List<DocumentSnapshot<Chapter>> newItems;

    // // the original query on book references.
    // if (type != QueryTypes.saved) {
    //   // start after the last document that the requester already has. If they don't have any, start at the first document
    //   if (lastDocument != null) {
    //     _query = _query.startAfterDocument(lastDocument).limit(pageSize);
    //   } else {
    //     _query = _query.limit(pageSize);
    //   }
    //
    //   final QuerySnapshot<Chapter> query = await (_query as Query<Chapter>).get();
    //   newItems = query.docs;
    // } else {
    // this query is on document ids, not on actual document references of books
    _query = FirebaseFirestore.instance
        .collectionGroup('chapters')
        .where('book_id', whereIn: subs)
        .limit(10)
        .orderBy('time_written', descending: true)
        .withConverter<Chapter>(
          fromFirestore: (snapshot, _) =>
              Chapter.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (book, _) => book.toJson(),
        );
    // debugPrint("queried.");
    // debugPrint(' ${(await _query.get()).docs}');
    // start after the last document that the requester already has. If they don't have any, start at the first document
    if (lastDocument != null) {
      // debugPrint('itsnull');
      _query = _query.startAfterDocument(lastDocument).limit(pageSize);
    } else {
      // debugPrint('notnull');
      _query = _query.limit(pageSize);
    }

    final QuerySnapshot<Chapter> query = await (_query as Query<Chapter>).get();
    // debugPrint('woah: ${query.size}');
    newItems = query.docs;
    // debugPrint(newItems.toString());

    // if (lastDocument != null) {
    //   DocumentSnapshot<Chapter> actualLastDocument = await FirebaseFirestore.instance
    //       .collection('user_profiles/$userId/liked_books')
    //       .doc(lastDocument.data()!.book_id)
    //       .collection('chapters')
    //       .get() as DocumentSnapshot<Chapter>;
    //   _query = _query.startAfterDocument(actualLastDocument).limit(pageSize);
    // } else {
    //   _query = _query.limit(pageSize);
    // }
    // final QuerySnapshot query = await (_query).get();
    // // debugPrint(
    // //     "test: ${(await FirebaseFirestore.instance.collection('books').doc(query.docs[0].id).get()).data()}");
    // List<DocumentSnapshot<Chapter>> list =
    // await Future.wait(query.docs.map((element) async {
    //   return FirebaseFirestore.instance
    //       .collection('books')
    //       .doc(element.id)
    //       .withConverter<Chapter>(
    //     fromFirestore: (snapshot, _) =>
    //         Chapter.fromJson(snapshot.id, snapshot.data()!),
    //     toFirestore: (book, _) => book.toJson(),
    //   )
    //       .get();
    // }).toList());
    // list.removeWhere((element) => element.data() == null);
    // debugPrint("is it the list? ,  ${list}");
    // newItems = list;
    // }

    return newItems;
  }
}
