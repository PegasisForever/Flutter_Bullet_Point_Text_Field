import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state_management.dart';
import 'text_field.dart';

class TextEditor extends StatefulWidget {
  TextEditor({Key key}) : super(key: key);

  @override
  _TextEditorState createState() => _TextEditorState();
}

class _TextEditorState extends State<TextEditor> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<EditorProvider>(
      create: (context) => EditorProvider(),
      builder: (context, child) {
        return SafeArea(
          child: Scaffold(
            body: Stack(
              children: <Widget>[
                Positioned(
                  top: 16,
                  left: 0,
                  right: 0,
                  bottom: 56,
                  child: Consumer<EditorProvider>(
                    builder: (context, state, _) {
                      return ListView.builder(
                        itemCount: state.length,
                        itemBuilder: (context, index) {
                          return Focus(
                            child: SmartTextField(
                              controller: state.textAt(index),
                              focusNode: state.nodeAt(index),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
