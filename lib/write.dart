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
          Text("write or copy/paste your beautiful creation",
              style: TextStyle(
                  height: 5,
                  backgroundColor: Colors.green,
                  foreground: Paint()
                    ..shader = ui.Gradient.linear(
                      const Offset(0, 20),
                      const Offset(150, 20),
                      <Color>[
                        Colors.red,
                        Colors.yellow,
                      ],
                    ),
                  fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 40),
          HtmlEditor(
            controller: controller, //required
            htmlEditorOptions: const HtmlEditorOptions(
              autoAdjustHeight: true,
              adjustHeightForKeyboard: true,
              hint: "Your text here...",
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
