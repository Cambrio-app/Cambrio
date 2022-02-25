import 'dart:math';

import 'package:cambrio/models/book.dart';
import 'package:cambrio/models/chapter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../models/author_subscription.dart';

enum QueryTypes {
  alphabetical,
  reverseAlphabetical,
  hated,
  loved,
  subscribed,
  random,
  works,
}

class FirebaseService {
  FirebaseService() {}

  String? cachedUserId;

  String get userId {
    cachedUserId ??= FirebaseAuth.instance.currentUser!.uid;
    return cachedUserId!;
  }

  // pulls existing profile information.
  Future<UserProfile?> getProfile({required String uid}) async {
    debugPrint(uid);
    var result = (await FirebaseFirestore.instance
            .collection('user_profiles') // collection we are adding to
            .doc(uid)
            .withConverter<UserProfile>(
                fromFirestore: (snapshot, _) =>
                    UserProfile.fromJson(snapshot.id, snapshot.data()!),
                toFirestore: (user, _) => user.toJson())
            .get())
        .data();
    debugPrint(result!.full_name);
    debugPrint('wat');
    return result;
  }

  // pull user subscription info
  Future<List<String>> authorSubscriptions() async {
    String uid =
        FirebaseAuth.instance.currentUser!.uid; // get current user id
    //get the list of ids of the current user's author subscriptions
    List<String> subs = (await FirebaseFirestore.instance
        .collection('user_profiles/$uid/author_subscriptions')
        .limit(100)
    //     .withConverter<AuthorSubscription>(
    //   fromFirestore: (snapshot, _) =>
    //       AuthorSubscription.fromJson(snapshot.id, snapshot.data()!),
    //   toFirestore: (sub, _) => sub.toJson(),
    // )
        .get())
        .docs
        .map((sub) => sub.id)
    .toList();
    return subs;
  }

  // check whether the user is subscribed to the author
  Future<bool> isSubscribed(String authorId) async {
    return (await FirebaseFirestore.instance.collection('user_profiles/$userId/author_subscriptions')
    .doc(authorId).get()).exists;
  }

  // modify or create a new profile for the user.
  void editProfile(
      {String? full_name, String? handle, String? bio, String? url_pic}) async {
    String? _user_id = FirebaseAuth.instance.currentUser?.uid;
    if (_user_id != null) {
      // Adds user inputted title to the Firestore database
      FirebaseFirestore.instance
          .collection('user_profiles') // collection we are adding to
          .doc(_user_id)
          .set({
        // what we are adding
        'full_name': full_name,
        'handle': handle,
        'bio': bio,
        'url_pic': url_pic,
      });
    }
  }

