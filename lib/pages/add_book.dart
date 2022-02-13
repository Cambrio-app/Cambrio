
// Knighten's page to create a new book and add it to the firebase database
// -- WORK IN PROGRESS --

import 'package:cambrio/pages/responsive_main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'dart:ui' as ui;
import 'package:cambrio/pages/write.dart';

import 'package:cloud_firestore/cloud_firestore.dart';  // import firestore to access database


class AddBook extends StatelessWidget {
  const AddBook({Key? key}) : super(key: key);

  static const String _title = 'Create New Book';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const MyStatefulWidget(),
      ),
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
  final _title_controller = TextEditingController();
  final _author_controller = TextEditingController();
  final _description_controller = TextEditingController();
  final _tags_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[

          // each input has a field for the user to type into
          TextFormField(
            controller: _title_controller,
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
            controller: _author_controller,
            decoration: const InputDecoration(
              hintText: 'Enter Author',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter author here';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _description_controller,
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
            controller: _tags_controller,
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
              onPressed: () async {
                if (_formKey.currentState!.validate()) {

                  // Adds user inputted title to the Firestore database
                  FirebaseFirestore.instance
                      .collection('books') // collection we are adding to
                      .add({'title': _title_controller.text, // what we are adding
                      'author_name': _author_controller.text,
                      'description': _description_controller.text,
                      'tag': _tags_controller.text,

                    // Dummy hardcoded values
                    'author_id': 'abcdefghijk',
                    'likes': '100',
                    'book_id': '12345678910', // already autogenerated
                  });


                  // ------ HOW TO ADD SUB COLLECTION CHAPTERS TO A BOOK -------
                //   FirebaseFirestore.instance
                // .collection('books')
                //     .doc('bBugkn7E6DoRw9DsY1Yh') // the id of the book that is getting chapters
                //     .collection("chapters") // name of new collection you're creating
                //     .add({'1' : '' //data that you want to upload
                // });

                  //clear controllers when user hits submit to remove inputted text
                _title_controller.clear();
                _author_controller.clear();
                _description_controller.clear();
                _tags_controller.clear();
                }
              },
              child: const Text('Submit'),
            ),
          ),
        ],
      ),
    );
  }
}