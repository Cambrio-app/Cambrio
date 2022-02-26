import 'package:cloud_firestore/cloud_firestore.dart';

class Like {
  final String book_id;
  final Timestamp? time_liked;
  // final String? handle;
  // final String? bio;


  const Like({
    required this.book_id,
    this.time_liked,
    // required this.handle,
    // required this.bio,
  });


  Like.fromJson(String? id, Map<String, Object?> json)
      : this(
    book_id: json['book_id'] as String,
    time_liked: json['time_liked'] as Timestamp,
    // bio: json['bio'] as String?,
    // handle: json['handle'] as String?,
  );

  Map<String, Object?> toJson() {
    return {
      'book_id': book_id,
      'time_liked': time_liked ?? FieldValue.serverTimestamp(),
      // 'bio': bio,
      // 'handle': handle,
    };
  }
}