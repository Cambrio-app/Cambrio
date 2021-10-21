import 'package:flutter/material.dart';

class Book extends StatelessWidget {
  const Book({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      // margin: EdgeInsets.all(8),
      // mainAxisAlignment: MainAxisAlignment.end,
      child: Container(
        padding: const EdgeInsets.all(10),
        alignment: Alignment.bottomCenter,
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      color: Theme.of(context).colorScheme.secondaryVariant,
    );
  }
}
