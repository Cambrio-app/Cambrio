import 'dart:isolate';
import 'dart:math';

import 'package:cambrio/models/book.dart';
import 'package:cambrio/models/chapter.dart';
import 'package:cambrio/models/like.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';

import '../firebase_options.dart';
import '../models/tutorials_state.dart';
import '../models/user_profile.dart';
import '../widgets/alert.dart';

enum QueryTypes {
  alphabetical,
  reverseAlphabetical,
  hated,
  loved,
  subscribed,
  saved,
  random,
  works,
}

class FirebaseService extends ChangeNotifier {
  FirebaseService();
  static FirebaseService instance = FirebaseService();
  static bool _isInitialized = false;
  static bool error = false;
  String? _cachedUserId;
  UserProfile? _cachedCurrentUserProfile;

  bool get initialized {
    // if (!_isInitialized) {
    //   initializeServices();
    // }
    // debugPrint('initialized? $_isInitialized');
    return _isInitialized;
  }

  String get userId => _cachedUserId ?? FirebaseAuth.instance.currentUser!.uid;

  Future<UserProfile> get currentUserProfile async =>
      _cachedCurrentUserProfile ?? (await getProfile(uid: userId))!;

  // Define an async function to initialize FlutterFire
  void initializeServices() async {
    // debugPrint('initializing...');
    // await Future.delayed(Duration(seconds: 20));


    // make sure that TutorialsState is _initialized
    await TutorialsState.initInstance();
    // debugPrint('initialized tutorials state');

    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      _isInitialized = true;

      FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001); // TODO: don't use emulator when you deploy

      notifyListeners();
      // setState(() {
      //   _initialized = true;
      // });

      // debugPrint('goooo');

      // set up crashlytics
      if (!kIsWeb) { // only set it up on mobile; it's not available on web.
        FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
        Isolate.current.addErrorListener(RawReceivePort((pair) async {
          final List<dynamic> errorAndStacktrace = pair;
          await FirebaseCrashlytics.instance.recordError(
            errorAndStacktrace.first,
            errorAndStacktrace.last,
          );
        }).sendPort);
      }

      // set up google analytics
      // FirebaseAnalytics analytics = FirebaseAnalytics.instance;

      // set defaults for remote config values, like auto_search
      await FirebaseRemoteConfig.instance.setDefaults(<String, dynamic>{
        'welcome_message': 'default welcome message',
        'auto_search': true,
        'search_delay': 1000,
        'fancy_bell': false,
      });

