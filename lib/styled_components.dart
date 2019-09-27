import 'package:flutter/material.dart';

class StyledTitle extends StatelessWidget {
  List<String> text;

  StyledTitle(String _text) {
    text = _text.split('_');
  }

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
        children: <TextSpan>[
          TextSpan(
            text: text[0],
            style: TextStyle(
              decoration: TextDecoration.underline,
              decorationColor: Theme.of(context).accentColor,
              decorationThickness: 2.0
            )
          ),
          TextSpan(
            text: text[1]
          ),
        ],
      ),
    );
  }
}