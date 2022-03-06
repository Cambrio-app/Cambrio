// Knighten's page to create a new book and add it to the firebase database
// -- WORK IN PROGRESS --

import 'package:cambrio/pages/responsive_main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'dart:ui' as ui;
import 'package:cambrio/pages/edit_chapter.dart';

import 'package:cloud_firestore/cloud_firestore.dart'; // import firestore to access database
import 'package:cambrio/services/firebase_service.dart';
import 'package:cambrio/models/book.dart';

class EditBook extends StatefulWidget {
  final DocumentSnapshot<Book>? bookSnap;
  const EditBook({Key? key, this.bookSnap}) : super(key: key);

  final String title = 'Create New Book';

  @override
  State<EditBook> createState() => _EditBookState();
}

class _EditBookState extends State<EditBook> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late final Book? book = widget.bookSnap?.data();
  // each input has a controller
  late final _titleController = TextEditingController(text: book?.title);
  late final _tagController = TextEditingController(text: book?.tags);
  late final _descriptionController =
      TextEditingController(text: book?.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(onPressed: () async => submit(), icon: const Icon(Icons.save)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Form(
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
                  onPressed: () async => submit(),
                  child: const Text('Submit'),
                ),
              ),
              if (book!=null) Expanded(
                child: Align(
                  alignment: AlignmentDirectional.bottomStart,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.red)),
                      onPressed: () {
                        FirebaseService().deleteBook(book: book!);
                        _descriptionController.clear();
                        _tagController.clear();
                        _titleController.clear();

                        // Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => ResponsivePage(title: '', selectedIndex: 2,)),
                              (Route<dynamic> route) => false,
                        );
                      },
                      child: const Text('Delete Book'),
                    ),
                  ),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  Future<void> submit () async {

    String? _user_id = FirebaseAuth.instance.currentUser?.uid;
    String? _author_name =
        (await FirebaseService().currentUserProfile)
        .full_name; // Put current user's name here
    FirebaseService().editBook(
    book: Book(
    // calls function from "firebase_service.dart" file
    imageURL: null,
    author_id: _user_id,
    author_name: _author_name ?? 'anonymous',
    description: _descriptionController.text,
    likes: book?.likes ?? 0,
    title: _titleController.text,
    tags: _tagController.text,
    chapters: book?.chapters,
    id: book?.id,
    ));

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

    Navigator.of(context).pop();
    // instead do this, which refreshes state
    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => ResponsivePage(title: '', selectedIndex: 2,)),
    //       (Route<dynamic> route) => false,
    // );
  }
}
