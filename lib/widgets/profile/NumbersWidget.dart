import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _buildButton(context, '27k', 'Subscribers'),
      // SizedBox(width: 7.0),
      _buildButton(context, '1.4M', 'Likes'),
    ],
  );
  Widget _buildButton(BuildContext context, String value, String text) =>
  Expanded(
    child: MaterialButton(
       padding: EdgeInsets.symmetric(vertical: 4),
          onPressed: () {},
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black,
                fontFamily: 'Montserrat-Semibold'),
              ),
              SizedBox(height: 2),
              Text(
                text,
                style: TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Montserrat-Semibold'),
              ),
            ],
          ),
    ),
  );
}