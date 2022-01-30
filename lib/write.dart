import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'dart:ui' as ui;

class Write extends StatelessWidget {
  // const Write({Key? key}) : super(key: key);

  HtmlEditorController controller = HtmlEditorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('write'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.save)),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 40),
          HtmlEditor(
            controller: controller, //required
            htmlEditorOptions: const HtmlEditorOptions(
              autoAdjustHeight: true,
              adjustHeightForKeyboard: true,
              hint: "Copy/Paste or type under this line...",
              // initialText: "and it came to pass...",
            ),
            otherOptions: const OtherOptions(
              height: 400,
            ),
          ),
        ],
      ),
    );
  }
}
