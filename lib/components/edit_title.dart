import 'package:flutter/material.dart';
import 'package:casa/components/styled_components.dart';

class EditTitle extends StatelessWidget {
  final String text;

  EditTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          StyledTitle(text)
        ],
      )
    );
  }
}