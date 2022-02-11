import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_summernote/fl/utter_summernote.dart';
import 'dart:ui' as ui;

class Write extends StatelessWidget {
  // const Write({Key? key}) : super(key: key);

  // final GlobalKey<FlutterSummernoteState> _keyEditor = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('write'),
        actions: [
          IconButton(
            onPressed: () async {
              // final _etEditor = await _keyEditor.currentState!.getText();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          // quill.QuillToolbar.basic(controller: _controller),
          Expanded(
            child: Text('eh'),
            // child: Container(
            //   child: FlutterSummernote(
            //       hint: "Your text here...",
            //       key: _keyEditor
            //   ),
              // child: quill.QuillEditor.basic(
              //   controller: _controller,
              //   readOnly: false, // true for view only mode
              // ),
            // ),
          ),
        ],
      ),
    );
  }
}
