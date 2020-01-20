import 'package:flutter/material.dart';

class EditableTextField extends StatelessWidget {
  final bool _editEnabled;
  final String _text;
  final String hintText;
  final int minLines;
  final int maxLines;
  final TextEditingController textEditingController =
      new TextEditingController();

  EditableTextField(this._text, this._editEnabled, {this.hintText = "", this.minLines = 1, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    textEditingController.text = _text;
    return TextField(
      controller: textEditingController,
      enabled: _editEnabled,
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(9),
        hintText: "No description",
      ),
      maxLines: maxLines,
      minLines: minLines,
    );
  }
}
