import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../pages/profile/editProfile.dart';

class ShadowButton extends StatelessWidget {
  final Function() onclick;
  String text;


  ShadowButton({Key? key, required this.text, required this.onclick}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(75, 0, 75, 0),
      child: Container(
        //color: Colors.black,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.04,
          minWidth: MediaQuery.of(context).size.width,
      ),
        // height: MediaQuery.of(context).size.height * 0.04,
        padding: const EdgeInsets.only(top: 3, bottom: 3, right: 4),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          color: Colors.white,
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
        child: MaterialButton(
          height: 40,
          onPressed: () {
            onclick.call();
          },
          color: Colors.white,
          elevation: 0,
          child: Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 18,
            ),
          ),
        ),
      ),
    );
  }

}