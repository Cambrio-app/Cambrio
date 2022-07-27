
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/cupertino.dart';

import 'firebase_service.dart';


class PaymentsService {

  static Future<String> addConnectedAccount({required String email, }) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('addConnectedAccount');
    final results = await callable.call(<String, dynamic>{
      'email': email,
      'id': FirebaseService.instance.userId,
    });
    String link = results.data as String;
    return link;
  }

  static Future<String> prepareSubscription({required String author_account_id, required String author_firebase_id, required int price, required String interval}) async {
    debugPrint('preparing a subscription ...');
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('prepareSubscription');
    final results = await callable.call(<String, dynamic>{
      'author_account_id': author_account_id,
      'author_firebase_id': author_firebase_id,
      'price': price,
      'interval': interval,
    });
    return results.data['id'] as String;
  }

  // static Future<String> createSubscription({required String author_account_id, required String customer_id, required int price, required String interval}) async {
  //   HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('createSubscription');
  //   final results = await callable.call(<String, dynamic>{
  //     'author_account_id': author_account_id,
  //     'customer_id': customer_id,
  //   });
  //   return results.data.id;
  // }

  // TODO: why is this an integer value???? also doesn't give the dang price when looked at from another account
  static Future<int> getPriceValue({required String author_account_id, required String price_lookup_key}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getPrice');
    final results = await callable.call(<String, dynamic>{
      'price_lookup_key': price_lookup_key,
      'author_account_id': author_account_id,
    });
    Map<String, dynamic> price = results.data;
    // debugPrint(price.toString());
    // debugPrint(price['unit_amount'].toString());
    return ((price['unit_amount'] as int)/100).round(); // convert cents to dollars
  }

  // identical to the above function, but it returns the whole stripe price object instead of just the integer value.
  static Future<Map<String, dynamic>> getPriceObject({required String author_account_id, required String price_lookup_key}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('getPrice');
    final results = await callable.call(<String, dynamic>{
      'price_lookup_key': price_lookup_key,
      'author_account_id': author_account_id,
    });
    Map<String, dynamic> price = results.data;
    // debugPrint(price.toString());
    // debugPrint(price['unit_amount'].toString());
    return price; // convert cents to dollars
  }

  static Future<String> subscribe({required String author_account_id, required String customer_id, required String price}) async {
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('subscribe');
    final results = await callable.call(<String, dynamic>{
      'author_account_id': author_account_id,
      'customer_id': customer_id,
      'price':price,
    });
    debugPrint('results got');
    debugPrint('in subscribe -------- ${results.data['url']}');
    return results.data['url'];
    // return results.data;
  }

  static Future<bool> isSubscribed({required String author_account_id, required String customer_stripe_id}) async {
    debugPrint('checking whether user ${customer_stripe_id} is subscribed to ${author_account_id}');
    HttpsCallable callable = FirebaseFunctions.instance.httpsCallable('isSubscribed');
    final results = await callable.call(<String, dynamic>{
      'customer_stripe_id': customer_stripe_id,
      'author_account_id': author_account_id,
    });
    debugPrint('results of isSubscribed: ${results.data}');
    if (results.data == null) return false;
    Map<String, dynamic> subscription = results.data;
    // debugPrint(subscription.toString());
    // debugPrint(price['unit_amount'].toString());
    // return subscription.isEmpty;
    return true; // because if the result is empty, the above return statement runs.
  }
}