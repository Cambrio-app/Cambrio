
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackArrow extends StatelessWidget {
  Widget child;

  BackArrow({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Stack(
        children: [
          child,
          SafeArea(
            child: Align(
              alignment: AlignmentDirectional.topStart,
              child: Padding(
                padding: EdgeInsets.fromLTRB(10,50,20,20),
                child: FloatingActionButton(backgroundColor: Colors.white.withOpacity(1), child: Icon(Icons.chevron_left_outlined, size: 24, color: Colors.black),onPressed: () => Navigator.of(context).pop()),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
}