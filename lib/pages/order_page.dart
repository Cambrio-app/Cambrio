import 'package:beamer/beamer.dart';
import 'package:cambrio/main.dart';
import 'package:flutter/material.dart';

import '../widgets/shadow_button.dart';

class OrderPage extends StatefulWidget {
  final String orderId;
  const OrderPage({Key? key, required this.orderId}) : super(key: key);

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              height: 170,
              padding: EdgeInsets.all(35),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                "assets/images/card.png",
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.1),
            Text(
              "Thank You!",
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
                fontSize: 36,
              ),
            ),
            SizedBox(height: screenHeight * 0.01),
            const Text(
              "Payment done Successfully",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
                fontSize: 17,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),
            const Text(
              "You will be redirected to the home page shortly\nor click here to return to home page",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
            SizedBox(height: screenHeight * 0.06),
            Flexible(
              child: ShadowButton(
                onclick: () {
                  debugPrint('trying to do something');
                  Beamer.of(context).beamToReplacementNamed('/home', stacked: false);
                },
                text: 'go to the home page',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
