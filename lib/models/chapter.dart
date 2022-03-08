import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class Chapter {
  final String? chapter_id;
  final String? book_id;
  final String chapter_name;
  final String text;
  final int? order;
  final Timestamp? time_written;


  const Chapter({
    required this.chapter_id,
    required this.book_id,
    required this.chapter_name,
    required this.text,
    required this.order,
    required this.time_written,
  });

  Chapter.fromJson(String? id, Map<String, Object?> json)
      : this(
    chapter_id: id,
    book_id: json['book_id'] as String?,
    chapter_name: json['chapter_name']! as String,
    text: json['text']! as String,
    order: json['order']! as int,
    time_written: json['time_written'] as Timestamp?,
  );

  Map<String, Object?> toJson() {
    return {
      'chapter_id': chapter_id,
      'book_id': book_id,
      'chapter_name': chapter_name,
      'text': text,
      'order': order,
      'time_written': time_written,
    };
  }
}