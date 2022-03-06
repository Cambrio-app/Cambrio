
import 'package:flutter/material.dart';

class Alert {
  Future<bool> isSure(context) async {
    bool goAhead = false;
    await showDialog<bool>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure about that?'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                // const Text('Are you sure about that?'),
                Image.network(
                  "https://firebasestorage.googleapis.com/v0/b/cambio-46fdc.appspot.com/o/john-cena-are-you-sure-about-that-white.gif?alt=media&token=31fbf8fe-7c4b-4ed1-965e-5b6dbaa5ef99",
                  width: 90,
                  height: 90,
                  fit: BoxFit.fitHeight,
                ),
                const Text("Clicking 'Approve' will delete your chapter."),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("Don't delete!"),
              onPressed: () {
                goAhead = false;
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                goAhead = true;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    return goAhead;
  }
}