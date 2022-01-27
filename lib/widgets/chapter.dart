import 'package:flutter/material.dart';
import 'package:cambrio/main.dart';

class Chapter extends StatelessWidget {
  const Chapter({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(
              width: 350.0,
              height: 75.0,
              child: Align(
                  alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(title,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 18, fontFamily: "Unna"),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis),
                )),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                color: Colors.white,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black,
                    offset: Offset(
                      3, // Move to right 3  horizontally
                      3, // Move to bottom 3 Vertically
                    ),
                  )
                ],
              ),
              padding: const EdgeInsets.all(0),
              alignment: Alignment.topCenter),
        ]);
  }
}
