import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'state_management.dart';
import 'text_field.dart';

class TextEditor extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<EditorProvider>(
        builder: (context, state, _) {
          return ListView.builder(
            itemCount: state.length,
            itemBuilder: (context, index) {
              return Focus(
                child: BulletPointTextField(
                  controller: state.textAt(index),
                  focusNode: state.nodeAt(index),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
