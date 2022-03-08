import 'package:cambrio/services/firebase_service.dart';
import 'package:flutter/material.dart';

class NumbersWidget extends StatelessWidget {
  int subs;
  int likes;

  String? profile_id;


  NumbersWidget({Key? key, this.profile_id, required this.subs, required this.likes});

  @override
  Widget build(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      _buildButton(context, compactify(subs), 'Subscribers'),
      // SizedBox(width: 7.0),
      _buildButton(context, compactify(likes), 'Likes'),
    ],
  );
  Widget _buildButton(BuildContext context, String value, String text) =>
  Expanded(
    child: MaterialButton(
       padding: EdgeInsets.symmetric(vertical: 4),
          onPressed: () {
            FirebaseService().checkStats(profile_id: profile_id);
          },
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

  // compactify the numbers
  String compactify(int value) {
    const units = <int, String>{
      1000000000: 'B',
      1000000: 'M',
      1000: 'K',
    };
    return units.entries
        .map((e) => '${value ~/ e.key}${e.value}')
        .firstWhere((e) => !e.startsWith('0'), orElse: () => '$value');
  }
}