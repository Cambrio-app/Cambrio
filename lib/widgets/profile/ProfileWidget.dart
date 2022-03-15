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
          imagePath ?? "https://firebasestorage.googleapis.com/v0/b/cambio-46fdc.appspot.com/o/cambrio-cover2-01.png?alt=media&token=64240a30-a53e-4a1f-8630-de1bac56975a",
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
