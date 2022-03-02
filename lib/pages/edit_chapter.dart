import 'package:cambrio/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'dart:ui' as ui;
// import 'package:html_unescape/html_unescape.dart';


import '../models/chapter.dart';

class EditChapter extends StatefulWidget {
  final String book_id;
  final Chapter? chapter;
  final int? num_chapters;

  const EditChapter({Key? key, required this.book_id, this.chapter, this.num_chapters}) : super(key: key);
  @override
  State<EditChapter> createState() => _EditChapterState();
}

class _EditChapterState extends State<EditChapter> {
  HtmlEditorController controller = HtmlEditorController(processOutputHtml: true, processNewLineAsBr: true, );
  late final _chapter_name_controller = TextEditingController(text: widget.chapter?.chapter_name);
  late final _chapter_order_controller = TextEditingController(text: '${widget.chapter?.order ?? (widget.num_chapters ?? 0 +1)}');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('write'),
        actions: [
          IconButton(
              onPressed: () async {
                // convert html
                String originalText = await controller.getText();
                // var unescape = HtmlUnescape();
                // String text = unescape.convert(originalText);
                String text = originalText;

                FirebaseService().editChapter(book_id: widget.book_id, chapter_id: widget.chapter?.chapter_id, chapter_name: _chapter_name_controller.text, order: (_chapter_order_controller.text=='')?null:int.parse(_chapter_order_controller.text), is_paywalled: false, text: text);
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
            htmlEditorOptions: HtmlEditorOptions(
              autoAdjustHeight: true,
              mobileLongPressDuration: Duration(milliseconds: 3),

              adjustHeightForKeyboard: true,
              hint: "Copy/Paste or type here...",
              initialText: widget.chapter?.text,
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
