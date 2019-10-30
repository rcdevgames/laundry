import 'package:flutter/material.dart';

class KABScaffold extends StatelessWidget {
  Widget child;

  KABScaffold({this.child});

  final _key = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  stops: [0.1, 0.3, 0.7, 0.9],
                  colors: [
                    // Colors.yellow[800],
                    // Colors.yellow[700],
                    Color(0xFF0092A9),
                    Color(0xFF0092A9),
                    Color(0xFF005D6E),
                    Color(0xFF005D6E),
                    // Colors.yellow[400],
                  ],
                )
              ),
            ),
            child
          ],
        ),
      ),
    );
  }
}