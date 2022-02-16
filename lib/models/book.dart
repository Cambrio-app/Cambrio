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

  const Book({
    required this.imageURL,
    required this.chapters,
    required this.title,
    required this.id,
    this.num_chapters,
  });

  Book.fromJson(String? id, Map<String, Object?> json)
      : this(
    imageURL: json['imageURL'] as String?,
    chapters: json['chapters'] as CollectionReference<Map<String,Chapter>>?,
    title: json['title']! as String,
    id: id,
    num_chapters: json['num_chapters'] as int?,
  );

  Map<String, Object?> toJson() {
    return {
      'imageURL': imageURL,
      'chapters': chapters,
      'title': title,
      'id': id,
      'num_chapters': num_chapters,
    };
  }
}