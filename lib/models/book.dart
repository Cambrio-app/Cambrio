import 'package:cambrio/models/chapter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class Book {
  final String? imageURL;
  final String title;
  final String? id;
  final CollectionReference<Map<String,Chapter>>? chapters;
  final int? num_chapters;
  final String? author_id;
  final String? description;
  final String author_name;
  final int likes;
  final String? tags;

  const Book({
    required this.imageURL,
    required this.chapters,
    required this.title,
    required this.id,
    this.num_chapters,
    required this.author_id,
    required this.description,
    required this.author_name,
    required this.likes,
    required this.tags,
  });

  Book.fromJson(String? id, Map<String, Object?> json)
      : this(
    imageURL: json['imageURL'] as String?,
    chapters: json['chapters'] as CollectionReference<Map<String,Chapter>>?,
    title: json['title']! as String,
    id: id,
    num_chapters: json['num_chapters'] as int?,
    author_id: json['author_id'] as String?,
    description: json['description'] as String?,
    author_name: json['author_name'] as String,
    likes: json['likes'] as int,
    tags: json['tags'] as String?,
  );

  Map<String, Object?> toJson() {
    return {
      'imageURL': imageURL,
      'chapters': chapters,
      'title': title,
      'id': id,
      'num_chapters': num_chapters,
      'author_id': author_id,
      'description': description,
      'author_name': author_name,
      'likes': likes,
      'tags': tags,
    };
  }
}