import 'package:cambrio/models/book.dart';
import 'package:cambrio/models/chapter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class FirebaseService {
  FirebaseService() {

  }

  Future<List<QueryDocumentSnapshot<Book>>> getBooks(String collectionToPull, DocumentSnapshot? lastDocument, int pageSize) async {
    Query<Book> _query = FirebaseFirestore.instance
        .collection(collectionToPull).orderBy("title", descending: true).withConverter<Book>(
          fromFirestore: (snapshot, _) => Book.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (book, _) => book.toJson(),
    );

    // start after the last document that the requester already has. If they don't have any, start at the first document
    if (lastDocument != null) {
      _query = _query.startAfterDocument(lastDocument).limit(pageSize);
    } else {
      _query = _query.limit(pageSize);
    }

    final QuerySnapshot<Book> query =  await _query.get();
    final List<QueryDocumentSnapshot<Book>> newItems = query.docs;

    // List<Book> returnItems = newItems.map((doc) {
    //   return doc.data();
    // }).toList();

    return newItems;
  }

  Future<List<Chapter>> getChapters(String bookId) async {
    Query<Chapter> _query = FirebaseFirestore.instance
        .collection('books/$bookId/chapters').withConverter<Chapter>(
      fromFirestore: (snapshot, _) => Chapter.fromJson(snapshot.id, snapshot.data()!),
      toFirestore: (book, _) => book.toJson(),
    );

    final QuerySnapshot<Chapter> query =  await _query.get();
    final List<QueryDocumentSnapshot<Chapter>> newItems = query.docs;

    List<Chapter> returnItems = newItems.map((doc) {
      return doc.data();
    }).toList();

    return returnItems;
  }
}