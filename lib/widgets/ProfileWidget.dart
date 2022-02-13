import 'dart:io';

import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final dynamic imagePath;

  const ProfileWidget({ 
  Key? key, 
  required this.imagePath 
  }) : super(key: key);

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
        child: imagePath != '' ?
        Image.file(File(imagePath), 
        width: 150,
        height: 150) : Image.asset('assets/pictures/pic.png',
        width: 150,
        height: 150
        ),
      ),
    );
  }
}