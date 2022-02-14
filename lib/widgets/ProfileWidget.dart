import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final dynamic imagePath;

  const ProfileWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.black;

    return Center(
      child: buildImage(
        imagePath,
      ),
    );
  }

  Widget buildImage(String imagePath) {
    return ClipOval(
      child: Material(
        child: Image.network(
          "http://www.dwrl.utexas.edu/wp-content/uploads/2016/04/gif-kermityping.gif",
          width: 150,
          height: 150,
          fit: BoxFit.fitHeight,
        ),

        // imagePath != '' ?
        // Image.file(File(imagePath),
        // width: 150,
        // height: 150) : Image.asset('assets/pictures/pic.png',
        // width: 150,
        // height: 150
        // ),
      ),
    );
  }
}
