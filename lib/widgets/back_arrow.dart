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
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: FloatingActionButton(
                    heroTag: 'back',
                    backgroundColor: Colors.white.withOpacity(1),
                    child: const Icon(Icons.chevron_left_outlined,
                        size: 24, color: Colors.black),
                    onPressed: () => Navigator.of(context).pop()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
