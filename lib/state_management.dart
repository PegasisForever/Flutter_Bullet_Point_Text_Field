import 'package:flutter/material.dart';

class EditorProvider extends ChangeNotifier {
  List<FocusNode> _nodes = [];
  List<TextEditingController> _text = [];

  EditorProvider() {
    insert(index: 0);
  }

  int get length => _text.length;

  int get focus => _nodes.indexWhere((node) => node.hasFocus);

  FocusNode nodeAt(int index) => _nodes.elementAt(index);

  TextEditingController textAt(int index) => _text.elementAt(index);

  void insert({required int index, String text = ''}) {
    final TextEditingController controller =
        TextEditingController(text: '\u200B' + text);
    controller.addListener(() {
      if (!controller.text.startsWith('\u200B')) {
        final int index = _text.indexOf(controller);
        if (index > 0) {
          textAt(index - 1).text += controller.text;
          textAt(index - 1).selection = TextSelection.fromPosition(TextPosition(
              offset: textAt(index - 1).text.length - controller.text.length));
          nodeAt(index - 1).requestFocus();
          _text.removeAt(index);
          _nodes.removeAt(index);
          notifyListeners();
        } else {
          controller.text = '\u200B';
          controller.selection =
              TextSelection.fromPosition(TextPosition(offset: 1));
        }
      } else if (controller.text.contains('\n')) {
        final int index = _text.indexOf(controller);
        List<String> points = controller.text.split('\n');
        controller.text = points.first;
        if (points.length == 2) {
          insert(
            index: index + 1,
            text: points.last,
          );
          textAt(index + 1).selection =
              TextSelection.fromPosition(TextPosition(offset: 1));
          nodeAt(index + 1).requestFocus();
        } else {
          for (var i = 1; i < points.length; i++) {
            insert(
              index: index + i,
              text: points[i],
            );
          }
          final lastController = textAt(index + points.length - 1);
          lastController.selection = TextSelection.fromPosition(
            TextPosition(offset: lastController.text.length),
          );
          nodeAt(index + points.length - 1).requestFocus();
        }
        notifyListeners();
      }
    });
    _text.insert(index, controller);
    _nodes.insert(index, FocusNode());
  }
}
