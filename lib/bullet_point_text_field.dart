import 'package:flutter/material.dart';

class BulletPointTextField extends StatefulWidget {
  final List<String> initialValue;
  final ValueChanged<List<String>>? onChanged;

  const BulletPointTextField({
    Key? key,
    this.initialValue = const [''],
    this.onChanged,
  })  : assert(initialValue.length > 0),
        super(key: key);

  @override
  _BulletPointTextFieldState createState() => _BulletPointTextFieldState();
}

class _BulletPointTextFieldState extends State<BulletPointTextField> {
  List<FocusNode> _nodes = [];
  List<TextEditingController> _controllers = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.initialValue.length; i++) {
      _insert(index: i, text: widget.initialValue[i]);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controllers.forEach((controller) => controller.dispose());
    _nodes.forEach((node) => node.dispose());
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

      if (widget.onChanged != null) {
        widget.onChanged!(
            _controllers.map((controller) => controller.text).toList());
      }
    });
    _controllers.insert(index, controller);
    _nodes.insert(index, FocusNode());
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _controllers.length,
      itemBuilder: (context, index) {
        return Focus(
          child: TextField(
            controller: _controllers[index],
            focusNode: _nodes[index],
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
          ),
        );
      },
    );
  }
}