  // grab all documentsnapshots of book, for use in scrolling listview of book widgets in ui
  Future<List<QueryDocumentSnapshot<Book>>> getBookDocs(
      String collectionToPull, DocumentSnapshot? lastDocument, int pageSize,
      {QueryTypes? type = QueryTypes.alphabetical}) async {
    late Query<Book> _query;
    switch (type) {
      case QueryTypes.alphabetical:
        _query = FirebaseFirestore.instance
            .collection(collectionToPull)
            .orderBy("title", descending: true)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            );
        break;
      case QueryTypes.reverseAlphabetical:
        _query = FirebaseFirestore.instance
            .collection(collectionToPull)
            .orderBy("title", descending: false)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            );
        break;
      case QueryTypes.hated:
        _query = FirebaseFirestore.instance
            .collection(collectionToPull)
            .orderBy("likes", descending: false)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            );
        break;
      case QueryTypes.loved:
        _query = FirebaseFirestore.instance
            .collection(collectionToPull)
            .orderBy("likes", descending: true)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            );
        break;
      case QueryTypes.subscribed:
        String uid =
            FirebaseAuth.instance.currentUser!.uid; // get current user id
        //get the list of ids of the current user's author subscriptions
        List<String> subs = (await FirebaseFirestore.instance
                .collection('user_profiles/$uid/author_subscriptions')
                .limit(100)
                //     .withConverter<AuthorSubscription>(
                //   fromFirestore: (snapshot, _) =>
                //       AuthorSubscription.fromJson(snapshot.id, snapshot.data()!),
                //   toFirestore: (sub, _) => sub.toJson(),
                // )
                .get())
            .docs
            .map((sub) => sub.id)
            .toList();
        _query = FirebaseFirestore.instance
            .collection('books')
            .where('author_id', whereIn: subs.isEmpty?['1skenow34']:subs)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            );
        break;
      case QueryTypes.random:
        lastDocument ??= (await FirebaseFirestore.instance
                .collection(collectionToPull)
                .where(FieldPath.documentId, isGreaterThanOrEqualTo: autoId())
                .limit(1)
                .get())
            .docs[0];
        _query = FirebaseFirestore.instance
            .collection(collectionToPull)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            );
        break;
      case QueryTypes.works:
        String uid = FirebaseAuth.instance.currentUser!.uid;
        _query = FirebaseFirestore.instance
            .collection(collectionToPull)
            .where('author_id', isEqualTo: uid)
            // .orderBy("likes", descending: true)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            );
        break;
      default:
        _query = FirebaseFirestore.instance
            .collection(collectionToPull)
            .orderBy("title", descending: true)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            );
        break;
    }
    // start after the last document that the requester already has. If they don't have any, start at the first document
    if (lastDocument != null) {
      _query = _query.startAfterDocument(lastDocument).limit(pageSize);
    } else {
      _query = _query.limit(pageSize);
    }

    final QuerySnapshot<Book> query = await _query.get();
    final List<QueryDocumentSnapshot<Book>> newItems = query.docs;

    // List<Book> returnItems = newItems.map((doc) {
    //   return doc.data();
    // }).toList();

    return newItems;
  }

  // grab all documentsnapshots of chapter, for use in chapter views in ui
  Future<List<QueryDocumentSnapshot<Chapter>>> getChapterDocs(
      String collectionToPull,
      DocumentSnapshot? lastDocument,
      int pageSize) async {
    Query<Chapter> _query = FirebaseFirestore.instance
        .collection(collectionToPull)
        .orderBy("order", descending: false)
        .withConverter<Chapter>(
          fromFirestore: (snapshot, _) =>
              Chapter.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (chapter, _) => chapter.toJson(),
        );

    // start after the last document that the requester already has. If they don't have any, start at the first document
    if (lastDocument != null) {
      _query = _query.startAfterDocument(lastDocument).limit(pageSize);
    } else {
      _query = _query.limit(pageSize);
    }

    final QuerySnapshot<Chapter> query = await _query.get();
    final List<QueryDocumentSnapshot<Chapter>> newItems = query.docs;

    // List<Book> returnItems = newItems.map((doc) {
    //   return doc.data();
    // }).toList();

    return newItems;
  }

  // grab all chapters of the book, for use in epub reader
  Future<List<Chapter>> getChapters(String bookId) async {
    Query<Chapter> _query = FirebaseFirestore.instance
        .collection('books/$bookId/chapters')
        .orderBy('order')
        .withConverter<Chapter>(
          fromFirestore: (snapshot, _) =>
              Chapter.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (book, _) => book.toJson(),
        );

    final QuerySnapshot<Chapter> query = await _query.get();
    final List<QueryDocumentSnapshot<Chapter>> newItems = query.docs;

    List<Chapter> returnItems = newItems.map((doc) {
      return doc.data();
    }).toList();

    return returnItems;
  }

  void editChapter(
      {required String book_id,
      String? chapter_id,
      String? chapter_name,
      String? text,
      int? order,
      bool is_paywalled = false}) async {
    debugPrint(order.toString());
    String? _user_id = FirebaseAuth.instance.currentUser?.uid;
    if (_user_id != null) {
      // Adds user inputted title to the Firestore database
      FirebaseFirestore.instance
          .collection('books') // collection we are adding to
          .doc(book_id)
          .collection('chapters')
          .doc(
              chapter_id) // if this is null, an auto-generated value will be used (a new chapter will be made)
          .set({
        // what we are adding
        'chapter_name': chapter_name,
        'text': text,
        'order': order,
        'is_paywalled': is_paywalled,
      });
    }
  }

  void editSubscription({required String author_id}) async {
    String? _user_id = FirebaseAuth.instance.currentUser?.uid;
    if (_user_id != null) {
      // Adds the chosen author id to the user's author subscription list.
      FirebaseFirestore.instance
          .collection('user_profiles') // collection we are adding to
          .doc(_user_id)
          .collection('author_subscriptions')
          .doc(author_id) // if this is null, an auto-generated value will be used (a new entry will be made)
          .set({
        // what we are adding
        'author_id': author_id,
        'time_subscribed': FieldValue.serverTimestamp(),
      });
    }
  }

  void removeSubscription({required String author_id}) {
      // Removes the chosen author id from the user's author subscription list.
      FirebaseFirestore.instance
          .collection('user_profiles') // collection we are adding to
          .doc(userId)
          .collection('author_subscriptions')
          .doc(author_id)
          .delete();
  }

  // the below is for finding random items in the database.
  final int AUTO_ID_LENGTH = 20;

  final String AUTO_ID_ALPHABET =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

  final Random rand = Random();

  String autoId() {
    String builder = '';
    int maxRandom = AUTO_ID_ALPHABET.length;
    for (int i = 0; i < AUTO_ID_LENGTH; i++) {
      builder += (AUTO_ID_ALPHABET[rand.nextInt(maxRandom)]);
    }
    return builder.toString();
  }
}
