import 'package:cambrio/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'dart:ui' as ui;

class Write extends StatefulWidget {
  final String book_id;
  final String? chapter_id;
  final int? num_chapters;

  const Write({Key? key, required this.book_id, this.chapter_id, this.num_chapters}) : super(key: key);
  @override
  State<Write> createState() => _WriteState();
}

class _WriteState extends State<Write> {
  HtmlEditorController controller = HtmlEditorController();
  final _chapter_name_controller = TextEditingController();
  late final _chapter_order_controller = TextEditingController(text: '${widget.num_chapters ?? 0}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('write'),
        actions: [
          IconButton(
              onPressed: () async {
                FirebaseService().editChapter(book_id: widget.book_id, chapter_id: widget.chapter_id, chapter_name: _chapter_name_controller.text, order: (_chapter_order_controller.text=='')?null:int.parse(_chapter_order_controller.text), is_paywalled: false, text: await controller.getText());
                Navigator.pop(context);
              },
              icon: const Icon(Icons.save)),
        ],
      ),
      body: Column(
        children: [
          TextFormField(
            controller: _chapter_name_controller,

            decoration: const InputDecoration(
              hintText: 'Enter Chapter Name',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter title here';
              }
              return null;
            },
          ),
          TextFormField(
            controller: _chapter_order_controller,
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.allow(RegExp(r'[0-9]?')),
            ],
            decoration: const InputDecoration(
              hintText: 'Enter Chapter Order (is this the 1st chapter or the 8th?)',
              helperText: 'Enter Chapter Order (is this the 1st chapter or the 8th?)',
            ),
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Please enter title here';
              }
              return null;
            },
          ),
          const SizedBox(height: 40),
          HtmlEditor(
            controller: controller, //required
            htmlEditorOptions: const HtmlEditorOptions(
              autoAdjustHeight: true,
              mobileLongPressDuration: Duration(milliseconds: 3),
              adjustHeightForKeyboard: true,
              hint: "Copy/Paste or type here...",
              // initialText: "",

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
