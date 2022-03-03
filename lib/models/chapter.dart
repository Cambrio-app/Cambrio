import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

@immutable
class Chapter {
  final String? chapter_id;
  final String chapter_name;
  final String text;
  final int? order;

  const Chapter({
    required this.chapter_id,
    required this.chapter_name,
    required this.text,
    required this.order,
  });

  Chapter.fromJson(String? id, Map<String, Object?> json)
      : this(
    chapter_id: id,
    chapter_name: json['chapter_name']! as String,
    text: json['text']! as String,
    order: json['order']! as int,
  );

  Map<String, Object?> toJson() {
    return {
      'chapter_id': chapter_id,
      'chapter_name': chapter_name,
      'text': text,
      'order': order,
    };
  }
}