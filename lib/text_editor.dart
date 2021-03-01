import 'package:flutter/material.dart';
import 'text_field.dart';

class TextEditor extends StatefulWidget {
  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  List<FocusNode> _nodes = [];
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    _insert(index: 0);
  }

  void _insert({required int index, String text = ''}) {
    final TextEditingController controller =
        TextEditingController(text: '\u200B' + text);
    controller.addListener(() {
      if (!controller.text.startsWith('\u200B')) {
        final int index = _controllers.indexOf(controller);
        if (index > 0) {
          final prevController = _controllers[index - 1];
          prevController.text += controller.text;
          prevController.selection = TextSelection.fromPosition(TextPosition(
              offset: prevController.text.length - controller.text.length));
          _nodes[index - 1].requestFocus();
          _controllers.removeAt(index);
          _nodes.removeAt(index);
          setState(() {});
        } else {
          controller.text = '\u200B';
          controller.selection =
              TextSelection.fromPosition(TextPosition(offset: 1));
        }
      } else if (controller.text.contains('\n')) {
        final int index = _controllers.indexOf(controller);
        List<String> points = controller.text.split('\n');
        controller.text = points.first;
        if (points.length == 2) {
          _insert(
            index: index + 1,
            text: points.last,
          );
          _controllers[index + 1].selection =
              TextSelection.fromPosition(TextPosition(offset: 1));
          _nodes[index + 1].requestFocus();
        } else {
          for (var i = 1; i < points.length; i++) {
            _insert(
              index: index + i,
              text: points[i],
            );
          }
          final lastController = _controllers[index + points.length - 1];
          lastController.selection = TextSelection.fromPosition(
            TextPosition(offset: lastController.text.length),
          );
          _nodes[index + points.length - 1].requestFocus();
        }
        setState(() {});
      }
    });
    _controllers.insert(index, controller);
    _nodes.insert(index, FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _controllers.length,
        itemBuilder: (context, index) {
          return Focus(
            child: BulletPointTextField(
              controller: _controllers[index],
              focusNode: _nodes[index],
            ),
          );
        },
      ),
    );
  }
}
