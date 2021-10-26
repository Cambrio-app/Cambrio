import 'package:flutter/material.dart';

class Book extends StatelessWidget {
  const Book({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // margin: EdgeInsets.all(8),
          // mainAxisAlignment: MainAxisAlignment.end,
          Container(
              width: 125.0,
              height: 175.0,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryVariant,
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
          SizedBox(height: 5), //Spacing between book tile and text
          Container(
              padding: new EdgeInsets.only(left: 5.0, right: 5.0),
              //align text better with book margins
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis)),
        ]);
  }
}
