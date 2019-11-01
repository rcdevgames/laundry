import 'package:flutter/material.dart';

class ErrorPage extends StatelessWidget {
  String message;
  String buttonText;
  Function onPressed;
  ErrorPage({Key key, @required this.message, @required this.onPressed, @required this.buttonText}):super(key:key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Icon(Icons.error_outline, size: 60, color: Colors.red,),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Text(message),
          ),
          SizedBox(height: 20),
          RaisedButton(
            child: Text(buttonText, style: TextStyle(color: Colors.white)),
            color: Theme.of(context).primaryColor,
            onPressed: onPressed,
          )
        ],
      ),
    );
  }
}