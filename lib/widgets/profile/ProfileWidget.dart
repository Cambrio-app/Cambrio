import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String? imagePath;

  const ProfileWidget({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Colors.black;

    return buildImage(
      imagePath,
    );
  }

  Widget buildImage(String? imagePath) {

    return ClipOval(
      child: Material(
        child: Image.network(
          imagePath ?? "https://firebasestorage.googleapis.com/v0/b/cambio-46fdc.appspot.com/o/gif-kermityping.gif?alt=media&token=cf28f63b-c8c1-407f-9b2c-277a4d24327a",
          width: 90,
          height: 90,
          fit: BoxFit.cover,
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
