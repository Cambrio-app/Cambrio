import 'package:cambrio/services/firebase_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';

import '../../util/numbers_display.dart';

class NumbersWidget extends StatelessWidget {
  int subs;
  int likes;

  String profile_id;


  NumbersWidget({Key? key, required this.profile_id, required this.subs, required this.likes});

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
       padding: const EdgeInsets.symmetric(vertical: 4),
          onPressed: () {
            FirebaseAnalytics.instance
                .logSelectContent(
              contentType: 'refresh_subs/likes',
              itemId: profile_id,
            );
            FirebaseService().checkStats(profile_id: profile_id);
          },
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                value,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black,
                fontFamily: 'Montserrat-Semibold'),
              ),
              const SizedBox(height: 2),
              Text(
                text,
                style: const TextStyle(fontWeight: FontWeight.bold,fontFamily: 'Montserrat-Semibold'),
              ),
            ],
          ),
    ),
  );
}