      FirebaseRemoteConfig rc = FirebaseRemoteConfig.instance;
      await rc.setConfigSettings(RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 60),
        // minimumFetchInterval: const Duration(seconds: 30),
        minimumFetchInterval: const Duration(hours: 3),
      ));
      bool updated = await rc.fetchAndActivate();
      // debugPrint('updated?: $updated auto_search???: ${rc.getBool('auto_search').toString()}');

    } catch(e) {
      // Set `_error` state to true if Firebase initialization fails
      // setState(() {
      //   debugPrint(e.toString());
      //   _error = true;
      // });
      error = true;
      notifyListeners();
    }
  }

  Future<String?> uploadImage(context,
      {required XFile image, required String name}) async {
    // debugPrint('uploading image ......');
    String? imageUrl;
    try {
      firebase_storage.Reference ref =
          firebase_storage.FirebaseStorage.instance.ref('$name.png');

      await ref.putData(await image.readAsBytes());
      // get the url of the uploaded photo
      imageUrl = await ref.getDownloadURL();
      debugPrint('Image Uploaded');
    } catch (e) {
      Alert().error(
          context, "We had a problem uploading your picture: ${e.toString()}");
      // e.g, e.code == 'canceled'
    }
    return imageUrl;
  }

  // pulls existing profile information.
  Future<UserProfile?> getProfile({required String uid}) async {
    // debugPrint(uid);
    var result = (await FirebaseFirestore.instance
            .collection('user_profiles') // collection we are adding to
            .doc(uid)
            .withConverter<UserProfile>(
                fromFirestore: (snapshot, _) =>
                    UserProfile.fromJson(snapshot.id, snapshot.data()!),
                toFirestore: (user, _) => user.toJson())
            .get())
        .data();
    // debugPrint(result!.full_name);
    // debugPrint('wat');
    return result;
  }

  // pull user subscription info
  Future<List<String>> authorSubscriptions() async {
    String uid = FirebaseAuth.instance.currentUser!.uid; // get current user id
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
    return (await FirebaseFirestore.instance
            .collection('user_profiles/$userId/author_subscriptions')
            .doc(authorId)
            .get())
        .exists;
  }

  Future<bool> isHandleTaken(String handle) async {
    UserProfile profile = (await FirebaseFirestore.instance
            .collection('user_profiles')
            .limit(2)
            .withConverter<UserProfile>(
              fromFirestore: (snapshot, _) =>
                  UserProfile.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (prof, _) => prof.toJson(),
            )
            .where('handle', isEqualTo: handle)
            .get())
        .docs
        .first
        .data();
    return profile.user_id != userId;
  }

  // modify or create a new profile for the user.
  Future<bool> editProfile(BuildContext? context,
      {String? full_name,
      String? handle,
      String? bio,
      String? url_pic,
      XFile? image,
      int? num_subs,
      int? num_likes,
      String? connected_account_id}) async {
    String? UserId = FirebaseAuth.instance.currentUser?.uid;

    // upload image
    if (UserId != null) {
      // upload user image
      if (image != null) {
        debugPrint('updating image');
        try {
          firebase_storage.Reference ref =
              firebase_storage.FirebaseStorage.instance.ref('$userId.png');
          await ref.putData(await image.readAsBytes());
          // get the url of the uploaded photo
          url_pic = await ref.getDownloadURL();
        } catch (e) {
          Alert().error(context,
              "We had a problem uploading your picture: ${e.toString()}");
          // e.g, e.code == 'canceled'
        }
      }

      // create profile
      final profile = UserProfile(
          user_id: UserId,
          connected_account_id: connected_account_id,
          image_url: url_pic,
          full_name: full_name,
          handle: handle,
          bio: bio,
          num_subs: num_subs,
          num_likes: num_likes);

      debugPrint(profile.toJson().toString());
      // reference current/future profile
      DocumentReference<UserProfile> userRef = FirebaseFirestore.instance
          .collection('user_profiles') // collection we are adding to
          .doc(userId)
          .withConverter<UserProfile>(
            fromFirestore: (snapshot, _) =>
                UserProfile.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (prof, _) => prof.toJson(),
          );
      DocumentReference handleRef = FirebaseFirestore.instance
          .collection('handles')
          .doc(handle);

      // check for handle, upload profile
      bool result = await FirebaseFirestore.instance.runTransaction((transaction) async {
        DocumentSnapshot existingHandle = await transaction
            .get(handleRef);
        String? existingHandleUser = existingHandle.exists ? existingHandle['user_id'] : null;
        debugPrint(existingHandleUser);
        bool isHandleTaken = (existingHandleUser != userId) && (existingHandleUser!=null);
        debugPrint(isHandleTaken.toString());
        if (isHandleTaken) {
          return false;
        } else {
          transaction.set(userRef, profile, SetOptions(merge:true));
          transaction.set(FirebaseFirestore.instance.collection('handles').doc(handle), {'user_id': userId});
          return true;
        }
      })
      .then((value) {
        debugPrint('it worked?? ${value.toString()}');
        return value;})
      .onError((error, stackTrace) {
        debugPrint("${error.toString()} and ${stackTrace.toString()}");
        return false;
      });
      return result;
    }
    return false;
  }

  // modify or create a new book for the user.
  Future<void> editBook(BuildContext context,
      {required Book book, XFile? image}) async {
    CollectionReference booksCollection =
        FirebaseFirestore.instance.collection('books');

    if ((book.id != null)) {
      // go ahead and upload the image if the book already exists on the database
      if ((image != null)) {
        book = book.copyWith(
            image_url:
                await uploadImage(context, image: image, name: book.id!));
      }
      debugPrint("current url, now: ${book.image_url}");
      // Allows user to update all book values or create a new book if there is no book_id
      booksCollection // collection we are adding to
          .doc(book.id)
          .withConverter<Book>(
            fromFirestore: (snapshot, _) =>
                Book.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (book, _) => book.toJson(),
          )
          .set(book, SetOptions(merge:true));
      // book.image_url = await uploadImage(context, image: image, name: book.id!);
    } else {
      DocumentReference ref =
          await booksCollection // collection we are adding to
              .withConverter<Book>(
                fromFirestore: (snapshot, _) =>
                    Book.fromJson(snapshot.id, snapshot.data()!),
                toFirestore: (book, _) => book.toJson(),
              )
              .add(book);

      // if this is a new book, upload the image after we know its id.
      if (image != null) {
        booksCollection // collection we are adding to
            .doc(ref.id)
            .update({
          'image_url': (await uploadImage(context, image: image, name: ref.id))
        });
      }
    }
  }

  Future<bool> deleteBook({required Book book}) async {
    if (book.author_id == userId) {
      // double check that this is indeed the user's book

      // recursively delete all of the chapters
      await FirebaseFirestore.instance
          .collection('books') // collection we are adding to
          .doc(book.id)
          .collection('chapters')
          .get()
          .then((snapshot) {
        for (DocumentSnapshot ds in snapshot.docs) {
          ds.reference.delete();
        }
      });

      // delete the book
      await FirebaseFirestore.instance
          .collection('books') // collection we are adding to
          .doc(book.id)
          .delete();
      return true;
    } else {
      return false;
    }
  }

  Future<DocumentSnapshot<Book>> getBook({required String book_id}) {
    return FirebaseFirestore.instance
        .collection('books')
        .doc(book_id)
        .withConverter<Book>(
          fromFirestore: (snapshot, _) =>
              Book.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (book, _) => book.toJson(),
        )
        .get();
  }

  // grab all documentsnapshots of book, for use in scrolling listview of book widgets in ui
  Future<List<DocumentSnapshot<Book>>> getBookDocs(
      String collectionToPull, DocumentSnapshot? lastDocument, int pageSize,
      {QueryTypes? type = QueryTypes.alphabetical}) async {
    late Query _query;
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
            .where('author_id', whereIn: subs.isEmpty ? ['1skenow34'] : subs)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            );
        break;
      case QueryTypes.saved:
        // debugPrint('get saved');
        _query = FirebaseFirestore.instance
            .collection('user_profiles/$userId/liked_books')
            .limit(100)
            .orderBy('time_liked', descending: true);
        // debugPrint('queried.');
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

    late List<DocumentSnapshot<Book>> newItems;

    // the original query on book references.
    if (type != QueryTypes.saved) {
      // start after the last document that the requester already has. If they don't have any, start at the first document
      if (lastDocument != null) {
        _query = _query.startAfterDocument(lastDocument).limit(pageSize);
      } else {
        _query = _query.limit(pageSize);
      }

      final QuerySnapshot<Book> query = await (_query as Query<Book>).get();
      newItems = query.docs;
    } else {
      // this query is on document ids, not on actual document references of books
      if (lastDocument != null) {
        DocumentSnapshot actualLastDocument = await FirebaseFirestore.instance
            .collection('user_profiles/$userId/liked_books')
            .doc(lastDocument.id)
            .get();
        _query = _query.startAfterDocument(actualLastDocument).limit(pageSize);
      } else {
        _query = _query.limit(pageSize);
      }
      final QuerySnapshot query = await (_query).get();
      // debugPrint(
      //     "test: ${(await FirebaseFirestore.instance.collection('books').doc(query.docs[0].id).get()).data()}");
      List<DocumentSnapshot<Book>> list =
          await Future.wait(query.docs.map((element) async {
        return FirebaseFirestore.instance
            .collection('books')
            .doc(element.id)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            )
            .get();
      }).toList());
      list.removeWhere((element) => element.data() == null);
      // debugPrint("is it the list? ,  ${list}");
      newItems = list;
    }

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

  void editChapter({
    required String book_id,
    String? chapter_id,
    String? chapter_name,
    String? text,
    int? order,
    bool is_paywalled = false,
  }) async {
    // debugPrint(order.toString());
    String? UserId = FirebaseAuth.instance.currentUser?.uid;
    if (UserId != null) {
      // just making sure we aren't dealing with a ghost
      // Adds user inputted title to the Firestore database
      await FirebaseFirestore.instance
          .collection('books') // collection we are adding to
          .doc(book_id)
          .collection('chapters')
          .doc(
              chapter_id) // if this is null, an auto-generated value will be used (a new chapter will be made)
          .set({
        // what we are adding
        'chapter_name': chapter_name,
        'chapter_id': chapter_id,
        'book_id': book_id,
        'time_written': FieldValue.serverTimestamp(),
        'text': text,
        'order': order,
        'is_paywalled': is_paywalled,
      }, SetOptions(merge:true));

      await reorderChapters(
          book_id: book_id, chapter_id: chapter_id, order: order);
    }
  }

  bool deleteChapter(
      {required Book book, required String chapter_id, required int order}) {
    if (book.author_id == userId) {
      // double check that this is indeed the user's book

      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('books') // collection we are adding to
          .doc(book.id)
          .collection('chapters')
          .doc(chapter_id);
      // FirebaseFirestore.instance
      //   .collection('books/${book.id}/chapters')
      //   .where('order', isGreaterThan: order)
      //   .;

      documentReference.delete();
      // reorder the remaining chapters
      reorderChapters(book_id: book.id!);
      return true;
    } else {
      return false;
    }
  }

  Future<void> reorderChapters(
      {required String book_id, String? chapter_id, int? order}) async {
    // do this whole operation at once.
    WriteBatch batch = FirebaseFirestore.instance.batch();

    CollectionReference chapters = FirebaseFirestore.instance
        .collection('books') // collection we are adding to
        .doc(book_id)
        .collection('chapters')
        .withConverter<Chapter>(
          fromFirestore: (snapshot, _) =>
              Chapter.fromJson(snapshot.id, snapshot.data()!),
          toFirestore: (chapter, _) => chapter.toJson(),
        );
    // pull the chapters as a list
    List<DocumentSnapshot<Chapter>> chaptersList =
        (await chapters.orderBy('order', descending: false).get()).docs
            as List<DocumentSnapshot<Chapter>>;

    if (chapter_id != null && order != null) {
      // if this is a reorder, then move the chapter, otherwise, we may just be dealing with a delete
      // get the related chapter
      DocumentSnapshot<Chapter> chosen = chaptersList
          .firstWhere((chapter) => chapter.data()!.chapter_id == chapter_id);
      // take the chapter off the list
      chaptersList.remove(chosen);
      // put the chapter in where specified
      chaptersList.insert(order - 1, chosen);
    }

    // reorder the chapters accordingly
    for (int i = 0; i < chaptersList.length; i++) {
      batch.update(chaptersList[i].reference, {'order': i + 1});
    }

    return batch.commit();
  }

  void editSubscription({required String author_id}) async {
    String? UserId = FirebaseAuth.instance.currentUser?.uid;
    if (UserId != null) {
      // Adds the chosen author id to the user's author subscription list.
      FirebaseFirestore.instance
          .collection('user_profiles') // collection we are adding to
          .doc(UserId)
          .collection('author_subscriptions')
          .doc(
              author_id) // if this is null, an auto-generated value will be used (a new entry will be made)
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

  Future<bool> isLiked(String bookId) async {
    bool record = (await FirebaseFirestore.instance
            .collection('user_profiles') // collection we are adding to
            .doc(userId)
            .collection('liked_books')
            .doc(bookId)
            .get())
        .exists;
    return record;
  }

  Future<void> checkStats({String? profile_id}) async {
    // try {
    // look at all of the book likes on each book
    List agg = (await FirebaseFirestore.instance
            .collection('books')
            .where('author_id', isEqualTo: profile_id ?? userId)
            .get())
        .docs
        .toList();
    int total = 0;
    // add up all of the book likes found
    for (var element in agg) {
      total += element['likes'] as int;
    }
    // update profile to reflect changed value
    FirebaseFirestore.instance
        .collection('user_profiles')
        .doc(profile_id ?? userId)
        .update({'num_likes': total});

    Query subsQuery = FirebaseFirestore.instance
        .collectionGroup('author_subscriptions')
        .where('author_id', isEqualTo: (profile_id ?? userId));
    List subs = (await subsQuery.get()).docs.toList();

    int totalSubs = subs.length;
    for (DocumentSnapshot element in subs) {
      // debugPrint(element.data().toString());
      total += 1;
    }
    FirebaseFirestore.instance
        .collection('user_profiles')
        .doc(profile_id ?? userId)
        .update({'num_subs': totalSubs});
    // }
    // catch (e) {
    //   debugPrint(e.runtimeType.toString());
    //   if (e.runtimeType == StateError) {
    //     UserProfile profile = (await getProfile(uid: userId))!;
    //     editProfile(null,url_pic: profile.image_url, bio: profile.bio,full_name: profile.full_name,handle: profile.handle);
    //   }
    // }
  }

  void likeOrUnlike(String bookId, bool isLiked) {
    if (isLiked) {
      // Removes the like from the user's liked books list.
      FirebaseFirestore.instance
          .collection('user_profiles') // collection we are adding to
          .doc(userId)
          .collection('liked_books')
          .doc(bookId)
          .delete();
    } else {
      // adds the like to the user's liked books list
      FirebaseFirestore.instance
          .collection('user_profiles') // collection we are adding to
          .doc(userId)
          .collection('liked_books')
          .doc(bookId)
          .withConverter<Like>(
            fromFirestore: (snapshot, _) =>
                Like.fromJson(snapshot.id, snapshot.data()!),
            toFirestore: (like, _) => like.toJson(),
          )
          .set(Like(book_id: bookId));
    }
    // debugPrint('does it store the like??');
    // update the like counter on the book. This is not scalable. TODO: implement distributed counter here.
    FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference<Book> reference =
          FirebaseFirestore.instance.doc('books/$bookId').withConverter<Book>(
                fromFirestore: (snapshot, _) =>
                    Book.fromJson(snapshot.id, snapshot.data()!),
                toFirestore: (book, _) => book.toJson(),
              );
      DocumentSnapshot<Book> bookSnap = await transaction.get(reference);
      int newLikesCount = bookSnap.data()!.likes +
          (isLiked
              ? -1
              : 1); // check whether it's liked or not, then add or remove accordingly
      transaction.update(bookSnap.reference, {'likes': newLikesCount});
      return newLikesCount;
    });
  }

  Future<void> setBookmark(
      {required String bookId,
      required String location,
      required String settings,
      required String theme}) async {
    FirebaseFirestore.instance
        .collection('user_profiles')
        .doc(userId)
        .collection('bookmarks')
        .doc(bookId)
        .set({
      'location': location,
      'timestamp': FieldValue.serverTimestamp(),
      'settings': settings,
      'theme': theme
    });
  }

  Future<Map<String, dynamic>?> getBookmark({required String bookId}) async {
    return (await FirebaseFirestore.instance
            .collection('user_profiles')
            .doc(userId)
            .collection('bookmarks')
            .doc(bookId)
            .get())
        .data();
  }

  Future<void> logOut(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
  }

  Future<void> deleteAccount(BuildContext context) async {

    bool isSure = await Alert()
        .isSure(context, 'your entire account and every book in it.');
    bool error = false;
    if (isSure) {
      try {
        // delete all of the user's books
        await FirebaseFirestore.instance
            .collection('books') // collection we are deleting from
            .where('author_id', isEqualTo: userId)
            .withConverter<Book>(
              fromFirestore: (snapshot, _) =>
                  Book.fromJson(snapshot.id, snapshot.data()!),
              toFirestore: (book, _) => book.toJson(),
            )
            .get()
            .then((snapshot) {
          for (DocumentSnapshot<Book> ds in snapshot.docs) {
            deleteBook(book: ds.data()!);
          }
        });

        // delete the user's account
        await FirebaseAuth.instance.currentUser!.delete();
        Navigator.of(context).pop();
      } catch (e) {
        Alert().error(
            context, 'We had some issues deleting your books or account');
        error = true;
      }

    }
    // log this action
    await FirebaseAnalytics.instance.logEvent(
      name: "deactivate_account",
      parameters: {
        "confirmed": isSure,
        "error": error,
      },
    );
  }
}
