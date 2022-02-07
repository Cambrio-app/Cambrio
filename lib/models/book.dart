import 'package:cambrio/models/chapter.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class Book {
  const Book({
    required this.imageURL,
    required this.chapters,
    required this.title,
    required this.id,
  });

  Book.fromJson(String? id, Map<String, Object?> json)
      : this(
    imageURL: json['imageURL'] as String,
    chapters: json['chapters'] as CollectionReference<Map<String,Chapter>>?,
    title: json['title']! as String,
    id: id,
  );

  final String imageURL;
  final String title;
  final String? id;
  final CollectionReference<Map<String,Chapter>>? chapters;

  Map<String, Object?> toJson() {
    return {
      'imageURL': imageURL,
      'chapters': chapters,
      'title': title,
      'id': id,
    };
  }
}