import 'package:flutter/material.dart';

class BulletPointTextField extends StatelessWidget {
  const BulletPointTextField({Key key, this.controller, this.focusNode})
      : super(key: key);

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      cursorColor: Colors.teal,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        border: InputBorder.none,
        prefixText: '\u2022 ',
        prefixStyle: TextStyle(fontSize: 16.0),
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(24, 8, 16, 8),
      ),
      style: TextStyle(fontSize: 16.0),
    );
  }
}
