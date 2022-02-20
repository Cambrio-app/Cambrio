import 'package:cloud_firestore/cloud_firestore.dart';

class AuthorSubscription {
  final String author_id;
  final Timestamp time_subscribed;
  // final String? handle;
  // final String? bio;


  const AuthorSubscription({
    required this.author_id,
    required this.time_subscribed,
    // required this.handle,
    // required this.bio,
  });


  AuthorSubscription.fromJson(String? id, Map<String, Object?> json)
      : this(
    author_id: json['author_id'] as String,
    time_subscribed: json['time_subscribed'] as Timestamp,
    // bio: json['bio'] as String?,
    // handle: json['handle'] as String?,
  );

  Map<String, Object?> toJson() {
    return {
      'author_id': author_id,
      'time_subscribed': time_subscribed,
      // 'bio': bio,
      // 'handle': handle,
    };
  }
}