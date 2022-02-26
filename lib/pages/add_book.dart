// Knighten's page to create a new book and add it to the firebase database
// -- WORK IN PROGRESS --

import 'package:cambrio/pages/responsive_main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'dart:ui' as ui;
import 'package:cambrio/pages/write.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // import firestore to access database
import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/models/book.dart';


class AddBook extends StatelessWidget {
  const AddBook({Key? key}) : super(key: key);

  static const String _title = 'Create New Book';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget()
    );
  }
}


class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // each input has a controller
  final _titleController = TextEditingController();
  final _tagController = TextEditingController();
  final _descriptionController = TextEditingController();


  @override

  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // each input has a field for the user to type into
          TextFormField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: 'Enter Title',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter title here';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              hintText: 'Enter Description',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter description here';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _tagController,
            decoration: const InputDecoration(
              hintText: 'Enter Tags',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter tag here';
              }
              return null;
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {
                String? _user_id = FirebaseAuth.instance.currentUser?.uid;
                String? _author_name = "Hardcoded_Full_Name"; // Put current user's name here
                FirebaseService().editBook( // calls function from "firebase_service.dart" file
                  author_id: _user_id,
                  author_name: _author_name,
                  book_id: "bookid123412341234",
                  description: _descriptionController.text,
                  likes: "100",
                  tag: _tagController.text,
                  title: _titleController.text,
                );


                // ------ HOW TO ADD SUB COLLECTION CHAPTERS TO A BOOK -------
                //   FirebaseFirestore.instance
                // .collection('books')
                //     .doc('bBugkn7E6DoRw9DsY1Yh') // the id of the book that is getting chapters
                //     .collection("chapters") // name of new collection you're creating
                //     .add({'1' : '' //data that you want to upload
                // });

                //clear controllers when user hits submit to remove inputted text
                _descriptionController.clear();
                _tagController.clear();
                _titleController.clear();
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}


