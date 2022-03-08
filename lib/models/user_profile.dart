import 'package:cambrio/models/author_subscription.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

@immutable
class UserProfile{
  final String user_id;
  final String? image_url;
  final String? full_name;
  final String? handle;
  final String? bio;
  final CollectionReference<Map<String, AuthorSubscription>>? subscriptions;
  final int? num_likes;
  final int? num_subs;


  const UserProfile({
    required this.user_id,
    required this.image_url,
    required this.full_name,
    required this.handle,
    required this.bio,
    this.subscriptions,
    this.num_likes,
    this.num_subs,
  });


  UserProfile.fromJson(String id, Map<String, Object?> json)
      : this(
    user_id: id,
    image_url: json['image_url'] as String?,
    full_name: json['full_name'] as String?,
    bio: json['bio'] as String?,
    handle: json['handle'] as String?,
    num_likes: json['num_likes'] as int?,
    num_subs: json['num_subs'] as int?,
  );

  Map<String, Object?> toJson() {
    return {
      'image_url': image_url,
      'full_name': full_name,
      'bio': bio,
      'handle': handle,
      'num_likes': num_likes ?? 0,
      'num_subs': num_subs ?? 0,
    };
  }
}