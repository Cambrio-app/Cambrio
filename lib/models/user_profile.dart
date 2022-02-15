import 'package:flutter/material.dart';

@immutable
class UserProfile{
  final String? imageURL;
  final String? full_name;
  final String? handle;
  final String? bio;

  const UserProfile({
    required this.imageURL,
    required this.full_name,
    required this.handle,
    required this.bio, 
  });


  UserProfile.fromJson(String? id, Map<String, Object?> json)
      : this(
    imageURL: json['imageURL'] as String?,
    full_name: json['full_name'] as String?,
    bio: json['bio'] as String?,
    handle: json['handle'] as String?,
  );

  Map<String, Object?> toJson() {
    return {
      'imageURL': imageURL,
      'full_name': full_name,
      'bio': bio,
      'handle': handle,
    };
  }
}