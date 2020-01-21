import 'package:flutter/material.dart';

class EditableTextField extends StatefulWidget {
  final String _text;
  final bool editEnabled;
  final String hintText;
  final int minLines;
  final int maxLines;
  final Widget icon; 

  EditableTextField(this._text, {this.editEnabled = false, this.hintText = "", this.minLines = 1, this.maxLines = 1, this.icon = null});

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  final TextEditingController textEditingController =
      new TextEditingController();

  @override
  Widget build(BuildContext context) {
    textEditingController.text = widget._text;
    return TextField(
      controller: textEditingController,
      enabled: widget.editEnabled,
      decoration: InputDecoration(
        icon: widget.icon,
        border: InputBorder.none,
        contentPadding: EdgeInsets.all(9),
        hintText: widget.hintText,
      ),
      maxLines: widget.maxLines,
      minLines: widget.minLines,
    );
  }
}
