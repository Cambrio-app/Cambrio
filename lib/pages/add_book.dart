
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
  final _title_controller = TextEditingController();
  final _author_controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {

                  // Adds user inputted title to the Firestore database
                  FirebaseFirestore.instance
                      .collection('books') // collection we are adding to
                      .add({'title': _title_controller.text, // what we are adding
                      'author': _author_controller.text }); // what we are adding

                _title_controller.clear();
                _author_controller.clear();
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