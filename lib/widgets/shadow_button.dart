import 'package:flutter/material.dart';

import '../models/user_profile.dart';
import '../pages/profile/editProfile.dart';

class ShadowButton extends StatelessWidget {
  final Function() onclick;
  String text;
  IconData? icon;

  ShadowButton({Key? key, required this.text, required this.onclick, this.icon}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      child: Container(
        //color: Colors.black,
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height * 0.03,
          maxHeight: MediaQuery.of(context).size.height * 0.04,
          // minWidth: MediaQuery.of(context).size.width,
          maxWidth: 600,
      ),
        // height: MediaQuery.of(context).size.height * 0.04,
        padding: const EdgeInsets.only(top: 0, bottom: 0, right: 0),
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
          height: 2,
          onPressed: () {
            onclick.call();
          },
          color: Colors.white,
          elevation: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon!=null) Padding(
                padding: const EdgeInsets.fromLTRB(0,0,8,0),
                child: Icon(icon),
              ),
              Text(
                text,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: "Montserrat",
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}