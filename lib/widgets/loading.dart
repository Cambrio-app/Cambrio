import 'package:flutter/material.dart';

class Load{

  void showLoading(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black26,
      builder: (BuildContext context) {
        return const Center(
          child: SizedBox(
                child: CircularProgressIndicator(
                    strokeWidth: 10,
                ),
                width: 50,
                height: 50,
            ),
        );
      },
    );
  }
}