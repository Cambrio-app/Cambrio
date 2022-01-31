
// Knighten's page to create a new book and add it to the firebase database
// -- WORK IN PROGRESS --

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'dart:ui' as ui;

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
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
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: ElevatedButton(
              onPressed: () {

                // Validate will return true if the form is valid, or false if
                // the form is invalid.
                if (_formKey.currentState!.validate()) {

                  // Process data.
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



// ORIGINAL PAGE BASED ON Write() Class from write.dart file
// class AddBook extends StatelessWidget {
//   // const Write({Key? key}) : super(key: key);
//
//   HtmlEditorController controller = HtmlEditorController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: false,
//       appBar: AppBar(
//         title: const Text('Create New Book'),
//         actions: [
//           IconButton(
//             onPressed: () {
//               Navigator.pop(context); // returns user to home page after tapping save icon
//               // put code here to get text and send it to the database
//             },
//             icon: const Icon(Icons.save)),
//         ],
//       ),
//       body: Column(
//         children: [
//           const SizedBox(height: 40),
//           HtmlEditor(
//             controller: controller, //required
//             htmlEditorOptions: const HtmlEditorOptions(
//               autoAdjustHeight: true,
//               adjustHeightForKeyboard: true,
//               hint: "Write Title of Book: ",
//               // initialText: "and it came to pass...",
//             ),
//             otherOptions: const OtherOptions(
//               height: 400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
