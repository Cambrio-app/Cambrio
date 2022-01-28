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
              width: 100.0, //was 125
              height: 140.0, //was 170
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
          const SizedBox(height: 2), // Spacing between book tile and text
          Container(
            padding: const EdgeInsets.only(left: 10, right: 10),
            child: SizedBox(
            width: 100,
              //align text better with book margins
              child: Text(title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontWeight: FontWeight.w300),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis)),
          )]);
  }
}
